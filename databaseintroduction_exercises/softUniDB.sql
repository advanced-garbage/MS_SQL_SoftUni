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
	Salary INT NOT NULL,
	AdressId INT NOT NULL,
);

ALTER TABLE Employees
ADD CONSTRAINT EmployeesId_asPrimary PRIMARY KEY (Id);

ALTER TABLE Employees
ADD CONSTRAINT EmployeesDeparmentsId_asForeign
FOREIGN KEY (DepartmentId) REFERENCES Departments(Id);

ALTER TABLE Employees
ADD CONSTRAINT EmployeesAdressId_asForeign
FOREIGN KEY (AdressId) REFERENCES Addresses(Id);