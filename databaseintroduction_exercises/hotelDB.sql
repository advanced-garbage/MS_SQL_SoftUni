CREATE TABLE Employees (
	Id INT NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Title VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY (Id)
);

INSERT INTO Employees VALUES 
(1, 'Johnny', 'Knoxville', 'Bell-boy', NULL),
(2, 'John', 'Bone', 'Janitor', NULL),
(3, 'George', 'Kologne', 'Manager', NULL)



CREATE TABLE Customers (
	AccountNumber INT NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	PhoneNumber INT NOT NULL,
	EmergencyName VARCHAR(50) NOT NULL,
	EmergencyNumber INT NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY (AccountNumber)
);

INSERT INTO Customers VALUES 
(1, 'Steph', 'Beth', 92812222, 'Cries for help', 9292912, NULL),
(2, 'Kiril', 'Beth', 86776522, 'Cries for help', 8326764, NULL),
(3, 'Ted', 'Beth', 92929299, 'Cries for help', 92123112, NULL)

CREATE TABLE RoomStatus (
	RoomStatus BIT NOT NULL,
	Notes VARCHAR(MAX),
);

INSERT INTO RoomStatus VALUES 
(0, NULL),
(1, NULL),
(1, NULL)

CREATE TABLE RoomTypes (
	RoomType VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX),
);

INSERT INTO RoomTypes VALUES 
('Two Beds', NULL),
('Two Beds', NULL),
('One bed', NULL)

CREATE TABLE BedTypes (
	BedType VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX),
);

INSERT INTO BedTypes VALUES 
('Small', NULL),
('Big', NULL),
('Big', NULL)

CREATE TABLE Rooms (
	RoomNumber SMALLINT NOT NULL,
	RoomType VARCHAR(50) NOT NULL,
	BedType VARCHAR(50) NOT NULL,
	Rate DECIMAL(18, 2) NOT NULL,
	RoomStatus BIT NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY (RoomNumber)
);

INSERT INTO Rooms VALUES 
(400, 'Two Beds', 'Small', 20.00, 0, NULL),
(401, 'One bed', 'Small', 10.00, 1, NULL),
(402, 'Two Beds', 'Big', 30.00, 0, NULL)

CREATE TABLE Payments (
	Id INT NOT NULL,
	EmployeeId INT NOT NULL,
	PaymentDate DATE NOT NULL,
	AccountNumber INT NOT NULL,
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays INT NOT NULL,
	AmountCharged DECIMAL(18, 2) NOT NULL,
	TaxRate DECIMAL(18, 2) NOT NULL,
	TaxAmount DECIMAL(18, 2) NOT NULL,
	PaymentTotal DECIMAL(18, 2) NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY(Id)
);

INSERT INTO Payments VALUES 
(1, 3, '04-12-2017', 53, '05-02-2018', '10-02-2018', 5, 499.99, 21.00, 43.00, 1000.00, NULL),
(2, 2, '06-07-2017', 54, '15-01-2018', '18-01-2018', 3, 259.99, 21.00, 43.00, 1000.00, NULL),
(3, 2, '24-11-2017', 55, '02-03-2018', '12-01-2018', 10, 559.99, 21.00, 43.00, 1000.00, NULL)
