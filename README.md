# AuraCare Smart Clinic Database System

## Project Overview

The **AuraCare Smart Clinic Database System** is an academic project developed as part of the IT244 - Introduction to Database course. The system is designed to digitize and streamline clinic management processes, including patient administration, clinical consultations, medical prescriptions, and financial billing. By leveraging a relational database model, the system ensures data integrity, consistency, and efficient management of clinic operations.

## Team Member Breakdown

- **Osama Kheder Aloldail** (S240009922 - Lead Architect)
  - Responsibilities: System Architecture, EER Specialization Design Option 8A, Relational Mapping & Normalization 3NF, Project Reflection Essay, Version History Management & Final Report Integration.
  
- **Ahmed Abdullah Alharbi** (S240032830 - Database Developer)
  - Responsibilities: DDL Script Implementation, Relational Schema Definition, Saudi-Localized Data Population.
  
- **Mohammed Almoerfi** (S240055942 - SQL Specialist)
  - Responsibilities: SQL Operations & Joins, Analytics Queries, Daily Schedule View Creation, Double-Booking Trigger, Reflection Essay.

## Repository Structure

- **/ddl/**: Contains the SQL scripts for database creation and schema definition.
- **/dml/**: Includes scripts for populating the database with sample data.
- **/views/**: SQL scripts for creating database views.
- **/triggers/**: Contains trigger definitions to enforce business rules.
- **/documentation/**: Project reports, reflection essays, and other documentation.

## SQL Execution Order

1. **DDL Scripts**: Begin by executing the DDL scripts to create the database schema. Ensure the `Person` table is created first, followed by subclass tables (`Patient`, `Doctor`), and then transactional tables (`Appointment`, `Medical_Treatment`, etc.).
2. **DML Scripts**: Populate the database with sample data using the DML scripts.
3. **View Creation**: Execute the view creation scripts to establish necessary views for data retrieval.
4. **Trigger Creation**: Implement triggers to enforce business rules and maintain data integrity.

## Screenshot Section Summaries

- **EER Diagram**: Visual representation of the database structure, showcasing the superclass/subclass relationships and entity mappings.
  >  <img width="600" height="656" alt="Screenshot 1448-02-16 at 2 05 13 PM" src="https://github.com/user-attachments/assets/b5ae7f90-e84b-463f-8929-231353c8db4e" />

- **Database Schema**: Screenshots of the database schema as viewed in MySQL Workbench, highlighting table structures and relationships.
  > <img width="819" height="445" alt="Screenshot 1448-02-16 at 2 36 53 PM" src="https://github.com/user-attachments/assets/cdb92e52-b7f2-4ae3-ae97-cc721205f288" />


- **Sample Data**: Screenshots of sample data entries in key tables, demonstrating the use of realistic Saudi clinical records.
  > <img width="811" height="318" alt="Screenshot 1448-02-16 at 2 34 14 PM" src="https://github.com/user-attachments/assets/db6a771d-8da5-4b14-9400-c5ef2707c048" />


- **SQL Query Results**: Screenshots of query results for various SQL operations, including joins, subqueries, and aggregations.
  > <img width="614" height="124" alt="Screenshot 1448-02-16 at 2 34 40 PM" src="https://github.com/user-attachments/assets/f7056677-05a4-4147-869b-14facb6774e1" />


- **Trigger Execution**: Screenshots showing the execution and validation of triggers, ensuring business rules are enforced.
  > <img width="819" height="463" alt="Screenshot 1448-02-16 at 2 45 04 PM" src="https://github.com/user-attachments/assets/4eca41b1-6653-454e-8b85-c996ad04302f" />


## Project Artifacts

- **Live Report Document**: [Google Docs](https://docs.google.com/document/d/1-AI9AmQwSCbFYrTkSOxY9n3kVyjo_O4VCezg0pNOZ8s/edit?usp=drivesdk)
- **GitHub Repository**: [GitHub](https://github.com/d7ah52/IT-244-project-SmartClinic)

This README provides a comprehensive overview of the AuraCare Smart Clinic Database System, detailing the project's objectives, team contributions, and technical implementation. For further details, please refer to the project artifacts linked above.
