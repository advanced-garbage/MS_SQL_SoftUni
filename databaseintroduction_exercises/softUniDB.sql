CREATE TABLE Towns (
	Id INT IDENTITY(1,1) NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
);

ALTER TABLE Towns
ADD CONSTRAINT TownId_asPrimary PRIMARY KEY (Id);

CREATE TABLE Addresses (
	Id INT IDENTITY(1,1) NOT NULL,
	AddressText VARCHAR(100) NOT NULL,
	TownId INT NOT NULL,
);

ALTER TABLE Addresses
ADD CONSTRAINT AddressesId_asPrimary PRIMARY KEY (Id);

CREATE TABLE Departments (
	Id INT IDENTITY(1,1) NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
);

ALTER TABLE Departments 
ADD CONSTRAINT DepartmentsId_asPrimary PRIMARY KEY (Id);

CREATE TABLE Employees (
	Id INT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	MiddleName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	JobTitle VARCHAR(50) NOT NULL,
	DepartmentId INT NOT NULL,
	HireDate DATE,
	Salary DECIMAL(18, 2) NOT NULL,
	AdressId INT
);

ALTER TABLE Employees
ADD CONSTRAINT EmployeesId_asPrimary PRIMARY KEY (Id);

ALTER TABLE Employees
ADD CONSTRAINT EmployeesDeparmentsId_asForeign
FOREIGN KEY (DepartmentId) REFERENCES Departments(Id);

ALTER TABLE Employees
ADD CONSTRAINT EmployeesAdressId_asForeign
FOREIGN KEY (AdressId) REFERENCES Addresses(Id);

-- (17) BACKING UP, DELETING AND RESTORING A DB 
BACKUP DATABASE SoftUni TO DISK = 'filepath'

DROP DATABASE SoftUni 

RESTORE DATABASE SoftUni FROM DISK = 'filepath'

-- (18) BASIC INSERT
INSERT INTO Towns VALUES
('Sofia'),('Plovdiv'),('Varna'),('Burgas')

INSERT INTO Departments VALUES
('Engineering'),('Sales'),('Marketing'),('Software Development'),('Quality Assurance')

INSERT INTO Employees VALUES 
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00, NULL),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00, NULL),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-02', 525.25, NULL),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00, NULL),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88, NULL)

-- (19) SELECT ALL FIELDS 
SELECT * FROM Towns 
SELECT * FROM Departments 
SELECT * FROM Employees

-- (20) SELECT ALL FIELDS AND SORT 
SELECT * FROM Towns ORDER BY [Name] ASC
SELECT * FROM Departments ORDER BY [Name] ASC
SELECT * FROM Employees ORDER BY Salary DESC

-- (21) SELECT SOME FIELDS 
SELECT [Name] FROM Towns ORDER BY [Name] ASC
SELECT [Name] FROM Departments ORDER BY [Name] ASC
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

-- (22) UPDATE SALARY 
UPDATE Employees
SET Salary *= 1.1
SELECT Salary FROM Employees