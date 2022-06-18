-- DB exam 27-06-2020

--1--
CREATE TABLE Clients (
	ClientId INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Phone VARCHAR(12) CHECK(LEN(Phone) = 12) NOT NULL
)

CREATE TABLE Mechanics (
	MechanicId INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	[Address] VARCHAR(255) NOT NULL
)

CREATE TABLE Models (
	ModelId INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Jobs (
	JobId INT PRIMARY KEY IDENTITY,
	ModelId INT REFERENCES Models(ModelId) NOT NULL,
	[Status] VARCHAR(50) DEFAULT('Pending') 
		CHECK([Status] = 'Pending' OR [Status] = 'In Progress' OR [Status] = 'Finished') NOT NULL,
	ClientId INT REFERENCES Clients(ClientId) NOT NULL,
	MechanicId INT REFERENCES Mechanics(MechanicId),
	IssueDate DATE NOT NULL,
	FinishDate DATE
)

CREATE TABLE Orders (
	OrderId INT PRIMARY KEY IDENTITY,
	JobId INT REFERENCES Jobs(JobId) NOT NULL,
	IssueDate DATE,
	Delivered BIT DEFAULT(0) NOT NULL
)

CREATE TABLE Vendors (
	VendorId INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Parts (
	PartId INT PRIMARY KEY IDENTITY,
	SerialNumber VARCHAR(50) UNIQUE NOT NULL,
	[Description] VARCHAR(255),
	Price MONEY CHECK(Price BETWEEN 1 AND 9999.99) NOT NULL,
	VendorId INT REFERENCES Vendors(VendorId) NOT NULL,
	StockQty INT DEFAULT(0) CHECK(StockQty >= 0) NOT NULL
)

CREATE TABLE OrderParts (
	OrderId INT REFERENCES Orders(OrderId) NOT NULL,
	PartId INT REFERENCES Parts(PartId) NOT NULL,
	Quantity INT DEFAULT(1) CHECK(Quantity >= 0) NOT NULL,
	PRIMARY KEY(OrderId, PartId)
)

CREATE TABLE PartsNeeded (
	JobId INT REFERENCES Jobs(JobId) NOT NULL,
	PartId INT REFERENCES Parts(PartId) NOT NULL,
	PRIMARY KEY(JobId, PartId),
	Quantity INT DEFAULT(1) CHECK(Quantity >= 0) NOT NULL,
)

--2--
INSERT INTO Clients VALUES 
('Teri',	'Ennaco',	'570-889-5187'),
('Merlyn',	'Lawler',	'201-588-7810'),
('Georgene', 'Montezuma', '925-615-5185'),
('Jettie',	'Mconnell',	'908-802-3564'),
('Lemuel',	'Latzke',	'631-748-6479'),
('Melodie',	'Knipp',	'805-690-1682'),
('Candida',	'Corbley'	,'908-275-8357')

INSERT INTO Parts(SerialNumber, [Description], Price, VendorId) VALUES
('WP8182119',	'Door Boot Seal',	117.86,	2),
('W10780048',	'Suspension Rod',	42.81,	1),
('W10841140',	'Silicone Adhesive', 	6.77,	4),
('WPY055980',	'High Temperature Adhesive',	13.94,	3)

--3--
UPDATE Jobs
SET [Status] = 'In Progress', MechanicId = 3
WHERE [Status] = 'Pending'

--4--
DELETE FROM OrderParts
WHERE OrderId = 19

DELETE FROM Orders
WHERE OrderId = 19

--5--
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic,
	j.[Status],
	j.IssueDate
FROM Mechanics m
	JOIN Jobs j ON m.MechanicId = j.MechanicId
ORDER BY m.MechanicId, j.IssueDate, j.JobId

--6--
SELECT CONCAT (c.FirstName, ' ', c.LastName) AS Client,
	DATEDIFF(DAY, j.IssueDate, '24 April 2017') AS [Days going],
	j.[Status]
FROM Clients c
	JOIN Jobs j ON j.ClientId = c.ClientId
WHERE j.[Status] != 'Finished'
ORDER BY [Days going] DESC, c.ClientId

--7--
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Mechanic,
	AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate)) AS [Average Days]
FROM Mechanics m 
	INNER JOIN Jobs j ON j.MechanicId = m.MechanicId
GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId
ORDER BY m.MechanicId

--8--
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Available]
FROM Mechanics m 
	LEFT JOIN Jobs j ON j.MechanicId = m.MechanicId
WHERE m.MechanicId NOT IN (SELECT MechanicId FROM Jobs 
						   WHERE [Status] = 'In Progress' )
GROUP BY CONCAT(m.FirstName, ' ', m.LastName), m.MechanicId
ORDER BY m.MechanicId

--9--
SELECT j.JobId,
	ISNULL(SUM(p.Price * op.Quantity), 0) AS [Total]
FROM Jobs j 
	LEFT JOIN Orders o ON o.JobId = j.JobId
	LEFT JOIN OrderParts op ON op.OrderId = o.OrderId
	LEFT JOIN Parts p ON p.PartId = op.PartId
WHERE j.[Status] = 'Finished'
GROUP BY  j.JobId
ORDER BY [Total] DESC, j.jobId

--10--
SELECT * FROM (
SELECT p.PartId,
	p.[Description],
	pn.Quantity AS [Required],
	p.StockQty AS [In stock],
	ISNULL(op.Quantity, 0) AS [Ordered]
FROM Jobs AS j
	LEFT JOIN PartsNeeded AS pn ON j.JobId = pn.JobId
	LEFT JOIN Parts AS p ON pn.PartId = p.PartId
	LEFT JOIN Orders AS o ON j.JobId = o.JobId
	LEFT JOIN OrderParts AS op ON o.OrderId = op.OrderId
WHERE j.[Status] <> 'Finished' AND (o.Delivered = 0 OR o.Delivered IS NULL)) AS temp
WHERE temp.[In stock] + temp.[Ordered] < temp.[Required]
ORDER BY temp.PartId ASC

--11--
CREATE PROC usp_PlaceOrder(@jobID INT, @partSN VARCHAR(50), @partQnty INT)
AS
BEGIN
	IF @jobID IN (SELECT JobId FROM Jobs WHERE [Status] = 'Finished')
	BEGIN;
		THROW 50011, 'This job is not active!', 1
	END

	IF @partQnty <= 0
	BEGIN;
		THROW 50012, 'Part quantity must be more than zero!', 1
	END
	
	IF @jobID NOT IN (SELECT JobId FROM Jobs WHERE JobId = @jobID)
	BEGIN;
		THROW 50013, 'Job not found!', 1
	END

	IF @partSN NOT IN (SELECT SerialNumber FROM Parts WHERE @partSN = SerialNumber)
	BEGIN;
		THROW 50014, 'Part not found!', 1
	END

	IF(SELECT COUNT(OrderId) FROM Orders WHERE JobId = @jobID AND IssueDate IS NULL) = 0
		BEGIN;
			INSERT INTO Orders VALUES(@jobID, NULL, 0)
		END
	
	DECLARE @orderId INT = (SELECT OrderId FROM Orders WHERE JobId = @jobID AND IssueDate IS NULL AND Delivered = 0)
	DECLARE @partId INT = (SELECT PartId FROM Parts WHERE SerialNumber = @partSN)

	IF (SELECT COUNT(*) FROM OrderParts WHERE @orderId = OrderId AND @partId = PartId) > 0
		BEGIN;
			UPDATE OrderParts
			SET Quantity += @partQnty
			WHERE @partId = partId AND @orderId = OrderId
		END
	ELSE
		BEGIN;
			INSERT INTO OrderParts VALUES(@orderId, @partId, @partQnty)
		END
END

--12--
CREATE FUNCTION udf_GetCost(@jobID INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
	DECLARE @cost DECIMAL(18, 2)
	
	IF @jobID NOT IN (SELECT JobId FROM Orders WHERE JobId = @jobID)
		BEGIN
			SET @cost = 0
		END
	ELSE 
		BEGIN
			SET @cost = (SELECT ISNULL(SUM(p.Price * op.Quantity), 0)
								  FROM Jobs j
								  JOIN Orders o ON o.JobId = j.JobId
								  JOIN OrderParts op ON op.OrderId = o.OrderId
								  JOIN Parts p ON p.PartId = op.PartId
						 WHERE j.JobId = @jobID 
						 GROUP BY j.JobId)
		END

	RETURN @cost
END