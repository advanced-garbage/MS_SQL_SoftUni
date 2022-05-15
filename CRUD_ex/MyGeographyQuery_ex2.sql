-- ALL MOUNTAIN PEAKS
SELECT PeakName FROM Peaks 

-- TOP 30 COUNTRIES IN EUROPE
SELECT TOP (30) * FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY [Population] DESC, CountryName ASC

-- COUNTRIES AND CURRENCY
SELECT CountryCode,
	   CountryName,
CASE
	WHEN CurrencyCode = 'EUR' THEN 'Euro'
	ELSE 'Not Euro'
END AS Currency
FROM Countries
ORDER BY CountryName ASC