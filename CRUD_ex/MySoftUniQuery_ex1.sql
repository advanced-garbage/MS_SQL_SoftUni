-- QUERIES FOR SOFTUNI DATABASE

-- FIND ALL INFORMATION ABOUT DEPARTMENTS
SELECT * FROM Departments

-- FIND ALL INFORMATION ABOUT DEPARTMENT NAMES
SELECT [Name] FROM Departments

-- FIND FIRST NAME, LAST NAME AND SALARY FROM EMPLOYEES
SELECT FirstName, LastName, Salary FROM Employees

-- FIND FULL NAME OF EACH EMPLOYEE
SELECT FirstName, MiddleName, LastName FROM Employees

-- FIND FULL EMAILS FROM EMPLOYEES
SELECT FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Address]
FROM Employees

-- FIND ALL DIFFERENT EMPLOYEE'S SALARIES
SELECT Salary FROM Employees

-- FIND ALL THE INFO FOR PEOPLE UNDER 'SALES REPRESENTATIVE'
SELECT * FROM Employees WHERE JobTitle = 'Sales Representative'

-- FIND NAMES OF EMPLOYEES WITHIN SALARY RANGE
SELECT FirstName, LastName, Salary FROM Employees WHERE Salary BETWEEN 20000 AND 30000

-- FIND NAMES OF ALL EMPLOYEES
SELECT FirstName, MiddleName, LastName as [Full Name]
FROM Employees
WHERE SALARY = 25000 OR
	  SALARY = 14000 OR
	  SALARY = 12500 OR
	  SALARY = 23600

-- FIND EMPLOYEES WITHOUT MANAGER
SELECT FirstName, LastName FROM Employees
WHERE ManagerID IS NULL

-- FIND SALARY WHERE > 50000
SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC 

-- FIND TOP FIVE EMPLOYEES
SELECT TOP (5) * FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC 

-- FIND ALL EMPLOYEES WITHOUT MARKETING
SELECT FirstName, LastName FROM Employees
WHERE NOT DepartmentID = 4

-- SORTING
SELECT * FROM Employees
ORDER BY Salary DESC, FirstName ASC, LastName DESC, MiddleName ASC

-- CREATE VIEWS (IN A NEW QUERY!)
--CREATE VIEW [V_EmployeesSalaries] 
--AS
	--SELECT FirstName, LastName, Salary FROM Employees

--CREATE VIEW [V_EmployeeNameJobTitle]
--AS
	--SELECT FirstName, MiddleName, Salary AS [Full Name],
		   --JobTitle 
	--FROM Employees

-- FIND DISTINCT JOB TITLES
SELECT DISTINCT JobTitle FROM Employees

-- FIND TOP 10 EARLIEST PROJECTS
SELECT TOP (10)* FROM Projects
ORDER BY StartDate ASC, [Name] ASC

-- FIND LATEST 7 EMPLOYEES
SELECT TOP(7) FirstName, LastName, HireDate FROM Employees
ORDER BY HireDate DESC

-- UPDATE SALARIES
UPDATE Employees
SET Salary *= 1.12
WHERE DepartmentID = 12 OR
	  DepartmentID = 4 OR
	  DepartmentID = 46 OR
	  DepartmentID = 42