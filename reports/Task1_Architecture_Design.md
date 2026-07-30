## TASK 1: DATABASE DESIGN

### 1. System Architecture

The **AuraCare Smart Clinic Database System** is architected to streamline clinic operations by integrating patient management, clinical consultations, medical prescriptions, and billing processes into a cohesive digital platform. The system is designed to support the following key functionalities:

- **User Management:** Centralized management of all users (patients, doctors, and staff) through a unified `Person` table, ensuring consistent handling of contact information and user roles.
- **Appointment Scheduling:** Efficient scheduling and tracking of patient appointments with doctors, including status updates and historical records.
- **Medical Records:** Comprehensive management of medical treatments and prescriptions, linked directly to patient appointments for seamless access to medical history.
- **Billing and Invoicing:** Automated generation and tracking of payment invoices for each appointment, ensuring financial transparency and integrity.

### 2. EER Diagram Option 8A Justification

The decision to implement the EER Diagram using **Option 8A (Superclass/Subclass)** is driven by the need to minimize data redundancy and maintain a clean inheritance structure for user information. By defining a `Person` superclass with `Patient` and `Doctor` subclasses, the system achieves:

- **Data Consistency:** Centralized storage of common attributes (e.g., Full_Name, Phone, Email) in the `Person` table, reducing duplication across user types.
- **Flexibility:** Easy extension of the system to accommodate additional user roles (e.g., Staff) without altering the existing schema.
- **Integrity:** Strong referential integrity through foreign key constraints, ensuring that each `Patient` and `Doctor` record is linked to a valid `Person` entry.

### 3. 3NF Normalization Mapping

The relational schema is meticulously designed to adhere to the **Third Normal Form (3NF)**, ensuring data integrity and eliminating redundancy:

- **First Normal Form (1NF):** All tables contain atomic values, with no repeating groups. For example, `Medical_Treatment` and `Medicine_Prescription` tables are used to separate treatment details and prescriptions.
  
- **Second Normal Form (2NF):** Each table is in 1NF and all non-key attributes are fully functionally dependent on the primary key. For instance, `Appointment` table attributes like `Appt_Date` and `Appt_Time` depend entirely on `Appointment_ID`.

- **Third Normal Form (3NF):** The schema is in 2NF and all transitive dependencies are eliminated. Non-prime attributes depend solely on the primary key, ensuring that attributes like `Consultation_Fee` are directly linked to `Doctor_ID` without unnecessary dependencies.

This structured approach guarantees that the database is robust, scalable, and capable of handling complex queries and transactions efficiently.