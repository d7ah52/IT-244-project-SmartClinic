-- ========================================================
-- Task 2: DDL Schemas and Data Population
-- Author: Ahmed Alharbi
-- ========================================================

CREATE DATABASE IF NOT EXISTS SmartClinicDB;
USE SmartClinicDB;

-- Superclass: Person
CREATE TABLE IF NOT EXISTS Person (
    Person_ID INT PRIMARY KEY AUTO_INCREMENT,
    Full_Name VARCHAR(100) NOT NULL,
    National_ID VARCHAR(10) UNIQUE NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Role ENUM('Patient', 'Doctor', 'Nurse', 'Admin') NOT NULL
);

-- Subclass: Patient
CREATE TABLE IF NOT EXISTS Patient (
    Patient_ID INT PRIMARY KEY,
    District VARCHAR(50),
    City VARCHAR(30),
    FOREIGN KEY (Patient_ID) REFERENCES Person(Person_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Subclass: Doctor
CREATE TABLE IF NOT EXISTS Doctor (
    Doctor_ID INT PRIMARY KEY,
    Specialty VARCHAR(50) NOT NULL,
    SCFHS_License VARCHAR(20) UNIQUE NOT NULL,
    FOREIGN KEY (Doctor_ID) REFERENCES Person(Person_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: Appointment
CREATE TABLE IF NOT EXISTS Appointment (
    Appointment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Appt_Date DATE NOT NULL,
    Appt_Time TIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE CASCADE
);

-- Table: Payment_Invoice
CREATE TABLE IF NOT EXISTS Payment_Invoice (
    Invoice_ID INT PRIMARY KEY AUTO_INCREMENT,
    Appointment_ID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Payment_Status ENUM('Paid', 'Pending') DEFAULT 'Pending',
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID) ON DELETE CASCADE
);
