-- ===================================================
-- Task 3: SQL Queries, Views, and Triggers
-- Project Name: AuraCare Smart Clinic Database System
-- Author: Mohammed Almoerfi
-- ===================================================

USE SmartClinicDB;

-- 1. SELECT Statement with WHERE, LIKE, and ORDER BY
SELECT p_person.Full_Name, p_person.Address, pat.Blood_Group, pat.Medical_History
FROM Patient pat
JOIN Person p_person ON pat.Person_ID = p_person.Person_ID
WHERE p_person.Address LIKE '%Riyadh%' 
  AND pat.Medical_History LIKE '%allergies%'
ORDER BY p_person.Full_Name ASC;

-- 2. Complex Multi-Table INNER JOIN
SELECT 
    p_pers.Full_Name AS Patient,
    d_pers.Full_Name AS Doctor,
    appt.Appt_Date,
    treat.Diagnosis,
    presc.Medicine_Name,
    presc.Dosage
FROM Appointment appt
INNER JOIN Patient pat ON appt.Patient_ID = pat.Patient_ID
INNER JOIN Person p_pers ON pat.Person_ID = p_pers.Person_ID
INNER JOIN Doctor doc ON appt.Doctor_ID = doc.Doctor_ID
INNER JOIN Person d_pers ON doc.Person_ID = d_pers.Person_ID
INNER JOIN Medical_Treatment treat ON treat.Appointment_ID = appt.Appointment_ID
INNER JOIN Medicine_Prescription presc ON presc.Treatment_ID = treat.Treatment_ID
WHERE appt.Status = 'Completed';

-- 3. LEFT OUTER JOIN
SELECT 
    d_pers.Full_Name AS Doctor_Name,
    doc.Specialization,
    appt.Appointment_ID,
    appt.Appt_Date,
    appt.Status
FROM Doctor doc
JOIN Person d_pers ON doc.Person_ID = d_pers.Person_ID
LEFT OUTER JOIN Appointment appt ON doc.Doctor_ID = appt.Doctor_ID;

-- 4. Nested Subquery using IN
SELECT Full_Name, Phone, Email 
FROM Person 
WHERE Person_ID IN (
    SELECT pat.Person_ID 
    FROM Patient pat
    WHERE pat.Patient_ID IN (
        SELECT appt.Patient_ID 
        FROM Appointment appt
        WHERE appt.Appointment_ID IN (
            SELECT treat.Appointment_ID 
            FROM Medical_Treatment treat
            WHERE treat.Diagnosis LIKE '%Arrhythmia%'
        )
    )
);

-- 5. Aggregation with GROUP BY and HAVING
SELECT 
    d_pers.Full_Name AS Doctor_Name,
    COUNT(inv.Invoice_ID) AS Total_Invoices,
    SUM(inv.Amount) AS Total_Revenue
FROM Doctor doc
JOIN Person d_pers ON doc.Person_ID = d_pers.Person_ID
JOIN Appointment appt ON doc.Doctor_ID = appt.Doctor_ID
JOIN Payment_Invoice inv ON appt.Appointment_ID = inv.Appointment_ID
WHERE inv.Payment_Status = 'Paid'
GROUP BY doc.Doctor_ID, d_pers.Full_Name
HAVING SUM(inv.Amount) > 200.00;

-- 6. Referential Integrity Testing (UPDATE)
UPDATE Person 
SET Person_ID = 99 
WHERE Person_ID = 6;

SELECT * FROM Patient WHERE Person_ID = 99;

-- 7. Referential Integrity Testing (DELETE)
DELETE FROM Person 
WHERE Person_ID = 99;

SELECT * FROM Patient WHERE Person_ID = 99;

-- 8. View Creation and Execution Test
CREATE OR REPLACE VIEW vw_Patient_Appointment_History AS
SELECT 
    a.Appointment_ID,
    p_person.Full_Name AS Patient_Name,
    p.Blood_Group,
    d_person.Full_Name AS Doctor_Name,
    d.Specialization,
    a.Appt_Date,
    a.Appt_Time,
    a.Status
FROM Appointment a
JOIN Patient p ON a.Patient_ID = p.Patient_ID
JOIN Person p_person ON p.Person_ID = p_person.Person_ID
JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID
JOIN Person d_person ON d.Person_ID = d_person.Person_ID;

SELECT * FROM vw_Patient_Appointment_History;

-- 9. Trigger Creation
DELIMITER //
CREATE TRIGGER trg_Prevent_Invalid_Appointment
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    IF NEW.Appt_Date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Appointment date cannot be in the past.';
    END IF;
END //
DELIMITER ;
