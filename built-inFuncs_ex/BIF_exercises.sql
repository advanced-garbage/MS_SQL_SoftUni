--Built-in Functions Exercises 

--1--
SELECT FirstName, LastName 
FROM Employees
WHERE FirstName LIKE 'Sa%'

--2--
SELECT FirstName, 
	   LastName
FROM Employees
WHERE LastName LIKE '%ei%'

--3--
SELECT FirstName FROM Employees
WHERE (DepartmentID = 3 OR DepartmentID = 10)
	  AND HireDate BETWEEN '1995-01-01' AND '2005-12-31'
	  
--4--
SELECT FirstName, LastName
FROM Employees
WHERE JobTitle NOT LIKE '%Engineer%'

--5--
SELECT ([Name])
FROM Towns
WHERE LEN([Name]) BETWEEN 5 AND 6
ORDER BY ([Name]) ASC

--6--
SELECT TownID, [Name]
FROM Towns
WHERE [Name] LIKE 'M%'
	  OR [Name] LIKE 'K%'
	  OR [Name] LIKE 'B%'
	  OR [Name] LIKE 'E%'
ORDER BY ([Name]) ASC

--7--
SELECT TownID, [Name]
FROM Towns
WHERE [Name] NOT LIKE 'R%'
	  AND [Name] NOT LIKE 'B%'
	  AND [Name] NOT LIKE 'D%'
ORDER BY ([Name]) ASC

--8--
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
FROM Employees
WHERE HireDate BETWEEN '2001-01-01' AND GETDATE();

--9--
SELECT FirstName, LastName 
FROM Employees
WHERE LEN(LastName) = 5

--10--
SELECT EmployeeID, FirstName, LastName, Salary,
DENSE_RANK() OVER (
	PARTITION BY Salary
	ORDER BY EmployeeID
) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--12--
SELECT CountryName, IsoCode 
FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode ASC

--13--
SELECT PeakName, RiverName,
	   LOWER(CONCAT(PeakName, SUBSTRING(RiverName, 2, LEN(RiverName)))) AS Mix 
FROM Peaks, Rivers
WHERE  SUBSTRING(PeakName, LEN(PeakName), 1) = LEFT(RiverName, 1)
ORDER BY Mix

--14--
SELECT TOP 50 [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM Games
WHERE DATEPART(Year, [Start]) BETWEEN 2011 AND 2012
ORDER BY [Start] ASC, [Name] ASC
 
--15--
 SELECT TOP 50 [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
 FROM Games
 WHERE DATEPART(Year, [Start]) BETWEEN 2011 AND 2012
 ORDER BY [Start] ASC, [Name] ASC
 
--16--
Select Username, IpAddress
FROM Users
WHERE IpAddress LIKE '___.1_%._%.___'
ORDER BY Username