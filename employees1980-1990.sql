-- Create Employees Table
CREATE TABLE employees (
    emp_no INT PRIMARY KEY,
    emp_title_id VARCHAR(10),
    birth_date DATE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    sex CHAR(1),
    hire_date DATE
);

-- Create Departments Table
CREATE TABLE departments (
    dept_no VARCHAR(4) PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Create Titles Table
CREATE TABLE titles (
    title_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(50)
);

-- Create Salaries Table
CREATE TABLE salaries (
    emp_no INT PRIMARY KEY,
    salary INT
);

-- Create Department Managers Table
CREATE TABLE dept_managers (
    dept_no VARCHAR(4),
    emp_no INT,
    PRIMARY KEY (dept_no, emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Create Department-Employee Relationship Table
CREATE TABLE dept_emp (
    emp_no INT,
    dept_no VARCHAR(4),
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- Import employees.csv into temporary table with VARCHAR date columns
CREATE TEMP TABLE temp_employees (
    emp_no INT,
    emp_title_id VARCHAR(10),
    birth_date VARCHAR(10), -- Assuming date format is 'MM/DD/YYYY'
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    sex CHAR(1),
    hire_date VARCHAR(10) -- Assuming date format is 'MM/DD/YYYY'
);

-- Import employees.csv into temporary table
COPY temp_employees (emp_no, emp_title_id, birth_date, first_name, last_name, sex, hire_date)
FROM 'C:\Program Files\PostgreSQL\employees.csv'
DELIMITER ',' CSV HEADER;

-- Convert date format and insert into final employees table
INSERT INTO employees (emp_no, emp_title_id, birth_date, first_name, last_name, sex, hire_date)
SELECT emp_no, emp_title_id, TO_DATE(birth_date, 'MM/DD/YYYY'), first_name, last_name, sex, TO_DATE(hire_date, 'MM/DD/YYYY')
FROM temp_employees;

-- Drop the temporary table
DROP TABLE temp_employees;

-- Import departments.csv
COPY departments FROM 'C:\Program Files\PostgreSQL\departments.csv' DELIMITER ',' CSV HEADER;

-- Import dept_emp.csv
COPY dept_emp FROM 'C:\Program Files\PostgreSQL\dept_emp.csv' DELIMITER ',' CSV HEADER;

-- Import titles.csv
COPY titles FROM 'C:\Program Files\PostgreSQL\titles.csv' DELIMITER ',' CSV HEADER;

-- Import salaries.csv
COPY salaries FROM 'C:\Program Files\PostgreSQL\salaries.csv' DELIMITER ',' CSV HEADER;

-- Import dept_manager (2).csv
COPY dept_managers FROM 'C:\Program Files\PostgreSQL\dept_manager (2).csv' DELIMITER ',' CSV HEADER;
