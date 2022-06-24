-- TABLE RELATIONS Exercises 

--1--
CREATE TABLE Passports
(
	PassportID INT PRIMARY KEY IDENTITY(101,1),
	PassportNumber NVARCHAR(20) NOT NULL
)


INSERT INTO Passports
		(PassportNumber)
	VALUES
		('N34FG21B'),
		('K65LO4R7'),
		('ZE657QP2')


CREATE TABLE Persons
(
	PersonID INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(20) NOT NULL,
	Salary DECIMAL(7,2) NOT NULL,
	PassportID INT REFERENCES Passports(PassportID) UNIQUE NOT NULL
)


INSERT INTO Persons
		(FirstName,Salary,PassportID)
	VALUES
		('Roberto', 43300, 102),
		('Tom', 56100, 103),
		('Yana', 60200, 101)
		
--2--
CREATE TABLE Manufacturers (
	ManufacturerID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(20) NOT NULL,
	EstablishedOn DATE NOT NULL
);

INSERT INTO Manufacturers ([Name], EstablishedOn) VALUES 
('BMW', '07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/05/1966')

CREATE TABLE Models (
	ModelID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(20) NOT NULL,
	ManufacturerID INT REFERENCES Manufacturers(ManufacturerID) NOT NULL
);

INSERT INTO Models ([Name], ManufacturerId) VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)

--3--
CREATE TABLE Students (
	StudentID INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
);

INSERT INTO Students
	([Name])
VALUES
	('Mila'),
	('Toni'),
	('Ron')

CREATE TABLE Exams (
	ExamID INT PRIMARY KEY IDENTITY(101,1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
);

INSERT INTO Exams
	([Name])
VALUES
	('SpringMVC'),
	('Neo4j'),
	('Oracle 11g')

CREATE TABLE StudentsExams (
	StudentID INT,
	ExamID INT,
	CONSTRAINT SE_SIDandEIDasPrimary
	PRIMARY KEY(StudentID, ExamID),
	CONSTRAINT SE_SIDrefSTUDENTS
	FOREIGN KEY (StudentID)
	REFERENCES Students(StudentID),
	CONSTRAINT SE_EIDrefEXAMS
	FOREIGN KEY (ExamID)
	REFERENCES Exams(ExamID)
);

INSERT INTO StudentsExams
	(StudentID, ExamID)
VALUES
	(1, 101),
	(1, 102),
	(2, 101),
	(3, 103),
	(2, 102),
	(2, 103)

--4--
CREATE TABLE Teachers (
	TeacherID INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(50) NOT NULL,
	ManagerID INT REFERENCES Teachers(TeacherID)
);

INSERT INTO Teachers 
	([Name], ManagerID)
VALUES
	('John', NULL),
	('Maya', 106),
	('Silvia', 106),
	('Ted', 105),
	('Mark', 101),
	('Greta', 101)
	
--5--
CREATE TABLE ItemTypes (
	ItemTypeID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50)
);

CREATE TABLE Items (
	ItemID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50),
	ItemTypeID INT REFERENCES ItemTypes(ItemTypeID),
);

CREATE TABLE OrderItems (
	OrderID INT,
	ItemID INT REFERENCES Items(ItemID),
	PRIMARY KEY(OrderID, ItemID)
);

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50),
	Birthday DATE,
	CityID INT,
);


CREATE TABLE Cities (
	CityID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50)
);

CREATE TABLE Orders (
	OrderID INT PRIMARY KEY IDENTITY,
	CustomerID INT REFERENCES Customers(CustomerID)
);

ALTER TABLE OrderItems
ADD FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)

ALTER TABLE Customers
ADD FOREIGN KEY (CityID) REFERENCES Cities(CityID)

--6--
CREATE TABLE Subjects (
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName VARCHAR(50) NOT NULL
);

CREATE TABLE Majors (
	MajorID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
);

CREATE TABLE Students (
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber INT NOT NULL,
	StudentName VARCHAR(50) NOT NULL,
	MajorID INT REFERENCES Majors(MajorID)
);

CREATE TABLE Agenda (
	StudentID INT REFERENCES Students(StudentID),
	SubjectID INT REFERENCES Subjects(SubjectID),
	PRIMARY KEY(StudentID, SubjectID)
);

CREATE TABLE Payments (
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATE NOT NULL,
	PaymentAmount INT NOT NULL,
	StudentID INT REFERENCES Students(StudentID)
);
