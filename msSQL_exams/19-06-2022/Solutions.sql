-- DB Exam 19-06-2022

--1--
CREATE TABLE Owners (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50)
)

CREATE TABLE AnimalTypes (
	Id INT PRIMARY KEY IDENTITY,
	AnimalType VARCHAR(30) NOT NULL,
)

CREATE TABLE Cages (
	Id INT PRIMARY KEY IDENTITY,
	AnimalTypeId INT REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE Animals (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL,
	OwnerId INT REFERENCES Owners(Id),
	AnimalTypeId INT REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE AnimalsCages (
	CageId INT REFERENCES Cages(Id) NOT NULL,
	AnimalId INT REFERENCES Animals(Id) NOT NULL,
	PRIMARY KEY(CageId, AnimalId)
)

CREATE TABLE VolunteersDepartments (
	Id INT PRIMARY KEY IDENTITY,
	DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,	
	[Address] VARCHAR(50),
	AnimalId INT REFERENCES Animals(Id),
	DepartmentId INT REFERENCES VolunteersDepartments(Id) NOT NULL
)

--2--
INSERT INTO Volunteers VALUES 
('Anita Kostova',	'0896365412',	'Sofia, 5 Rosa str.',	15,	1),
('Dimitur Stoev',	'0877564223',	NULL,	42,	4),
('Kalina Evtimova',	'0896321112',	'Silistra, 21 Breza str.',	9,	7),
('Stoyan Tomov',	'0898564100',	'Montana, 1 Bor str.',	18,	8),
('Boryana Mileva',	'0888112233',	NULL,	31,	5)

INSERT INTO Animals VALUES
('Giraffe',	'2018-09-21',	21,	1),
('Harpy Eagle',	'2015-04-17',	15,	3),
('Hamadryas Baboon',	'2017-11-02',	NULL,	1),
('Tuatara',	'2021-06-30',	2,	4)

--3--
UPDATE Animals 
SET OwnerId = 4
WHERE OwnerId IS NULL

--4--
DELETE FROM Volunteers 
WHERE DepartmentId IN (SELECT Id FROM VolunteersDepartments
					   WHERE DepartmentName = 'Education program assistant')

DELETE FROM VolunteersDepartments
WHERE DepartmentName = 'Education program assistant'

--5--
SELECT [Name], PhoneNumber, [Address], AnimalId, DepartmentId
FROM Volunteers 
ORDER BY [Name], AnimalId, DepartmentId 

--6--
SELECT a.[Name],
	[at].AnimalType,
	CONVERT(VARCHAR(15), a.BirthDate, 104) AS BirthDate
FROM Animals a
	JOIN AnimalTypes [at] ON a.AnimalTypeId = [at].Id
ORDER BY a.[Name]

--7--
SELECT TOP 5 o.[Name], 
	COUNT(a.OwnerId) AS CountOfAnimals
FROM Owners o 
	JOIN Animals a ON a.OwnerId = o.Id
GROUP BY o.Id, o.[Name]
ORDER BY CountOfAnimals DESC, o.[Name] ASC

--8--
SELECT CONCAT(o.[Name],'-',a.[Name]) AS OwnersAnimals,
	o.PhoneNumber,
	c.Id AS CageId
FROM Owners o 
	JOIN Animals a ON o.Id = a.OwnerId
	JOIN AnimalsCages ac ON a.Id = ac.AnimalId
	JOIN Cages c ON ac.CageId = c.Id
WHERE a.AnimalTypeId = 1
ORDER BY o.[Name] ASC, a.[Name] DESC

--9--
SELECT [Name],
	PhoneNumber,
	TRIM(SUBSTRING([Address], CHARINDEX(',', [Address]) + 1, 50)) AS [Address]
FROM Volunteers
WHERE [Address] LIKE '%Sofia%' AND DepartmentId = 2
ORDER BY [Name]

--10--
SELECT a.[Name],
	DATEPART(YEAR, a.BirthDate) AS BirthYear,
	[at].AnimalType
FROM Animals a 
	JOIN AnimalTypes [at] ON a.AnimalTypeId = [at].Id
WHERE (a.AnimalTypeId <> 3) AND
	(a.OwnerId IS NULL) AND
	DATEPART(YEAR, a.BirthDate) > 2017
ORDER BY a.[Name]

--11--
CREATE FUNCTION udf_GetVolunteersCountFromADepartment(@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN(SELECT COUNT(*)
		   FROM Volunteers
		   WHERE DepartmentId IN (SELECT Id FROM VolunteersDepartments
								  WHERE DepartmentName = @VolunteersDepartment))
END

--12--
CREATE PROC usp_AnimalsWithOwnersOrNot(@AnimalName VARCHAR(30))
AS
BEGIN

	SELECT a.[Name],
		CASE
			WHEN OwnerId IS NULL THEN 'For adoption'
			ELSE (SELECT [Name] FROM Owners WHERE Id IN (SELECT OwnerId FROM Animals WHERE [Name] = @AnimalName))
		END AS OwnersName
	FROM Animals a		
	WHERE a.[Name] = @AnimalName
END
