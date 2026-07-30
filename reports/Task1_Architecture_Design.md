## TASK 1: DATABASE DESIGN

### 1. System Architecture

The **AuraCare Smart Clinic Database System** is architected to streamline clinic operations by integrating patient management, clinical consultations, medical prescriptions, and billing processes into a cohesive digital platform. The system is designed to support the following functionalities:

- **User Management:** Centralized management of all users (patients, doctors, and staff) through a unified `Person` table, ensuring consistent handling of contact information and user roles.
- **Appointment Scheduling:** Efficient scheduling and tracking of patient appointments with doctors, including status updates and historical records.
- **Medical Records:** Comprehensive management of medical treatments and prescriptions, ensuring accurate and accessible patient health records.
- **Financial Transactions:** Automated generation and management of payment invoices, maintaining financial integrity and facilitating easy tracking of payments.

### 2. EER Diagram Option 8A Justification

The decision to use **Option 8A** (Superclass `Person` with Subclasses `Patient` and `Doctor`) in the EER diagram is justified by the need to:

- **Eliminate Data Redundancy:** By using a superclass for shared attributes (e.g., contact details), we avoid duplicating information across multiple tables, reducing storage requirements and potential inconsistencies.
- **Maintain Clean Inheritance:** This approach allows for a clear inheritance structure where specific attributes and behaviors of `Patient` and `Doctor` are managed in their respective tables, while common attributes are centralized in the `Person` table.
- **Simplify User Management:** The system can easily categorize users into different roles (e.g., patient, doctor, staff) using the `User_Type` attribute, facilitating role-based access and operations.

### 3. 3NF Normalization Mapping

The relational schema is meticulously designed to adhere to the **Third Normal Form (3NF)**, ensuring data integrity and minimizing redundancy:

1. **First Normal Form (1NF):**
   - All tables contain atomic values, with no repeating groups. For example, medical treatments and prescriptions are separated into distinct tables (`Medical_Treatment` and `Medicine_Prescription`).

2. **Second Normal Form (2NF):**
   - Each table is in 1NF and all non-key attributes are fully functionally dependent on the primary key. For instance, in the `Appointment` table, attributes like `Appt_Date` and `Appt_Time` depend entirely on `Appointment_ID`.

3. **Third Normal Form (3NF):**
   - The schema is in 2NF and all attributes are non-transitively dependent on the primary key. This ensures that attributes such as `Consultation_Fee` in the `Doctor` table depend solely on `Doctor_ID`, not on any other non-key attribute.

By adhering to 3NF, the database design ensures robust data integrity, efficient data retrieval, and ease of maintenance, aligning with the operational needs of the AuraCare Smart Clinic.