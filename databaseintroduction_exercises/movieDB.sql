CREATE TABLE Directors (
	Id INT NOT NULL,
	DirectorName VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY(Id)
);

INSERT INTO Directors VALUES 
(1, 'Takeshi Kitano', NULL),
(2, 'Shinya Tsukamoto', NULL),
(3, 'George Lucas', NULL),
(4, 'Michael Bay', NULL),
(5, 'Aleksei German', NULL)

CREATE TABLE Genres (
	Id INT NOT NULL,
	GenreName VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY(Id)
);

INSERT INTO Genres Values 
(1, 'Body Horror', NULL),
(2, 'Cosmis Horror', NULL),
(3, 'Folk Horror', NULL),
(4, 'Psychological Horror', NULL),
(5, 'Acid Western', NULL),
(6, 'Historic', NULL),
(7, 'Sci-fi', NULL)

CREATE TABLE Categories (
	Id INT NOT NULL,
	CategoryName VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX),
	PRIMARY KEY(Id)
);

INSERT INTO Categories VALUES 
(1, 'Sad', NULL),
(2, 'Depressive', NULL),
(3, 'Happy', NULL),
(4, 'Melancholic', NULL),
(5, 'Anxious', NULL)

CREATE TABLE Movies (
	Id INT NOT NULL,
	Title VARCHAR(100) NOT NULL,
	DirectorId INT NOT NULL,
	CopyrightYear DATE,
	[Length] TIME,
	Genreld VARCHAR(MAX),
	CategoryId INT NOT NULL,
	Rating INT,
	Notes VARCHAR(MAX),
	PRIMARY KEY (Id)
);

INSERT INTO Movies VALUES 
(1, 'Hard to be a God', 5, NULL, '02:58:43', 7, 4, 10, NULL),
(2, 'Tetsuo: The Iron Man', 2, NULL, '01:02:43', 1, 5, 10, NULL),
(3, 'Tokyo Fist', 2, NULL, '01:23:32', 4, 5, 10, NULL)