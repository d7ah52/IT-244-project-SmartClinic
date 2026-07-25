-- ========================================================
-- Task 3: SQL Queries, Views, and Triggers
-- Author: Mohammed Almoerfi
-- ========================================================

USE SmartClinicDB;

-- Query 6: Aggregation with GROUP BY and HAVING
SELECT 
    pers.Full_Name AS Doctor_Name,
    COUNT(a.Appointment_ID) AS Total_Appointments,
    SUM(i.Amount) AS Total_Revenue
FROM Doctor d
INNER JOIN Person pers ON d.Doctor_ID = pers.Person_ID
INNER JOIN Appointment a ON d.Doctor_ID = a.Doctor_ID
INNER JOIN Payment_Invoice i ON a.Appointment_ID = i.Appointment_ID
GROUP BY d.Doctor_ID, pers.Full_Name
HAVING SUM(i.Amount) > 250.00;

-- Query 7: Referential Integrity Test (UPDATE)
UPDATE Person
SET Person_ID = 99
WHERE Person_ID = 1;

SELECT * FROM Patient WHERE Person_ID = 99;

-- Query 8: Referential Integrity Test (DELETE)
DELETE FROM Person
WHERE Person_ID = 99;

SELECT * FROM Patient WHERE Person_ID = 99;

-- Query 9: View Execution Test
CREATE OR REPLACE VIEW vw_Patient_Appointment_History AS
SELECT 
    p.Patient_ID,
    pers.Full_Name AS Patient_Name,
    a.Appt_Date,
    a.Appt_Time,
    a.Status,
    doc_pers.Full_Name AS Doctor_Name
FROM Patient p
JOIN Person pers ON p.Patient_ID = pers.Person_ID
JOIN Appointment a ON p.Patient_ID = a.Patient_ID
JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID
JOIN Person doc_pers ON d.Doctor_ID = doc_pers.Person_ID;

SELECT * FROM vw_Patient_Appointment_History;

-- Query 10: Trigger Validation Test
DELIMITER //
CREATE TRIGGER PreventPastAppointments
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    IF NEW.Appt_Date < CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot schedule an appointment in the past.';
    END IF;
END //
DELIMITER ;
