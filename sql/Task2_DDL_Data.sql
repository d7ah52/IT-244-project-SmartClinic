-- ===================================================
-- Task 2: DDL Schemas and Data Population
-- Project Name: AuraCare Smart Clinic Database System
-- Author: Ahmed Alharbi
-- ===================================================

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
    FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Subclass Table: Doctor (Option 8A) 
CREATE TABLE Doctor (
    Doctor_ID INT AUTO_INCREMENT,
    Specialization VARCHAR(100) NOT NULL,
    Medical_License_No VARCHAR(50) NOT NULL UNIQUE,
    Consultation_Fee DECIMAL(10, 2) NOT NULL,
    Person_ID INT NOT NULL UNIQUE,
    PRIMARY KEY (Doctor_ID),
    FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID) ON DELETE CASCADE ON UPDATE CASCADE,
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
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Transactional Table: Medical_Treatment 
CREATE TABLE Medical_Treatment (
    Treatment_ID INT AUTO_INCREMENT,
    Diagnosis VARCHAR(255) NOT NULL,
    Treatment_Date DATE NOT NULL,
    Appointment_ID INT NOT NULL UNIQUE,
    PRIMARY KEY (Treatment_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Transactional Table: Medicine_Prescription 
CREATE TABLE Medicine_Prescription (
    Prescription_ID INT AUTO_INCREMENT,
    Medicine_Name VARCHAR(100) NOT NULL,
    Dosage VARCHAR(100) NOT NULL,
    Duration_Days INT NOT NULL,
    Treatment_ID INT NOT NULL,
    PRIMARY KEY (Prescription_ID),
    FOREIGN KEY (Treatment_ID) REFERENCES Medical_Treatment(Treatment_ID) ON DELETE CASCADE ON UPDATE CASCADE,
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
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_amount_non_negative CHECK (Amount >= 0)
) ENGINE=InnoDB;

-- ===================================================
-- DATA POPULATION (DML)
-- ===================================================

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

INSERT INTO Doctor (Specialization, Medical_License_No, Consultation_Fee, Person_ID) VALUES 
('Cardiology', 'SCHS-DOC-11021', 400.00, 1), 
('Pediatrics', 'SCHS-DOC-22094', 250.00, 2), 
('Dermatology', 'SCHS-DOC-33081', 300.00, 3), 
('Orthopedics', 'SCHS-DOC-44072', 350.00, 4), 
('Internal Medicine', 'SCHS-DOC-55063', 200.00, 5);

INSERT INTO Patient (Blood_Group, Emergency_Contact, Medical_History, Person_ID) VALUES 
('O+', '+966509991111', 'No chronic diseases, mild seasonal allergies.', 6), 
('A-', '+966558882222', 'Diagnosed with Type 2 Diabetes in 2022.', 7), 
('B+', '+966547773333', 'Hypertension managed with daily medication.', 8), 
('AB+', '+966566664444', 'Asthmatic, uses inhaler when needed.', 9), 
('O-', '+966505555555', 'No significant prior medical history.', 10);

INSERT INTO Appointment (Appt_Date, Appt_Time, Status, Patient_ID, Doctor_ID) VALUES 
('2026-10-10', '09:00:00', 'Completed', 1, 1), 
('2026-10-11', '10:30:00', 'Completed', 2, 2), 
('2026-10-12', '14:00:00', 'Completed', 3, 3), 
('2026-10-13', '11:00:00', 'Scheduled', 4, 4), 
('2026-10-14', '16:15:00', 'Scheduled', 5, 5);

INSERT INTO Medical_Treatment (Diagnosis, Treatment_Date, Appointment_ID) VALUES 
('Arrhythmia checkup, ECG performed.', '2026-10-10', 1), 
('Acute bronchitis, nebulizer administered.', '2026-10-11', 2), 
('Eczema flare-up, topical steroid prescribed.', '2026-10-12', 3);

INSERT INTO Medicine_Prescription (Medicine_Name, Dosage, Duration_Days, Treatment_ID) VALUES 
('Beta-Blocker (Metoprolol)', '50mg once daily', 30, 1), 
('Amoxicillin Antibiotic', '500mg three times daily', 7, 2), 
('Hydrocortisone Cream', 'Apply twice daily to affected areas', 10, 3);

INSERT INTO Payment_Invoice (Amount, Payment_Method, Payment_Status, Invoice_Date, Appointment_ID) VALUES 
(400.00, 'Card', 'Paid', '2026-10-10', 1), 
(250.00, 'Insurance', 'Paid', '2026-10-11', 2), 
(300.00, 'Cash', 'Paid', '2026-10-12', 3), 
(350.00, 'Card', 'Unpaid', '2026-10-13', 4), 
(200.00, 'Insurance', 'Unpaid', '2026-10-14', 5)
