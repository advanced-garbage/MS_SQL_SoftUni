CREATE TABLE Categories (
	Id INT NOT NULL,
	Category VARCHAR(50) NOT NULL,
	DailyRate DECIMAL(10, 2),
	WeeklyRate DECIMAL(10, 2),
	MonthlyRate DECIMAL(10, 2),
	WeekendRate DECIMAL(10, 2),
	PRIMARY KEY(Id)
);

CREATE TABLE Cars (
	Id INT NOT NULL,
	PlateNumber VARCHAR(10) NOT NULL,
	Manufacturer VARCHAR(50) NOT NULL,
	Model VARCHAR(50) NOT NULL,
	CarYear DATE,
	CategoryId INT NOT NULL,
	Doors INT,
	Pictures INT,
	Condition BIT,
	Available BIT NOT NULL,
	PRIMARY KEY(Id)

);

CREATE TABLE Employees (
	Id INT NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Title VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY(Id)
);

CREATE TABLE Customers (
	Id INT NOT NULL,
	DriverLicenceNumber VARCHAR(10) NOT NULL,
	FullName VARCHAR(100) NOT NULL,
	[Address] VARCHAR(100) NOT NULL,
	City VARCHAR(50) NOT NULL,
	ZIPcode INT NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY(Id)
);

-- (Id, EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage,
-- StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes)

CREATE TABLE RentalOrders (
	Id INT NOT NULL,
	EmployeeId INT NOT NULL,
	CustomerId INT NOT NULL,
	CarId INT NOT NULL,
	TankLevel INT NOT NULL,
	KilometrageStart DECIMAL(18, 2) NOT NULL,
	KilometrageEnd DECIMAL(18, 2) NOT NULL,
	TotalKilometrage DECIMAL(18, 2) NOT NULL,
	StartDate DATE,
	EndDate DATE,
	TotalDays INT,
	RateApplied DECIMAL(10, 2) NOT NULL,
	TaxRate DECIMAL(10, 2) NOT NULL,
	OrderStatus BIT NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY(Id, EmployeeId, CustomerId, CarId)
);