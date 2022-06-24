--Subqueries And Joins Exercises 

--2--
SELECT TOP 50 e.FirstName, e.LastName, t.Name AS Town, a.AddressText
FROM Employees  e
	JOIN Addresses a ON a.AddressID = e.AddressID
	JOIN Towns t ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName


--3--
SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] AS DepartmentName
FROM Employees e
	INNER JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID

--4--
SELECT e.FirstName, e.LastName, e.HireDate, d.Name AS DeptName 
FROM Employees e
	 INNER JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE DATEPART(YEAR, e.HireDate) > 1999
	  AND d.Name = 'Sales' OR d.Name = 'Finance'
ORDER BY e.HireDate

--6--
SELECT e.FirstName, e.LastName, e.HireDate, d.Name AS DeptName 
FROM Employees e
	 INNER JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE DATEPART(YEAR, e.HireDate) > 1999
	  AND d.Name = 'Sales' OR d.Name = 'Finance'
ORDER BY e.HireDate


--7--
SELECT TOP 5 e.EmployeeID, e.FirstName, p.Name AS ProjectName
FROM Employees AS e
	JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
	JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID ASC

--8--
SELECT e.EmployeeID, e.FirstName, 
	   CASE 
		   WHEN DATEPART(Year, p.StartDate) >= 2005 THEN NULL
		   ELSE p.Name
	   END AS ProjectName
FROM Employees AS e
	JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
	JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24

--9--
SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName	   
FROM Employees AS e
	JOIN Employees AS m ON m.EmployeeID = e.ManagerID
WHERE e.ManagerID = 3 OR e.ManagerID = 7
ORDER BY e.EmployeeID ASC

--10--
SELECT TOP 50
	e.EmployeeID,
	e.FirstName + ' ' + e.LastName AS EmployeeName ,
	m.FirstName + ' ' + m.LastName AS ManagerID,
	d.Name AS DepartmentName
FROM Employees AS e
	LEFT JOIN Employees AS m ON m.EmployeeID = e.ManagerID
	LEFT JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
ORDER BY e.EmployeeID ASC

--11--
SELECT 
	MIN(a.AverageSalary) AS MinAverageSalary
	FROM (
		SELECT e.DepartmentID,
		AVG(e.Salary) AS AverageSalary
		FROM Employees e
		GROUP BY e.DepartmentID
	) AS a
	
--12--
SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
	LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
	LEFT JOIN Peaks AS p ON p.MountainId = m.Id
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

--13--
SELECT mc.CountryCode, COUNT(m.MountainRange)
	FROM MountainsCountries mc
	JOIN Mountains m ON mc.MountainId = m.Id
	WHERE mc.CountryCode IN('US', 'RU', 'BG')
	GROUP BY CountryCode
	
--14--
SELECT TOP 5 c.CountryName, r.RiverName 
	FROM Countries AS c
		LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
		LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
	WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName ASC

--15--
SELECT ContinentCode, CurrencyCode, Total AS [CurrencyUsage]
	FROM
(
SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS Total,
	DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) AS Ranked
	FROM Countries 
	GROUP BY ContinentCode, CurrencyCode
) AS Sub
WHERE Ranked = 1 AND Total > 1
ORDER BY ContinentCode

--16--
SELECT COUNT(*)
	FROM Countries AS c
		LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
	WHERE mc.MountainId IS NULL
	
--17--
SELECT TOP(5) c.CountryName ,
	   MAX(p.Elevation) AS [HighestPeakElevation],
	   MAX(r.Length) AS [LongestRiverLength]
	FROM Countries AS c
		LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
		LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
		LEFT JOIN Peaks AS p ON m.Id = p.MountainId
		LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
		LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
	GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName ASC
	