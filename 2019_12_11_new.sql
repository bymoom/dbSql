CREATE TABLE regions (
     region_id NUMBER PRIMARY KEY,
     region_name VARCHAR2(25)
    );
     
CREATE TABLE countries (
     contry_id CHAR(2) PRIMARY KEY,
     contry_name VARCHAR2(40),
     region_id NUMBER,
    
    CONSTRAINT COUNTR_REG_FK FOREIGN KEY (region_id)
    REFERENCES regions (region_id)
     );
     
ALTER TABLE countries RENAME COLUMN contry_id TO country_id;
ALTER TABLE countries RENAME COLUMN contry_name TO country_name;

CREATE TABLE locations (
     location_id NUMBER(4) PRIMARY KEY,
     street_address VARCHAR2(40),
     postal_code VARCHAR2(12),
     city VARCHAR2(30),
     state_province VARCHAR2(25),
     country_id CHAR(2),
    
    CONSTRAINT LOC_C_ID_FK FOREIGN KEY (country_id)
    REFERENCES countries (country_id)
     );
     
CREATE TABLE departments (
     department_id NUMBER(4) PRIMARY KEY,
     department_name VARCHAR2(30),
     manager_id NUMBER(6),
     location_id NUMBER(4),
    
    CONSTRAINT DEPT_LOC_FK FOREIGN KEY (location_id)
    REFERENCES locations (location_id)
     );
     
CREATE TABLE job_history (
     employee_id NUMBER(6),
     start_date DATE,
     end_date DATE,
     job_id VARCHAR2(10),
     department_id NUMBER(4),
    
    CONSTRAINT pk_job_history PRIMARY KEY (employee_id, start_date),
    CONSTRAINT JHIST_DEPT_FK FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
     );
     
CREATE TABLE jobs (
     job_id VARCHAR2(10) PRIMARY KEY,
     job_title VARCHAR2(35),
     min_salary NUMBER(6),
     max_salary NUMBER(6)
     );     
     
ALTER TABLE job_history ADD CONSTRAINT JHIST_JOB_FK FOREIGN KEY (job_id)
            REFERENCES jobs (job_id);

CREATE TABLE employees (
     employee_id NUMBER(6) PRIMARY KEY,
     first_name VARCHAR2(20),
     last_name VARCHAR2(25),
     email VARCHAR2(25),
     phone_number VARCHAR2(20),
     hire_date DATE,
     job_id VARCHAR2(10),
     salary NUMBER(8, 2),
     commission_pct NUMBER(2, 2),
     manager_id NUMBER(6),
     department_id NUMBER(4),
    
    CONSTRAINT EMP_JOB_FK FOREIGN KEY (job_id)
    REFERENCES jobs (job_id)
     );

ALTER TABLE job_history ADD CONSTRAINT JHIST_EMP_FK FOREIGN KEY (employee_id)
            REFERENCES employees (employee_id);
            
ALTER TABLE employees ADD CONSTRAINT EMP_MANAGER_FK FOREIGN KEY (manager_id)
            REFERENCES employees (employee_id);
            
ALTER TABLE employees ADD CONSTRAINT EMP_DEPT_FK FOREIGN KEY (department_id)
            REFERENCES departments (department_id);

ALTER TABLE departments ADD CONSTRAINT DEPT_MGR_FK FOREIGN KEY (manager_id)
            REFERENCES employees (employee_id);

-- ALTER TABLE job_history ADD PRIMARY KEY (start_date); --¸ÁÇß...
DROP TABLE job_history;

--Á¶È¸
SELECT *
FROM user_constraints
WHERE TABLE_NAME = 'JOB_HISTORY';