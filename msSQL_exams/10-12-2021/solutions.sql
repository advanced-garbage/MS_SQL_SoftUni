--DB BASICS EXAM 10-12-2021--

--1--
CREATE TABLE Passengers (
	Id INT PRIMARY KEY IDENTITY,
	FullName VARCHAR(100) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots (
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) UNIQUE NOT NULL,
	LastName VARCHAR(30) UNIQUE NOT NULL,
	Age TINYINT NOT NULL CHECK (Age >= 21 AND Age <= 62),
	Rating FLOAT CHECK (Rating >= 0.0 AND Rating <= 10.0)
)

CREATE TABLE AircraftTypes (
	Id INT PRIMARY KEY IDENTITY,
	TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft (
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer VARCHAR(25) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	FlightHours INT,
	Condition CHAR(1) NOT NULL,
	TypeId INT REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft (
	AircraftId INT REFERENCES Aircraft(Id) NOT NULL,
	PilotId INT REFERENCES Pilots(Id) NOT NULL,
	PRIMARY KEY(AircraftId, PilotId)
)

CREATE TABLE Airports (
	Id INT PRIMARY KEY IDENTITY,
	AirportName VARCHAR(70) UNIQUE NOT NULL,
	Country VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations (
	Id INT PRIMARY KEY IDENTITY,
	AirportId INT REFERENCES Airports(Id) NOT NULL,
	[Start] DATETIME NOT NULL,
	AircraftId INT REFERENCES Aircraft(Id) NOT NULL,
	PassengerId INT REFERENCES Passengers(Id) NOT NULL,
	TicketPrice DECIMAL(18, 2) DEFAULT 15 NOT NULL
)

--2--
DECLARE @idx INT = 5
WHILE (@idx <= 15)
	BEGIN
		INSERT INTO Passengers(FullName, Email)
		SELECT FirstName + ' ' + LastName AS FullName,
		CONCAT(FirstName, LastName, '@gmail.com')
		FROM Pilots
		WHERE Id = @idx
		SET @idx += 1
	END
	
--3--
UPDATE Aircraft
SET Condition = 'A'
WHERE (Condition = 'B' OR Condition = 'C') AND
	  (FlightHours <= 100 OR FlightHours IS NULL) AND 
	  [Year] >= 2013
	  
--4--
DELETE Passengers 
	WHERE LEN(FullName) >= 10
	
--5--
SELECT Manufacturer, Model, FlightHours, Condition
FROM Aircraft 
ORDER BY FlightHours DESC

--6--
SELECT p.FirstName, p.LastName, a.Manufacturer, a.Model, a.FlightHours
FROM Pilots AS p
	JOIN PilotsAircraft AS pa ON pa.PilotId = p.Id
	JOIN Aircraft AS a ON pa.AircraftId = a.Id
WHERE (a.FlightHours IS NOT NULL AND a.FlightHours < 304)
ORDER BY a.FlightHours DESC, p.FirstName ASC 

--7--
SELECT TOP 20 fd.Id AS DestinationId,
	fd.[Start],
	p.FullName,
	a.AirportName,
	fd.TicketPrice
FROM FlightDestinations AS fd
	JOIN Passengers AS p ON fd.PassengerId = p.Id
	JOIN Airports AS a ON a.Id = fd.AirportId
WHERE DATEPART(DAY, fd.[Start]) % 2 = 0
ORDER BY fd.TicketPrice DESC, a.AirportName ASC

--8--
SELECT a.Id AS AircraftId,
	a.Manufacturer,
	a.FlightHours,
	COUNT(fd.Id) AS FlightDestinationsCount,
	ROUND(AVG(fd.TicketPrice), 2) AS AvgPrice
FROM Aircraft AS a
	JOIN FlightDestinations AS fd ON fd.AircraftId = a.Id
GROUP BY a.Id, a.Manufacturer, a.FlightHours
HAVING COUNT(fd.Id) >= 2
ORDER BY FlightDestinationsCount DESC, a.Id ASC

--9--
SELECT p.FullName,
	COUNT(a.Id) AS CountOfAircraft,
	SUM(fd.TicketPrice) AS TotalPayed
FROM Passengers AS p
	JOIN FlightDestinations AS fd ON fd.PassengerId = p.Id
	JOIN Aircraft AS a ON a.Id = fd.AircraftId
WHERE p.FullName LIKE '_a%'
GROUP BY p.FullName HAVING COUNT(a.Id) > 1
ORDER BY p.FullName

--10--
SELECT ap.AirportName,
	fd.[Start] AS DayTime,
	fd.TicketPrice,
	p.FullName,
	ac.Manufacturer,
	ac.Model
FROM FlightDestinations AS fd
	JOIN Airports AS ap ON ap.Id = fd.AirportId
	JOIN Passengers AS p ON p.Id = fd.PassengerId
	JOIN Aircraft AS ac ON ac.Id = fd.AircraftId
WHERE (fd.TicketPrice > 2500) AND 
DATEPART(HOUR, fd.[Start]) BETWEEN 6 AND 20
ORDER BY ac.Model ASC

--11--
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT
AS
BEGIN
	RETURN
		(SELECT COUNT(fd.Id)
		FROM Passengers AS p
			JOIN FlightDestinations AS fd ON fd.PassengerId = p.Id
		WHERE p.Email = @email)
END

--12--
CREATE PROC usp_SearchByAirportName(@airportName VARCHAR(70))
AS
BEGIN
	SELECT ap.AirportName,
		p.FullName,
		CASE 
			WHEN fd.TicketPrice <= 400 THEN 'Low'
			WHEN fd.TicketPrice <= 1500 THEN 'Medium'
			ELSE 'High' 
		END AS LevelOfTickerPrice,
		ac.Manufacturer,
		ac.Condition,
		act.TypeName
	FROM Airports AS ap
		JOIN FlightDestinations AS fd ON fd.AirportId = ap.Id
		JOIN Passengers AS p ON fd.PassengerId = p.Id
		JOIN Aircraft AS ac ON ac.Id = fd.AircraftId
		JOIN AircraftTypes AS act ON act.Id = ac.TypeId
	WHERE ap.AirportName = @airportName
	ORDER BY ac.Manufacturer, p.FullName
END