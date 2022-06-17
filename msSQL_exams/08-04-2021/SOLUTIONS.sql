-- msSQL test 8-4-2021

--1--
CREATE TABLE Users (
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(50) NOT NULL,
	[Name] VARCHAR(50),
	Birthdate DATETIME ,
	Age INT CHECK (Age BETWEEN 15 AND 110),
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Birthdate DATETIME,
	Age INT CHECK(Age BETWEEN 18 AND 110),
	DepartmentId INT REFERENCES Departments(Id)
)

CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	DepartmentId INT REFERENCES Departments(Id) NOT NULL
)

CREATE TABLE [Status] (
	Id INT PRIMARY KEY IDENTITY,
	[Label]	VARCHAR(30) NOT NULL
)

CREATE TABLE Reports (
	Id INT PRIMARY KEY IDENTITY,
	CategoryId INT REFERENCES Categories(Id) NOT NULL,
	StatusId INT REFERENCES [Status](Id) NOT NULL,
	OpenDate DATETIME NOT NULL,
	CloseDate DATETIME,
	[Description] VARCHAR(200) NOT NULL,
	UserId INT REFERENCES Users(Id) NOT NULL,
	EmployeeId INT REFERENCES Employees(Id)
)

--2--
INSERT INTO Employees(FirstName, LastName, Birthdate, DepartmentId)
VALUES 
('Marlo',	'O''Malley',	'1958-9-21',	1),
('Niki',	'Stanaghan'	, '1969-11-26',	4),
('Ayrton',	'Senna',	'1960-03-21',	9),
('Ronnie',	'Peterson',	'1944-02-14',	9),
('Giovanna',	'Amati',	'1959-07-20',	5)

INSERT INTO Reports
VALUES 
(1,	1,	'2017-04-13',	NULL	,'Stuck Road on Str.133',	6,	2),
(6,	3,	'2015-09-05',	'2015-12-06',	'Charity trail running',	3,	5),
(14, 2,	'2015-09-07', NULL,	'Falling bricks on Str.58',	5, 2),
(4,	3,	'2017-07-03',	'2017-07-06',	'Cut off streetlight on Str.11',	1,	1)

--3--
UPDATE Reports 
SET CloseDate = GETDATE()
WHERE CloseDate IS NULL

--4--
DELETE Reports 
WHERE StatusId = 4

--5--
SELECT r.[Description],
	CONVERT(VARCHAR(10),r.OpenDate,105)
FROM Reports AS r
WHERE r.EmployeeId IS NULL
ORDER BY r.OpenDate

--6--
SELECT r.[Description], c.[Name]
FROM Reports AS r
INNER JOIN Categories AS c ON r.CategoryId = c.Id 
ORDER BY r.[Description], c.[Name] 

--7--
SELECT TOP 5 c.[Name] AS CategoryName,
	COUNT(r.CategoryId) AS ReportsNumber
FROM Reports AS r
JOIN Categories AS c ON c.Id = r.CategoryId
GROUP BY c.[Name] 
ORDER BY ReportsNumber DESC, CategoryName

--8--
SELECT u.Username,
	c.[Name] AS CategoryName
FROM Reports AS r
	JOIN Users AS u ON u.Id = r.UserId
	JOIN Categories AS c ON c.Id = r.CategoryId
WHERE (DATEPART(DAY, r.OpenDate) = DATEPART(DAY, u.Birthdate)) AND
	  (DATEPART(MONTH, r.OpenDate) = DATEPART(MONTH, u.Birthdate))
ORDER BY u.Username, CategoryName

--9--
SELECT CONCAT(e.FirstName,' ', e.LastName) AS [FullName],
	COUNT(DISTINCT r.UserId) AS UsersCount
FROM Employees AS e
	LEFT JOIN Reports AS r ON e.Id = r.EmployeeId
GROUP BY CONCAT(e.FirstName,' ', e.LastName)
ORDER BY UsersCount DESC, [FullName] ASC 

--10--
SELECT CASE 
			WHEN e.FirstName IS NULL OR e.LastName IS NULL THEN 'None'
			ELSE e.FirstName + ' ' + e.LastName
		END AS [Employee],
	ISNULL(d.[Name], 'None') AS [Department],
	ISNULL(c.[Name], 'None') AS [Category],
	r.[Description],
	CONVERT(VARCHAR(10), r.OpenDate, 104) AS OpenDate,
	s.[Label] AS [Status],
	u.[Name] AS [User]
FROM Employees AS e
	JOIN Departments AS d ON d.Id = e.DepartmentId
	JOIN Reports AS r ON r.EmployeeId = e.Id 
	JOIN Categories AS c ON c.Id = r.CategoryId
	JOIN [Status] AS s ON s.Id = r.StatusId
	JOIN Users AS u ON u.Id = r.UserId
ORDER BY e.FirstName DESC,
	e.LastName DESC,
	[Department] ASC,
	[Category] ASC,
	[Description] ASC,
	OpenDate ASC,
	[Status] ASC,
	[User] ASC
	
--11--
CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME) 
RETURNS INT
AS
BEGIN
	DECLARE @result INT

	IF (@StartDate IS NULL OR @EndDate IS NULL) 
		BEGIN
			SET @result = 0
		END
	ELSE 
		SET @result = DATEDIFF(HOUR, @StartDate, @EndDate)

	RETURN @result
END

--12--
CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @empId INT = (SELECT Id FROM Employees WHERE @EmployeeId = Id)
		DECLARE @repId INT = (SELECT Id FROM Reports WHERE @ReportId = Id) 
		DECLARE @catId INT = (SELECT DepartmentId FROM Categories WHERE @repId = Id)

		IF (@empId != @catId)
				BEGIN
					ROLLBACK;
					THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1
				END

				UPDATE Reports
				SET EmployeeId = @EmployeeId
				WHERE Id = @ReportId
	COMMIT
END