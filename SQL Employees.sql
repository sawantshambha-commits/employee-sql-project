-- Create Database
CREATE DATABASE employee_project;
USE employee_project;

-- CREAT TABLES
-- ========================

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    gender VARCHAR(10),
    hire_date DATE
);

CREATE TABLE salaries (
    emp_id INT,
    salary INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE titles (
    emp_id INT,
    title VARCHAR(50),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE dept_emp (
    emp_id INT,
    dept_id INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- ========================
-- INSERT DATA
-- ========================

INSERT INTO departments VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Marketing');

-- Employees 
INSERT INTO employees VALUES
(101, 'Amit', 'Male', '2020-01-10'),
(102, 'Priya', 'Female', '2019-03-15'),
(103, 'Rahul', 'Male', '2021-07-01'),
(104, 'Sneha', 'Female', '2018-05-20'),
(105, 'Vikas', 'Male', '2022-02-10'),
(106, 'Amit', 'Male', '2021-09-12'),
(107, 'Priya', 'Female', '2020-11-11'),
(108, 'Rahul', 'Male', '2023-01-01'),
(109, 'Neha', 'Female', '2022-04-18'),
(110, 'Karan', 'Male', '2019-08-25'),
(111, 'Rohit', 'Male', '2020-06-30'),
(112, 'Anjali', 'Female', '2021-12-15'),
(113, 'Vikas', 'Male', '2022-09-01'),
(114, 'Sneha', 'Female', '2023-02-20'),
(115, 'Kiran', 'Female', '2023-03-10'),
(116, 'Amit', 'Male', '2024-01-01'),
(117, 'Neha', 'Female', '2021-05-05'),
(118, 'Rohit', 'Male', '2020-10-10'),
(119, 'Priya', 'Female', '2022-07-07'),
(120, 'Karan', 'Male', '2023-08-08');

-- Salaries 
INSERT INTO salaries VALUES
(101, 50000),
(102, 60000),
(103, 45000),
(104, 70000),
(105, 40000),
(106, 50000),
(107, 60000),
(108, 45000),
(109, 40000),
(110, 70000),
(111, 55000),
(112, 55000),
(113, 40000),
(114, 70000),
(115, 50000),
(116, 50000),
(117, 40000),
(118, 55000),
(119, 60000),
(120, 70000);

-- Titles
INSERT INTO titles VALUES
(101, 'Developer'),
(102, 'Manager'),
(103, 'Analyst'),
(104, 'Senior Manager'),
(105, 'Intern'),
(106, 'Developer'),
(107, 'HR Executive'),
(108, 'Analyst'),
(109, 'Intern'),
(110, 'Developer'),
(111, 'Team Lead'),
(112, 'Manager'),
(113, 'Intern'),
(114, 'Senior Manager'),
(115, 'HR Executive'),
(116, 'Developer'),
(117, 'Analyst'),
(118, 'Team Lead'),
(119, 'Manager'),
(120, 'Developer');

-- Department Mapping
INSERT INTO dept_emp VALUES
(101, 2),
(102, 1),
(103, 3),
(104, 1),
(105, 2),
(106, 2),
(107, 1),
(108, 3),
(109, 5),
(110, 2),
(111, 4),
(112, 4),
(113, 5),
(114, 1),
(115, 4),
(116, 2),
(117, 5),
(118, 4),
(119, 1),
(120, 2);

-- 1. Get all employees with their department names
SELECT e.name, d.dept_name
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_id = de.emp_id
INNER JOIN departments as d on de.dept_id = d.dept_id;

-- 2. Find total number of employees in each department
SELECT d.dept_name, COUNT(e.emp_id) as Total_Employees
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_id = de.emp_id
INNER JOIN departments as d 
ON de.dept_id = d.dept_id
GROUP BY d.dept_name;

-- 3. Find the highest salary in the company
SELECT MAX(salary) FROM salaries;

-- 4. Find the second highest salary
SELECT MAX(salary) FROM salaries
WHERE salary < (SELECT MAX(salary) FROM salaries);

-- 5. Find all employees earning more than average salary
SELECT e.name, s.salary
FROM employees as e
INNER JOIN salaries as s
on e.emp_id = s.emp_id
where salary > (SELECT AVG(salary) FROM salaries);

-- 6. Get employee name and salary in descending order
SELECT e.name, s.salary
FROM employees as e
INNER JOIN salaries as s
ON e.emp_id = s.emp_id
ORDER BY salary DESC;

-- 7. Count total number of employees
SELECT COUNT(emp_id) as Total_Employees 
FROM employees;

-- 8. Find duplicate employee names
SELECT name, count(name)
FROM employees
GROUP BY name
HAVING count(name) > 1;

-- 9. Find duplicate salaries
SELECT s.salary, count(s.salary) as Total
FROM employees as e
INNER JOIN salaries as s
on e.emp_id = s.emp_id
group by salary
having count(s.salary) > 1;

-- 10. Find employees who share the same salary
SELECT e.name, s.salary
FROM employees as e
INNER JOIN salaries as s
on e.emp_id = s.emp_id
where salary in (select salary from salaries group by salary having count(salary) > 1) 
order by salary;

SELECT e1.name, s1.salary
FROM employees as e1
INNER JOIN salaries as s1
on e1.emp_id = s1.emp_id
INNER JOIN salaries as s2 on s1.salary = s2.salary
INNER JOIN employees as e2 on s2.emp_id = e2.emp_id
where e1.emp_id <> e2.emp_id;

-- 11. Find department-wise average salary
select d.dept_name, avg(s.salary)
from departments as d 
inner join dept_emp as de
on d.dept_id = de.dept_id
inner join employees as e 
on e.emp_id = de.emp_id
inner join salaries as s
on e.emp_id = s.emp_id
group by dept_name;

-- 12. Find department with highest average salary
select d.dept_name, avg(s.salary) as Avg_Salary
from departments as d 
inner join dept_emp as de
on d.dept_id = de.dept_id
inner join employees as e 
on e.emp_id = de.emp_id
inner join salaries as s
on e.emp_id = s.emp_id
group by dept_name
order by Avg_Salary desc
limit 1;
-- 13. Find employees who are not assigned to any department
select e.emp_id, e.name, d.dept_name
from employees as e
Left Join dept_emp as de
on e.emp_id = de.emp_id
Left Join departments as d
on de.dept_id = d.dept_id
where d.dept_id is Null;

-- 14. Find employees hired after 2021
select * from employees
where year(hire_date) > 2021;

-- 15. Find number of employees hired each year
select year(hire_date) as year, count(emp_id) as employees_hired from employees
group by year(hire_date)
order by year(hire_date);

-- 16. Find third highest salary
select * from salaries
order by salary desc
limit 2,1;

-- 17. Find highest salary in each department
select d.dept_name, max(s.salary)
from employees as e
inner join salaries as s
on e.emp_id = s.emp_id
inner join dept_emp as de
on e.emp_id = de.emp_id
inner join departments as d
on de.dept_id = d.dept_id
group by dept_name;

-- 18 Find employees with highest salary in each department.
SELECT e.name, d.dept_name, s.salary
FROM employees AS e
INNER JOIN salaries AS s ON e.emp_id = s.emp_id
INNER JOIN dept_emp AS de ON e.emp_id = de.emp_id
INNER JOIN departments AS d ON de.dept_id = d.dept_id
WHERE s.salary = (
SELECT MAX(s2.salary)
    FROM employees AS e2
    INNER JOIN salaries AS s2 ON e2.emp_id = s2.emp_id
    INNER JOIN dept_emp AS de2 ON e2.emp_id = de2.emp_id
    WHERE de2.dept_id = d.dept_id);
    
-- 19. Find employees whose salary is same as another employee
select distinct e1.name, e1.emp_id, s1.salary
from employees e1
join salaries s1 on e1.emp_id = s1.emp_id
join employees e2 on e1.emp_id <> e2.emp_id
join salaries s2 on e2.emp_id = s2.emp_id
where s1.salary = s2.salary
order by salary;

-- 19. Find departments having more than 3 employees
select d.dept_name, count(e.emp_id) as Total_Employees
from employees as e
inner join dept_emp as de
on e.emp_id = de.emp_id
inner join departments as d
on de.dept_id = d.dept_id
group by dept_name
having Total_Employees > 3;

-- 20. Rank employees based on salary
select e.emp_id, e.name, s.salary,
rank() over (order by s.salary desc) as Salary_Rank
from employees e
join salaries s on e.emp_id = s.emp_id;