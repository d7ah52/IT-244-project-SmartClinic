# IT244 - Introduction to Database

**TEXTBOOK:** **Fundamentals of Database Systems**

**PROJECT** **NAME:** **AuraCare Smart Clinic Database System**

**SUBMISSION** **DATE:** **July 25, 2026**

---

## MID-PROJECT PROGRESS REPORT
1. WORK COMPLETED DURING THIS PERIOD:
   - Finalized the EER conceptual model using Option 8A (Superclass/Subclass).
   - Designed the relational schema normalized to 3rd Normal Form (3NF).
   - Drafted the DDL script with strict referential integrity and domain constraints.
   - Populated the database with realistic Saudi clinical records.

2. KEY DECISION MADE DURING THIS PERIOD:
   - Selected Option 8A (Superclass Person with Subclasses Patient and Doctor) 
     to avoid data redundancy and maintain clean inheritance of contact details.

3. PROBLEM ENCOUNTERED DURING THE PROCESS:
   - Encountered a circular dependency and foreign key constraint violation during 
   - table creation. Solved by carefully ordering the DDL statements (Person first, 
   - then subclasses, then transactional tables).

4. PLAN FOR WHAT TO DO NEXT:
   - Implement database indexing on high-frequency search columns (Appt_Date).
   - Develop stored procedures to automate invoice generation.
     
5. GROUP MEMBER PARTICIPATION BREAKDOWN:

   * Osama Kheder Aloldail (S240009922 - Lead Architect): Task 1 (System Architecture, EER Specialization Design Option 8A, Relational Mapping & Normalization 3NF) & Task 4 (Project Reflection Essay, Version History Management & Final Report Integration)
   * Ahmed abdullah alharbi (S240032830 - Database Developer): DDL Script Implementation, Relational Schema Definition, and Saudi-Localized Data Population (Task 2).
   * Mohammed Almoerfi (S240055942 - SQL Specialist): SQL Operations & Joins, Analytics Queries, Daily Schedule View Creation, Double-Booking Trigger (Task 3), and Reflection Essay.



##  PROJECT ARTIFACTS
* Live Report Document Link: https://docs.google.com/document/d/1-AI9AmQwSCbFYrTkSOxY9n3kVyjo_O4VCezg0pNOZ8s/edit?usp=drivesdk
* GitHub Repository Link: https://github.com/d7ah52/IT-244-project-SmartClinic



## TASK 1: DATABASE DESIGN

### 1. System Description & Design Assumptions
The **AuraCare Smart Clinic Database System** is designed to digitize clinic management by consolidating patient administration, clinical consultations, medical prescriptions, and financial billing.

**Design Assumptions & Business Rules:**
1. **Inheritance & User Categorization:** Every user interacting with the system is classified under the `Person` superclass. The subclasses `Patient` and `Doctor` inherit contact details using EER Option 8A to enforce 1:1 entity mapping and eliminate data redundancy.
2. **Appointment Scheduling:** A `Patient` can schedule multiple `Appointment`s with a `Doctor` (1:N relationship). However, each individual appointment is linked to exactly one patient and one doctor.
3. **Medical Treatment & Prescriptions:** Each completed appointment results in at most one `Medical_Treatment` record (1:1 relationship). A medical treatment can include one or more `Medicine_Prescription`s (1:N relationship).
4. **Billing Integrity:** Every appointment generates exactly one `Payment_Invoice` (1:1 relationship) to track financial settlement.

---

### 2. Relational Schema Mapping
Below is the logical relational schema mapped directly from the EER Conceptual Diagram in accordance with 3NF guidelines:

* **Person** (<u>Person_ID</u>, Full_Name, Phone, Email, Address, User_Type)
* **Patient** (<u>Patient_ID</u>, Blood_Group, Emergency_Contact, Medical_History, Person_ID)
  * *Foreign Key:* Person_ID references `Person(Person_ID)`
* **Doctor** (<u>Doctor_ID</u>, Specialization, Medical_License_No, Consultation_Fee, Person_ID)
  * *Foreign Key:* Person_ID references `Person(Person_ID)`
* **Appointment** (<u>Appointment_ID</u>, Appt_Date, Appt_Time, Status, Patient_ID, Doctor_ID)
  * *Foreign Keys:* Patient_ID references `Patient(Patient_ID)`, Doctor_ID references `Doctor(Doctor_ID)`
* **Medical_Treatment** (<u>Treatment_ID</u>, Diagnosis, Treatment_Date, Appointment_ID)
  * *Foreign Key:* Appointment_ID references `Appointment(Appointment_ID)`
* **Medicine_Prescription** (<u>Prescription_ID</u>, Medicine_Name, Dosage, Duration_Days, Treatment_ID)
  * *Foreign Key:* Treatment_ID references `Medical_Treatment(Treatment_ID)`
* **Payment_Invoice** (<u>Invoice_ID</u>, Amount, Payment_Method, Payment_Status, Invoice_Date, Appointment_ID)
  * *Foreign Key:* Appointment_ID references `Appointment(Appointment_ID)`

---

### 3. Normalization Analysis (1NF, 2NF, 3NF)
To guarantee database consistency and prevent update, insertion, and deletion anomalies, the database schema is fully normalized up to the **Third Normal Form (3NF)**:

1. **First Normal Form (1NF):**
   - All attributes contain indivisible (atomic) values.
   - Repeating groups (e.g., diagnoses or multiple prescribed medicines) are decomposed into separate relations (`Medical_Treatment` and `Medicine_Prescription`) with defined primary keys.

2. **Second Normal Form (2NF):**
   - The schema is in 1NF and exhibits **no partial functional dependencies**.
   - All relations utilize single-attribute Primary Keys (e.g., Appointment_ID -> Appt_Date, Appt_Time, Status), which ensures that non-key attributes depend fully on the complete Primary Key.

3. **Third Normal Form (3NF):**
   - The schema is in 2NF and exhibits **no transitive functional dependencies**.
   - Non-prime attributes depend exclusively on candidate primary keys. Attributes such as Consultation_Fee depend strictly on Doctor_ID and not on appointment or patient data. Cross-entity relationships are maintained strictly via Foreign Keys.



## TASK 2: DATABASE DDL IMPLEMENTATION

```sql
DROP DATABASE IF EXISTS SmartClinicDB;
CREATE DATABASE IF NOT EXISTS SmartClinicDB;
USE SmartClinicDB;

-- 1. Superclass Table: Person
CREATE TABLE Person (
    Person_ID INT AUTO_INCREMENT,
    Full_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(255),
    User_Type ENUM('Patient', 'Doctor', 'Staff') NOT NULL,
    PRIMARY KEY (Person_ID),
    CONSTRAINT chk_phone_format CHECK (Phone LIKE '+9665%')
) ENGINE=InnoDB;

 -- 2. Subclass Table: Patient (Option 8A)
CREATE TABLE Patient (
    Patient_ID INT AUTO_INCREMENT,
    Blood_Group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    Emergency_Contact VARCHAR(15) NOT NULL,
    Medical_History TEXT,
    Person_ID INT NOT NULL UNIQUE,
    PRIMARY KEY (Patient_ID),
    FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Subclass Table: Doctor (Option 8A)
CREATE TABLE Doctor (
    Doctor_ID INT AUTO_INCREMENT,
    Specialization VARCHAR(100) NOT NULL,
    Medical_License_No VARCHAR(50) NOT NULL UNIQUE,
    Consultation_Fee DECIMAL(10, 2) NOT NULL,
    Person_ID INT NOT NULL UNIQUE,
    PRIMARY KEY (Doctor_ID),
    FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_fee_positive CHECK (Consultation_Fee > 0)
) ENGINE=InnoDB;

-- 4. Transactional Table: Appointment
CREATE TABLE Appointment (
    Appointment_ID INT AUTO_INCREMENT,
    Appt_Date DATE NOT NULL,
    Appt_Time TIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    PRIMARY KEY (Appointment_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Transactional Table: Medical_Treatment
CREATE TABLE Medical_Treatment (
    Treatment_ID INT AUTO_INCREMENT,
    Diagnosis VARCHAR(255) NOT NULL,
    Treatment_Date DATE NOT NULL,
    Appointment_ID INT NOT NULL UNIQUE,
    PRIMARY KEY (Treatment_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Transactional Table: Medicine_Prescription
CREATE TABLE Medicine_Prescription (
    Prescription_ID INT AUTO_INCREMENT,
    Medicine_Name VARCHAR(100) NOT NULL,
    Dosage VARCHAR(100) NOT NULL,
    Duration_Days INT NOT NULL,
    Treatment_ID INT NOT NULL,
    PRIMARY KEY (Prescription_ID),
    FOREIGN KEY (Treatment_ID) REFERENCES Medical_Treatment(Treatment_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_duration_positive CHECK (Duration_Days > 0)
) ENGINE=InnoDB;

-- 7. Transactional Table: Payment_Invoice
CREATE TABLE Payment_Invoice (
    Invoice_ID INT AUTO_INCREMENT,
    Amount DECIMAL(10, 2) NOT NULL,
    Payment_Method ENUM('Cash', 'Card', 'Insurance') NOT NULL,
    Payment_Status ENUM('Paid', 'Unpaid', 'Refunded') DEFAULT 'Unpaid',
    Invoice_Date DATE NOT NULL,
    Appointment_ID INT NOT NULL UNIQUE,
    PRIMARY KEY (Invoice_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_amount_non_negative CHECK (Amount >= 0)
) ENGINE=InnoDB;
```
 
## TASK 2: DATABASE DML POPULATION

```sql
-- Populating Person Table (Saudi Names, Phone Numbers, and Addresses)
INSERT INTO Person (Full_Name, Phone, Email, Address, User_Type) VALUES
('Dr. Sara Al-Qahtani', '+966501234567', 'sara.qahtani@auracare.com.sa', 'Olaya District, Riyadh', 'Doctor'),
('Dr. Abdulrahman Al-Otaibi', '+966549876543', 'abdulrahman.otaibi@auracare.com.sa', 'Al-Hamra District, Jeddah', 'Doctor'),
('Dr. Khalid Al-Shammari', '+966561112223', 'khalid.shammari@auracare.com.sa', 'Al-Malaz District, Riyadh', 'Doctor'),
('Dr. Tariq Al-Ghamdi', '+966554443332', 'tariq.ghamdi@auracare.com.sa', 'Al-Safa District, Jeddah', 'Doctor'),
('Dr. Reem Al-Dossary', '+966539998887', 'reem.dossary@auracare.com.sa', 'Al-Yasmin District, Riyadh', 'Doctor'),
('Fahad Al-Zahrani', '+966508887776', 'fahad.zahrani@mail.sa', 'Al-Nuzha District, Riyadh', 'Patient'),
('Yasser Al-Harbi', '+966557776665', 'yasser.harbi@mail.sa', 'Al-Naeem District, Jeddah', 'Patient'),
('Mona Al-Saeed', '+966543332221', 'mona.saeed@mail.sa', 'Al-Rawdah District, Jeddah', 'Patient'),
('Layan Al-Sudairy', '+966562223334', 'layan.sudairy@mail.sa', 'Al-Mursalat District, Riyadh', 'Patient'),
('Hassan Al-Malki', '+966504445556', 'hassan.malki@mail.sa', 'Al-Zahra District, Jeddah', 'Patient');

-- Populating Doctor Table
INSERT INTO Doctor (Specialization, Medical_License_No, Consultation_Fee, Person_ID) VALUES
('Cardiology', 'SCHS-DOC-11021', 400.00, 1),
('Pediatrics', 'SCHS-DOC-22094', 250.00, 2),
('Dermatology', 'SCHS-DOC-33081', 300.00, 3),
('Orthopedics', 'SCHS-DOC-44072', 350.00, 4),
('Internal Medicine', 'SCHS-DOC-55063', 200.00, 5);

-- Populating Patient Table
INSERT INTO Patient (Blood_Group, Emergency_Contact, Medical_History, Person_ID) VALUES
('O+', '+966509991111', 'No chronic diseases, mild seasonal allergies.', 6),
('A-', '+966558882222', 'Diagnosed with Type 2 Diabetes in 2022.', 7),
('B+', '+966547773333', 'Hypertension managed with daily medication.', 8),
('AB+', '+966566664444', 'Asthmatic, uses inhaler when needed.', 9),
('O-', '+966505555555', 'No significant prior medical history.', 10);

-- Populating Appointment Table
INSERT INTO Appointment (Appt_Date, Appt_Time, Status, Patient_ID, Doctor_ID) VALUES
('2026-10-10', '09:00:00', 'Completed', 1, 1),
('2026-10-11', '10:30:00', 'Completed', 2, 2),
('2026-10-12', '14:00:00', 'Completed', 3, 3),
('2026-10-13', '11:00:00', 'Scheduled', 4, 4),
('2026-10-14', '16:15:00', 'Scheduled', 5, 5);

-- Populating Medical_Treatment Table
INSERT INTO Medical_Treatment (Diagnosis, Treatment_Date, Appointment_ID) VALUES
('Arrhythmia checkup, ECG performed.', '2026-10-10', 1),
('Acute bronchitis, nebulizer administered.', '2026-10-11', 2),
('Eczema flare-up, topical steroid prescribed.', '2026-10-12', 3);

-- Populating Medicine_Prescription Table
INSERT INTO Medicine_Prescription (Medicine_Name, Dosage, Duration_Days, Treatment_ID) VALUES
('Beta-Blocker (Metoprolol)', '50mg once daily', 30, 1),
('Amoxicillin Antibiotic', '500mg three times daily', 7, 2),
('Hydrocortisone Cream', 'Apply twice daily to affected areas', 10, 3);

-- Populating Payment_Invoice Table
INSERT INTO Payment_Invoice (Amount, Payment_Method, Payment_Status, Invoice_Date, Appointment_ID) VALUES
(400.00, 'Card', 'Paid', '2026-10-10', 1),
(250.00, 'Insurance', 'Paid', '2026-10-11', 2),
(300.00, 'Cash', 'Paid', '2026-10-12', 3),
(350.00, 'Card', 'Unpaid', '2026-10-13', 4),
(200.00, 'Insurance', 'Unpaid', '2026-10-14', 5);
```

## TASK 2: VIEW CREATION

```sql
-- View: vw_Patient_Appointment_History
-- Academic Explanation: This view consolidates patient and doctor details from the 
-- Person superclass table with appointment transactional records to provide a 
-- comprehensive history of clinic visits.
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
```

## TASK 2: TRIGGER CREATION

```sgl
-- Trigger: trg_Prevent_Invalid_Appointment
-- Academic Explanation: This trigger enforces business rules and temporal integrity 
-- by preventing the insertion of appointments scheduled in the past.
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
```

## TASK 3: SQL OPERATIONS & TESTING

```sgl
-- 1. SELECT Statement with WHERE, LIKE, and ORDER BY
-- Academic Explanation: Retrieves all patients living in Riyadh whose medical history 
-- contains the word 'allergies', sorted alphabetically by their full name.
SELECT p_person.Full_Name, p_person.Address, pat.Blood_Group, pat.Medical_History
FROM Patient pat
JOIN Person p_person ON pat.Person_ID = p_person.Person_ID
WHERE p_person.Address LIKE '%Riyadh%' 
  AND pat.Medical_History LIKE '%allergies%'
ORDER BY p_person.Full_Name ASC;

-- 2. Complex Multi-Table INNER JOIN
-- Academic Explanation: Joins five tables to display the complete clinical path of 
-- completed appointments, including patient name, doctor name, diagnosis, and prescribed medicine.
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
-- Academic Explanation: Retrieves all registered doctors and any appointments assigned 
-- to them, ensuring doctors with no current appointments are still displayed in the output.
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
-- Academic Explanation: Identifies patients who have completed treatments for cardiac-related 
-- issues by filtering patient IDs associated with an 'Arrhythmia' diagnosis.
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
-- Academic Explanation: Calculates the total revenue generated by each doctor from 
-- paid invoices, displaying only doctors who have generated more than 200 SAR.
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

-- 6. Referential Integrity Testing (UPDATE and DELETE)
-- Academic Explanation: Demonstrates cascading referential integrity by updating a 
-- Person ID and deleting a Person record, automatically updating/deleting child records.
UPDATE Person 
SET Person_ID = 99 
WHERE Person_ID = 6;

SELECT * FROM Patient WHERE Person_ID = 99; -- Verifies update cascaded

DELETE FROM Person 
WHERE Person_ID = 99;

SELECT * FROM Patient WHERE Person_ID = 99; -- Verifies deletion cascaded (returns empty)

-- 7. View Execution Test
-- Academic Explanation: Executes the previously created view to retrieve the consolidated 
-- appointment history for all patients.
SELECT * FROM vw_Patient_Appointment_History;

-- 8. Trigger Validation Test
-- Academic Explanation: Attempts to insert an appointment with a past date to verify 
-- that the trigger successfully blocks the transaction and throws the defined error.
-- Expected Result: SQL Error 1644 (Error: Appointment date cannot be in the past.)
-- INSERT INTO Appointment (Appt_Date, Appt_Time, Status, Patient_ID, Doctor_ID) 
-- VALUES ('2020-01-01', '10:00:00', 'Scheduled', 2, 2);
```


## TASK 4: PROJECT REFLECTION ESSAY


During the development of the AuraCare Smart Clinic Database System, our team 
encountered a significant technical challenge regarding table creation order and 
foreign key constraints. Specifically, when implementing the EER specialization 
model (Option 8A), we attempted to create the subclass tables, Patient and Doctor, 
before the superclass table, Person. This resulted in immediate referential 
integrity failures on MySQL Workbench because the foreign keys referenced a 
non-existent parent table. We resolved this issue by restructuring our DDL script 
to ensure the Person table is created first, followed by the subclass tables, 
and finally the dependent transactional tables like Appointment and Medical_Treatment.

We selected a normalized 3NF Relational Model over a NoSQL document database like 
MongoDB. While NoSQL offers horizontal scalability and schema flexibility, our 
smart clinic system requires strict transactional consistency, data integrity, 
and complex multi-table relationships. Financial invoices, medical prescriptions, 
and appointment scheduling demand ACID compliance to prevent anomalies, such as 
double-booking or orphaned payment records. The tradeoff of relational 
normalization is increased join complexity, but it guarantees data redundancy 
is minimized and domain constraints are strictly enforced.

Gemini API was utilized for initial SQL structure drafting and schema debugging, 
after which the team verified, adjusted, and successfully executed all statements 
on MySQL Workbench. This collaborative approach allowed us to quickly resolve 
syntax discrepancies, particularly with the trigger definition and the multi-table 
outer join queries, while maintaining complete control over the database architecture.

If we had more time and resources, we would implement several database enhancements. 
First, we would add database indexing on frequently queried columns, such as 
Appt_Date and Patient_ID, to optimize search performance. Second, we would 
implement Advanced Encryption Standard (AES) encryption at rest for sensitive 
patient medical histories to comply with Saudi healthcare data regulations. 
Finally, we would develop stored procedures to automate the invoicing process 
immediately after a medical treatment is logged, reducing manual data entry errors.
