-- ====================================================================
--  ANSH HOSPITAL MANAGEMENT SYSTEM
--  DATABASE UPDATE SCRIPT  (Safe Migration — v1 → v2)
--  Author : Ansh Jain (BCA Student)
--  Date   : 2026-06-19
--
--  PURPOSE:
--    Run this if you ALREADY HAVE the old hospital_db and want to
--    upgrade it to work with the rewritten Java code.
--    ✅  Will NOT delete any existing data.
--    ✅  Each ALTER uses IF-NOT-EXISTS pattern (safe to run twice).
--
--  HOW TO RUN:
--    Option 1 — Command line :  mysql -u root -p hospital_db < update_database.sql
--    Option 2 — MySQL Workbench / phpMyAdmin : paste & execute
-- ====================================================================

USE hospital_db;

-- ====================================================================
--  STEP 1 — RENAME OLD COLUMN NAMES (if your old schema used these)
-- ====================================================================

-- If your old appointments table used "app_id" instead of "appointment_id"
-- uncomment the line below:
-- ALTER TABLE appointments CHANGE app_id appointment_id INT NOT NULL AUTO_INCREMENT;

-- If your old users table used "id" instead of "user_id"
-- uncomment:
-- ALTER TABLE users CHANGE id user_id INT NOT NULL AUTO_INCREMENT;

-- If your old doctors table used "id" instead of "doctor_id"
-- uncomment:
-- ALTER TABLE doctors CHANGE id doctor_id INT NOT NULL AUTO_INCREMENT;

-- If your old patients table used "id" instead of "patient_id"
-- uncomment:
-- ALTER TABLE patients CHANGE id patient_id INT NOT NULL AUTO_INCREMENT;


-- ====================================================================
--  STEP 2 — USERS TABLE
-- ====================================================================

-- 2a. Widen password column to hold BCrypt hashes (255 chars)
ALTER TABLE users
    MODIFY COLUMN password VARCHAR(255) NOT NULL
    COMMENT 'BCrypt hashed — NEVER plain text';

-- 2b. Add otp_status column (needed by RegisterServlet / OTPServlet)
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS otp_status ENUM('Pending','Verified') NOT NULL DEFAULT 'Pending'
    AFTER otp;

-- 2c. Add created_at column (for audit trail)
ALTER TABLE users
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    AFTER otp_status;

-- 2d. Mark all EXISTING users as Verified so they can still log in
UPDATE users SET otp_status = 'Verified' WHERE otp_status IS NULL OR otp_status = '';


-- ====================================================================
--  STEP 3 — DOCTORS TABLE
-- ====================================================================

-- 3a. Add fees column (consultation fee per visit)
ALTER TABLE doctors
    ADD COLUMN IF NOT EXISTS fees DECIMAL(10,2) NOT NULL DEFAULT 500.00
    AFTER email;

-- 3b. Add image column (uploaded photo filename)
ALTER TABLE doctors
    ADD COLUMN IF NOT EXISTS image VARCHAR(255) DEFAULT NULL
    AFTER fees;

-- 3c. Add email column (if missing in very old schema)
ALTER TABLE doctors
    ADD COLUMN IF NOT EXISTS email VARCHAR(150) DEFAULT NULL
    AFTER mobile;

-- 3d. Add created_at
ALTER TABLE doctors
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    AFTER image;

-- 3e. Add index on specialization for faster search
ALTER TABLE doctors
    ADD INDEX IF NOT EXISTS idx_doctors_specialization (specialization(50));


-- ====================================================================
--  STEP 4 — PATIENTS TABLE
-- ====================================================================

-- 4a. Add address column
ALTER TABLE patients
    ADD COLUMN IF NOT EXISTS address TEXT DEFAULT NULL
    AFTER mobile;

-- 4b. Add disease column
ALTER TABLE patients
    ADD COLUMN IF NOT EXISTS disease VARCHAR(200) DEFAULT NULL
    AFTER address;

-- 4c. Add aadhaar column
ALTER TABLE patients
    ADD COLUMN IF NOT EXISTS aadhaar VARCHAR(20) DEFAULT NULL
    AFTER disease;

-- 4d. Add doctor_id (assigned doctor — optional reference)
ALTER TABLE patients
    ADD COLUMN IF NOT EXISTS doctor_id INT DEFAULT NULL
    AFTER aadhaar;

-- 4e. Add created_at
ALTER TABLE patients
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    AFTER doctor_id;

-- 4f. Add foreign key for doctor_id (skip if already exists)
--     Check first: SELECT * FROM information_schema.TABLE_CONSTRAINTS
--                  WHERE TABLE_NAME='patients' AND CONSTRAINT_TYPE='FOREIGN KEY';
ALTER TABLE patients
    ADD CONSTRAINT IF NOT EXISTS fk_patients_doctor
        FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE SET NULL ON UPDATE CASCADE;

-- 4g. Indexes
ALTER TABLE patients
    ADD INDEX IF NOT EXISTS idx_patients_mobile    (mobile),
    ADD INDEX IF NOT EXISTS idx_patients_doctor_id (doctor_id);


-- ====================================================================
--  STEP 5 — APPOINTMENTS TABLE  ← Most Critical Updates
-- ====================================================================

-- 5a. Add status column (Pending / Confirmed / Cancelled)
ALTER TABLE appointments
    ADD COLUMN IF NOT EXISTS status
        ENUM('Pending','Confirmed','Cancelled') NOT NULL DEFAULT 'Pending'
    AFTER appointment_date;

-- 5b. Add payment_status column (Unpaid / Paid)
ALTER TABLE appointments
    ADD COLUMN IF NOT EXISTS payment_status
        ENUM('Unpaid','Paid') NOT NULL DEFAULT 'Unpaid'
    AFTER status;

-- 5c. Add payment_id column (Razorpay transaction reference)
ALTER TABLE appointments
    ADD COLUMN IF NOT EXISTS payment_id VARCHAR(100) DEFAULT NULL
        COMMENT 'Razorpay payment_id on successful payment'
    AFTER payment_status;

-- 5d. Add created_at
ALTER TABLE appointments
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    AFTER payment_id;

-- 5e. Backfill: set all existing appointments to 'Confirmed'+'Paid' if they
--     had a payment_id already, otherwise leave as 'Pending'+'Unpaid'
UPDATE appointments
    SET status = 'Confirmed', payment_status = 'Paid'
WHERE payment_id IS NOT NULL AND payment_id != '';

-- 5f. Indexes for performance
ALTER TABLE appointments
    ADD INDEX IF NOT EXISTS idx_appt_status           (status),
    ADD INDEX IF NOT EXISTS idx_appt_appointment_date (appointment_date),
    ADD INDEX IF NOT EXISTS idx_appt_patient_id       (patient_id),
    ADD INDEX IF NOT EXISTS idx_appt_doctor_id        (doctor_id);


-- ====================================================================
--  STEP 6 — CREATE payments TABLE (if it doesn't exist yet)
-- ====================================================================

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


-- ====================================================================
--  STEP 7 — MIGRATE EXISTING RAZORPAY DATA INTO payments TABLE
--  (If your old schema stored payment_id directly in appointments
--   but never had a separate payments table)
-- ====================================================================

INSERT INTO payments (appointment_id, razorpay_payment_id, amount, payment_status)
SELECT
    a.appointment_id,
    a.payment_id,
    IFNULL(d.fees, 500.00) AS amount,
    'Paid'
FROM appointments a
JOIN doctors d ON d.doctor_id = a.doctor_id
WHERE a.payment_id IS NOT NULL
  AND a.payment_id != ''
  AND NOT EXISTS (
    SELECT 1 FROM payments p WHERE p.appointment_id = a.appointment_id
  );


-- ====================================================================
--  STEP 8 — USEFUL VIEWS (CREATE OR REPLACE — always safe)
-- ====================================================================

-- Full appointment details view (used for reports)
CREATE OR REPLACE VIEW vw_appointment_details AS
SELECT
    a.appointment_id,
    p.name             AS patient_name,
    p.age              AS patient_age,
    p.gender           AS patient_gender,
    p.mobile           AS patient_mobile,
    d.name             AS doctor_name,
    d.specialization   AS doctor_specialization,
    d.fees             AS doctor_fees,
    a.appointment_date,
    a.status,
    a.payment_status,
    a.payment_id,
    a.created_at
FROM appointments a
JOIN patients     p ON p.patient_id = a.patient_id
JOIN doctors      d ON d.doctor_id  = a.doctor_id;


-- Monthly revenue summary (used by Chart.js in dashboard)
CREATE OR REPLACE VIEW vw_revenue_summary AS
SELECT
    YEAR(created_at)  AS `year`,
    MONTH(created_at) AS `month`,
    COUNT(*)          AS total_payments,
    SUM(amount)       AS total_revenue
FROM payments
WHERE payment_status = 'Paid'
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY `year` DESC, `month` DESC;


-- Doctor statistics view
CREATE OR REPLACE VIEW vw_doctor_stats AS
SELECT
    d.doctor_id,
    d.name,
    d.specialization,
    d.fees,
    COUNT(a.appointment_id)         AS total_appointments,
    SUM(a.status = 'Confirmed')     AS confirmed_appointments,
    IFNULL(SUM(pay.amount), 0)      AS total_revenue_generated
FROM doctors d
LEFT JOIN appointments a   ON a.doctor_id  = d.doctor_id
LEFT JOIN payments     pay ON pay.appointment_id = a.appointment_id
                          AND pay.payment_status = 'Paid'
GROUP BY d.doctor_id;


-- ====================================================================
--  STEP 9 — VERIFY FINAL SCHEMA
-- ====================================================================

-- Check table row counts
SELECT 'users'        AS `table`, COUNT(*) AS rows FROM users        UNION ALL
SELECT 'doctors'      AS `table`, COUNT(*) AS rows FROM doctors      UNION ALL
SELECT 'patients'     AS `table`, COUNT(*) AS rows FROM patients     UNION ALL
SELECT 'appointments' AS `table`, COUNT(*) AS rows FROM appointments UNION ALL
SELECT 'payments'     AS `table`, COUNT(*) AS rows FROM payments;

-- Check that all required columns exist in appointments
SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'hospital_db'
  AND TABLE_NAME   = 'appointments'
ORDER BY ORDINAL_POSITION;

-- Check that password is wide enough for BCrypt
SELECT COLUMN_NAME, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'hospital_db'
  AND TABLE_NAME   = 'users'
  AND COLUMN_NAME  = 'password';

-- ====================================================================
--  ✅ UPDATE COMPLETE
--  All changes are backward-compatible — no existing data was deleted.
-- ====================================================================
