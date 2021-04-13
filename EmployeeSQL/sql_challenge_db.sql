/*	Author: Darren Kim
	Monash Bootcamp: Data Analytics and Visualisation 
---------------------------------------------------------------- */
-- 1. Create Department table
CREATE TABLE Departments (
    dept_no VARCHAR PRIMARY KEY NOT NULL,
	dept_name VARCHAR NOT NULL
);

-- 2. Create Titles table
CREATE TABLE Titles (
	title_id VARCHAR PRIMARY KEY NOT NULL,
	title VARCHAR NOT NULL
);

-- 3. Create Employees table
CREATE TABLE Employees (
	emp_no INTEGER PRIMARY KEY NOT NULL,
	emp_title_id VARCHAR NOT NULL,
    birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES Titles (title_id)
);

-- 4. Create a dept_manager table
CREATE TABLE dept_manager (
    dept_no VARCHAR NOT NULL,
    emp_no INTEGER NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES Departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no)
);

-- 5. Create dept_emp table
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES Departments (dept_no)
);

-- 6. Create a Salaries table
CREATE TABLE Salaries (
	emp_no INT,
	salary INT,
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no)
);

/* VIEW THE TABLES
-- SELECT * FROM dept_manager;
-- SELECT * FROM Departments;
-- SELECT * FROM dept_emp;
-- SELECT * FROM Employees;
-- SELECT * FROM Salaries;
-- SELECT * FROM Titles;

-- TO REMOVE TABLE AND ITS DEPENDENCIES
-- DROP TABLE Departments CASCADE;
-- DROP TABLE dept_emp CASCADE;
-- DROP TABLE dept_manager CASCADE;
-- DROP TABLE Employees CASCADE;
-- DROP TABLE Salaries CASCADE;
-- DROP TABLE Titles CASCADE;

-- DATA ANALYSIS
----------------------------------------------------------------*/

-- 1. List the following details of each employee: 
-- employee number, last name, first name, sex, and salary.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, s.salary
FROM employees
INNER JOIN salaries AS s ON employees.emp_no = s.emp_no;

-- 2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM "hire_date") = 1986;

-- 3. List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, first name.
SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM departments AS d
INNER JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
INNER JOIN employees AS e ON e.emp_no = dm.emp_no;

-- 4. List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.last_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS de ON de.emp_no = e.emp_no
JOIN departments AS d ON d.dept_no = de.dept_no;

-- 5. List first name, last name, and sex for employees whose 
-- first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name, sex
FROM employees
WHERE first_name LIKE 'Hercules%' and last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number,
-- last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON de.dept_no = d.dept_no
WHERE dept_name LIKE 'Sales%';

-- 7. List all employees in the Sales and Development departments, 
-- including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON de.dept_no = d.dept_no
WHERE dept_name IN ('Sales','Development');

-- 8. In descending order, list the frequency count of employee last names, 
-- i.e., how many employees share each last name.
SELECT last_name,
COUNT(last_name) AS Total
FROM employees
GROUP BY last_name
ORDER BY Total DESC;
