-- ============================================================
--  HOSPITAL DB — FINAL FIX SCRIPT
--  Fixes wrong column types found in DESCRIBE output
-- ============================================================

USE hospital_db;

-- ── FIX 1: appointments.payment_status
--    Was: varchar(20) DEFAULT 'Pending'  ← WRONG
--    Fix: ENUM('Unpaid','Paid') DEFAULT 'Unpaid'
ALTER TABLE appointments
    MODIFY COLUMN payment_status ENUM('Unpaid','Paid') NOT NULL DEFAULT 'Unpaid';

UPDATE appointments
    SET payment_status = 'Unpaid'
    WHERE payment_status NOT IN ('Unpaid','Paid');

-- ── FIX 2: users.otp_status
--    Was: varchar(20) DEFAULT 'Not Verified'  ← WRONG
--    Fix: ENUM('Pending','Verified') DEFAULT 'Pending'
ALTER TABLE users
    MODIFY COLUMN otp_status ENUM('Pending','Verified') NOT NULL DEFAULT 'Pending';

-- Mark any 'Not Verified' → 'Verified' so existing users can log in
UPDATE users
    SET otp_status = 'Verified'
    WHERE otp_status IN ('Not Verified','Verified','Pending');

-- ── FIX 3: Create payments table if not exists
CREATE TABLE IF NOT EXISTS payments (
    payment_id          INT           NOT NULL AUTO_INCREMENT,
    appointment_id      INT           NOT NULL,
    razorpay_payment_id VARCHAR(100)  DEFAULT NULL,
    amount              DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    payment_status      ENUM('Paid','Failed','Refunded') NOT NULL DEFAULT 'Paid',
    created_at          TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (payment_id),
    KEY idx_payments_appt (appointment_id),
    CONSTRAINT fk_payments_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── FIX 4: Add views
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
JOIN patients p ON p.patient_id = a.patient_id
JOIN doctors  d ON d.doctor_id  = a.doctor_id;

CREATE OR REPLACE VIEW vw_revenue_summary AS
SELECT
    YEAR(created_at)  AS yr,
    MONTH(created_at) AS mo,
    COUNT(*)          AS total_payments,
    SUM(amount)       AS total_revenue
FROM payments
WHERE payment_status = 'Paid'
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY yr DESC, mo DESC;

-- ── VERIFY
SELECT 'users'        AS tbl, COUNT(*) AS total FROM users        UNION ALL
SELECT 'doctors'      AS tbl, COUNT(*) AS total FROM doctors      UNION ALL
SELECT 'patients'     AS tbl, COUNT(*) AS total FROM patients     UNION ALL
SELECT 'appointments' AS tbl, COUNT(*) AS total FROM appointments UNION ALL
SELECT 'payments'     AS tbl, COUNT(*) AS total FROM payments;

DESCRIBE users;
DESCRIBE appointments;
