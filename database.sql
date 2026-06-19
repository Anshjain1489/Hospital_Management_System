-- ====================================================================
--  ANSH HOSPITAL MANAGEMENT SYSTEM
--  Full Database Script — Version 2.0
--  Author : Ansh Jain (BCA Student)
--  Date   : 2026-06-19
--
--  HOW TO RUN:
--    mysql -u root -p < database.sql
--  OR paste directly in MySQL Workbench / phpMyAdmin.
--
--  SAFE TO RUN ON EXISTING DATABASE:
--    Uses CREATE TABLE IF NOT EXISTS + ALTER TABLE for new columns.
--    Will NOT drop or truncate existing data.
-- ====================================================================

-- ─────────────────────────────────────────────────────────────────────
--  1. DATABASE
-- ─────────────────────────────────────────────────────────────────────

CREATE DATABASE IF NOT EXISTS hospital_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE hospital_db;

-- ─────────────────────────────────────────────────────────────────────
--  2. TABLE: users  (Admin / Staff Accounts)
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
    user_id    INT           NOT NULL AUTO_INCREMENT,
    name       VARCHAR(100)  NOT NULL,
    email      VARCHAR(150)  NOT NULL,
    password   VARCHAR(255)  NOT NULL  COMMENT 'BCrypt hashed — NEVER plain text',
    otp        VARCHAR(10)   DEFAULT NULL,
    otp_status ENUM('Pending','Verified') NOT NULL DEFAULT 'Pending',
    created_at TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────────────
--  3. TABLE: doctors
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS doctors (
    doctor_id      INT           NOT NULL AUTO_INCREMENT,
    name           VARCHAR(100)  NOT NULL,
    specialization VARCHAR(100)  DEFAULT NULL,
    mobile         VARCHAR(15)   DEFAULT NULL,
    email          VARCHAR(150)  DEFAULT NULL,
    fees           DECIMAL(10,2) NOT NULL DEFAULT 500.00,
    image          VARCHAR(255)  DEFAULT NULL  COMMENT 'Filename stored in webapp/images/',
    created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (doctor_id),
    KEY idx_doctors_specialization (specialization)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────────────
--  4. TABLE: patients
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT          NOT NULL AUTO_INCREMENT,
    name       VARCHAR(100) NOT NULL,
    age        TINYINT UNSIGNED DEFAULT NULL,
    gender     ENUM('Male','Female','Other') DEFAULT NULL,
    mobile     VARCHAR(15)  DEFAULT NULL,
    address    TEXT         DEFAULT NULL,
    disease    VARCHAR(200) DEFAULT NULL,
    aadhaar    VARCHAR(20)  DEFAULT NULL,
    doctor_id  INT          DEFAULT NULL  COMMENT 'Assigned doctor (optional)',
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (patient_id),
    KEY idx_patients_mobile    (mobile),
    KEY idx_patients_doctor_id (doctor_id),
    CONSTRAINT fk_patients_doctor
        FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────────────
--  5. TABLE: appointments
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id   INT  NOT NULL AUTO_INCREMENT,
    patient_id       INT  NOT NULL,
    doctor_id        INT  NOT NULL,
    appointment_date DATE DEFAULT NULL,
    status           ENUM('Pending','Confirmed','Cancelled') NOT NULL DEFAULT 'Pending',
    payment_status   ENUM('Unpaid','Paid')                  NOT NULL DEFAULT 'Unpaid',
    payment_id       VARCHAR(100) DEFAULT NULL  COMMENT 'Razorpay payment_id on success',
    created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (appointment_id),
    KEY idx_appt_patient_id       (patient_id),
    KEY idx_appt_doctor_id        (doctor_id),
    KEY idx_appt_status           (status),
    KEY idx_appt_appointment_date (appointment_date),
    CONSTRAINT fk_appt_patient
        FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_appt_doctor
        FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────────────
--  6. TABLE: payments
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS payments (
    payment_id          INT            NOT NULL AUTO_INCREMENT,
    appointment_id      INT            NOT NULL,
    razorpay_payment_id VARCHAR(100)   DEFAULT NULL,
    amount              DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    payment_status      ENUM('Paid','Failed','Refunded') NOT NULL DEFAULT 'Paid',
    created_at          TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (payment_id),
    KEY idx_payments_appointment_id (appointment_id),
    CONSTRAINT fk_payments_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────────────
--  7. SAFE MIGRATIONS — Add columns if they don't exist yet
--     (For existing databases that were created without these columns)
-- ─────────────────────────────────────────────────────────────────────

-- appointments.status
SET @col_exists = (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'hospital_db'
      AND TABLE_NAME   = 'appointments'
      AND COLUMN_NAME  = 'status'
);
SET @sql = IF(@col_exists = 0,
    "ALTER TABLE appointments ADD COLUMN status ENUM('Pending','Confirmed','Cancelled') NOT NULL DEFAULT 'Pending' AFTER appointment_date",
    "SELECT 'Column status already exists' AS info"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- appointments.payment_status
SET @col_exists = (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'hospital_db'
      AND TABLE_NAME   = 'appointments'
      AND COLUMN_NAME  = 'payment_status'
);
SET @sql = IF(@col_exists = 0,
    "ALTER TABLE appointments ADD COLUMN payment_status ENUM('Unpaid','Paid') NOT NULL DEFAULT 'Unpaid' AFTER status",
    "SELECT 'Column payment_status already exists' AS info"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- appointments.payment_id
SET @col_exists = (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'hospital_db'
      AND TABLE_NAME   = 'appointments'
      AND COLUMN_NAME  = 'payment_id'
);
SET @sql = IF(@col_exists = 0,
    "ALTER TABLE appointments ADD COLUMN payment_id VARCHAR(100) DEFAULT NULL AFTER payment_status",
    "SELECT 'Column payment_id already exists' AS info"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- doctors.fees (in case old schema had different type)
SET @col_exists = (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'hospital_db'
      AND TABLE_NAME   = 'doctors'
      AND COLUMN_NAME  = 'fees'
);
SET @sql = IF(@col_exists = 0,
    "ALTER TABLE doctors ADD COLUMN fees DECIMAL(10,2) NOT NULL DEFAULT 500.00 AFTER email",
    "SELECT 'Column fees already exists' AS info"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- users.otp_status
SET @col_exists = (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'hospital_db'
      AND TABLE_NAME   = 'users'
      AND COLUMN_NAME  = 'otp_status'
);
SET @sql = IF(@col_exists = 0,
    "ALTER TABLE users ADD COLUMN otp_status ENUM('Pending','Verified') NOT NULL DEFAULT 'Pending' AFTER otp",
    "SELECT 'Column otp_status already exists' AS info"
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ─────────────────────────────────────────────────────────────────────
--  8. SAMPLE DATA  ← READY TO USE (runs only if tables are empty)
-- ─────────────────────────────────────────────────────────────────────

-- ── 8a. Admin User
--    Email    : admin@hospital.com
--    Password : admin123   (BCrypt hash below — generated with BCrypt cost 12)
INSERT INTO users (name, email, password, otp, otp_status)
SELECT 'Ansh Jain',
       'admin@hospital.com',
       '$2a$12$K8HU5WlPGy3RfSQ.F4vDXuaHMXFPJV3N.lBkHm6sIE4XRFU3J0RqG',
       '000000',
       'Verified'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@hospital.com');

-- ── 8b. Doctors
INSERT INTO doctors (name, specialization, mobile, email, fees, image)
SELECT * FROM (
    SELECT 'Dr. Priya Sharma',   'Cardiologist',      '9876543210', 'priya.sharma@hospital.com',   800.00, NULL UNION ALL
    SELECT 'Dr. Rohan Verma',    'Orthopedician',     '9812345678', 'rohan.verma@hospital.com',    700.00, NULL UNION ALL
    SELECT 'Dr. Sneha Patel',    'Neurologist',       '9898765432', 'sneha.patel@hospital.com',    900.00, NULL UNION ALL
    SELECT 'Dr. Amit Gupta',     'Dermatologist',     '9765432109', 'amit.gupta@hospital.com',     600.00, NULL UNION ALL
    SELECT 'Dr. Kavita Singh',   'Gynecologist',      '9756341230', 'kavita.singh@hospital.com',   750.00, NULL UNION ALL
    SELECT 'Dr. Suresh Mehta',   'Pulmonologist',     '9643218765', 'suresh.mehta@hospital.com',   650.00, NULL UNION ALL
    SELECT 'Dr. Ankit Joshi',    'Ophthalmologist',   '9512345670', 'ankit.joshi@hospital.com',    500.00, NULL UNION ALL
    SELECT 'Dr. Deepa Nair',     'Pediatrician',      '9445678901', 'deepa.nair@hospital.com',     550.00, NULL
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM doctors LIMIT 1);

-- ── 8c. Patients
INSERT INTO patients (name, age, gender, mobile, address, disease)
SELECT * FROM (
    SELECT 'Rahul Kumar',    28, 'Male',   '9123456789', 'MG Road, Jhansi, UP',        'Hypertension'     UNION ALL
    SELECT 'Neha Srivastava',35, 'Female', '9234567890', 'Civil Lines, Jhansi, UP',    'Diabetes Type 2'  UNION ALL
    SELECT 'Arjun Singh',    42, 'Male',   '9345678901', 'Sipri Bazar, Jhansi, UP',    'Back Pain'        UNION ALL
    SELECT 'Priya Yadav',    26, 'Female', '9456789012', 'Nagra, Jhansi, UP',          'Migraine'         UNION ALL
    SELECT 'Vikas Dubey',    55, 'Male',   '9567890123', 'Gursarai, Jhansi, UP',       'Chest Pain'       UNION ALL
    SELECT 'Sunita Sharma',  48, 'Female', '9678901234', 'Orchha Road, Jhansi, UP',    'Asthma'           UNION ALL
    SELECT 'Mohit Tiwari',   31, 'Male',   '9789012345', 'Sipri Bazar, Jhansi, UP',    'Fever & Cough'    UNION ALL
    SELECT 'Anjali Gupta',   22, 'Female', '9890123456', 'Cantonment, Jhansi, UP',     'Skin Allergy'     UNION ALL
    SELECT 'Rajesh Patel',   60, 'Male',   '9901234567', 'Mau Ranipur, Jhansi, UP',    'Knee Arthritis'   UNION ALL
    SELECT 'Pooja Mishra',   38, 'Female', '9012345678', 'Shivpuri Link, Jhansi, UP',  'Anxiety Disorder'
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM patients LIMIT 1);

-- ── 8d. Appointments  (relative to current date so data is always "fresh")
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status, payment_status)
SELECT * FROM (
    SELECT 1, 1, CURDATE() - INTERVAL 10 DAY, 'Confirmed', 'Paid'      UNION ALL
    SELECT 2, 4, CURDATE() - INTERVAL  7 DAY, 'Confirmed', 'Paid'      UNION ALL
    SELECT 3, 2, CURDATE() - INTERVAL  5 DAY, 'Confirmed', 'Paid'      UNION ALL
    SELECT 4, 3, CURDATE() - INTERVAL  3 DAY, 'Pending',   'Unpaid'    UNION ALL
    SELECT 5, 1, CURDATE() - INTERVAL  2 DAY, 'Confirmed', 'Paid'      UNION ALL
    SELECT 6, 6, CURDATE() - INTERVAL  1 DAY, 'Pending',   'Unpaid'    UNION ALL
    SELECT 7, 5, CURDATE(),                   'Pending',   'Unpaid'    UNION ALL
    SELECT 8, 7, CURDATE() + INTERVAL  1 DAY, 'Pending',   'Unpaid'    UNION ALL
    SELECT 9, 2, CURDATE() + INTERVAL  2 DAY, 'Confirmed', 'Unpaid'    UNION ALL
    SELECT 10,8, CURDATE() + INTERVAL  3 DAY, 'Cancelled', 'Unpaid'
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM appointments LIMIT 1);

-- ── 8e. Payments (for paid appointments — matching appointment_ids 1,2,3,5 above)
INSERT INTO payments (appointment_id, razorpay_payment_id, amount, payment_status)
SELECT * FROM (
    SELECT 1, 'pay_sample001AAA', 944.00,  'Paid' UNION ALL
    SELECT 2, 'pay_sample002BBB', 708.00,  'Paid' UNION ALL
    SELECT 3, 'pay_sample003CCC', 826.00,  'Paid' UNION ALL
    SELECT 5, 'pay_sample004DDD', 944.00,  'Paid'
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM payments LIMIT 1);

-- ─────────────────────────────────────────────────────────────────────
--  9. USEFUL VIEWS (optional — for reports/analytics)
-- ─────────────────────────────────────────────────────────────────────

CREATE OR REPLACE VIEW vw_appointment_details AS
SELECT
    a.appointment_id,
    p.name           AS patient_name,
    p.age            AS patient_age,
    p.gender         AS patient_gender,
    p.mobile         AS patient_mobile,
    d.name           AS doctor_name,
    d.specialization AS doctor_specialization,
    d.fees           AS doctor_fees,
    a.appointment_date,
    a.status,
    a.payment_status,
    a.payment_id,
    a.created_at
FROM appointments  a
JOIN patients      p ON p.patient_id = a.patient_id
JOIN doctors       d ON d.doctor_id  = a.doctor_id;


CREATE OR REPLACE VIEW vw_revenue_summary AS
SELECT
    YEAR(created_at)  AS year,
    MONTH(created_at) AS month,
    COUNT(*)          AS total_payments,
    SUM(amount)       AS total_revenue
FROM payments
WHERE payment_status = 'Paid'
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year DESC, month DESC;


CREATE OR REPLACE VIEW vw_doctor_stats AS
SELECT
    d.doctor_id,
    d.name,
    d.specialization,
    d.fees,
    COUNT(a.appointment_id)                                         AS total_appointments,
    SUM(a.status = 'Confirmed')                                     AS confirmed_appointments,
    IFNULL(SUM(pay.amount), 0)                                      AS total_revenue_generated
FROM doctors       d
LEFT JOIN appointments a   ON a.doctor_id = d.doctor_id
LEFT JOIN payments     pay ON pay.appointment_id = a.appointment_id AND pay.payment_status = 'Paid'
GROUP BY d.doctor_id;

-- ─────────────────────────────────────────────────────────────────────
--  10. VERIFY — Quick sanity check after running this script
-- ─────────────────────────────────────────────────────────────────────

SELECT 'users'        AS `table`, COUNT(*) AS rows FROM users        UNION ALL
SELECT 'doctors'      AS `table`, COUNT(*) AS rows FROM doctors      UNION ALL
SELECT 'patients'     AS `table`, COUNT(*) AS rows FROM patients     UNION ALL
SELECT 'appointments' AS `table`, COUNT(*) AS rows FROM appointments UNION ALL
SELECT 'payments'     AS `table`, COUNT(*) AS rows FROM payments;

-- ====================================================================
--  END OF SCRIPT
-- ====================================================================
