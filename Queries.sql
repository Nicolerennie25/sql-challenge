-- Create Tables if not exists (Omitted for brevity)

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

-- Convert date format and insert into final employees table, handling duplicates
INSERT INTO employees (emp_no, emp_title_id, birth_date, first_name, last_name, sex, hire_date)
SELECT emp_no, emp_title_id, TO_DATE(birth_date, 'MM/DD/YYYY'), first_name, last_name, sex, TO_DATE(hire_date, 'MM/DD/YYYY')
FROM temp_employees
ON CONFLICT (emp_no) DO NOTHING;

-- Drop the temporary table
DROP TABLE temp_employees;

-- Import departments.csv (Omitted for brevity)
-- Import titles.csv (Omitted for brevity)
-- Import salaries.csv (Omitted for brevity)
-- Import dept_manager (2).csv (Omitted for brevity)
-- Import dept_emp.csv (Omitted for brevity)

-- List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries ON employees.emp_no = salaries.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date >= '1986-01-01' AND hire_date < '1987-01-01';

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT dept_managers.dept_no, departments.dept_name, dept_managers.emp_no, employees.last_name, employees.first_name
FROM dept_managers
INNER JOIN departments ON dept_managers.dept_no = departments.dept_no
INNER JOIN employees ON dept_managers.emp_no = employees.emp_no;

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name, dept_emp.dept_no
FROM dept_emp
INNER JOIN employees ON dept_emp.emp_no = employees.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no;

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- List each employee in the Sales department, including their employee number, last name, and first name.
SELECT employees.emp_no, employees.last_name, employees.first_name
FROM employees
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
INNER JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name IN ('Sales', 'Development');

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;










