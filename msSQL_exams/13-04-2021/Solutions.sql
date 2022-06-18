-- DB exam 13-04-2021

--1--
CREATE TABLE Users (
	Id INT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(30) NOT NULL,
	Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors (
	RepositoryId INT REFERENCES Repositories(Id) NOT NULL,
	ContributorId INT REFERENCES Users(Id) NOT NULL
	PRIMARY KEY(RepositoryId, ContributorId)
)

CREATE TABLE Issues (
	Id INT PRIMARY KEY IDENTITY,
	Title VARCHAR(255) NOT NULL,
	IssueStatus VARCHAR(6) NOT NULL,
	RepositoryId INT REFERENCES Repositories(Id) NOT NULL,
	AssigneeId INT REFERENCES Users(Id) NOT NULL
)

CREATE TABLE Commits (
	Id INT PRIMARY KEY IDENTITY,
	[Message] VARCHAR(255) NOT NULL,
	IssueId INT REFERENCES Issues(Id),
	RepositoryId INT REFERENCES Repositories(Id) NOT NULL,
	ContributorId INT REFERENCES Users(Id) NOT NULL
)

CREATE TABLE Files (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	Size DECIMAL(18, 2) NOT NULL,
	ParentId INT REFERENCES Files(Id),
	CommitId INT REFERENCES Commits(Id) NOT NULL
)

--2--
INSERT INTO Files VALUES 
('Trade.idk',	2598.0,	1,	1),
('menu.net',	9238.31,	2,	2),
('Administrate.soshy',	1246.93, 3,	3),
('Controller.php',	7353.15,	4,	4),
('Find.java',	9957.86,	5,	5),
('Controller.json',	14034.87,	3,	6),
('Operate.xix',	7662.92,	7,	7)

INSERT INTO Issues VALUES 
('Critical Problem with HomeController.cs file',	'open',	1,	4),
('Typo fix in Judge.html',	'open',	4,	3),
('Implement documentation for UsersService.cs',	'closed',	8,	2),
('Unreachable code in Index.cs',	'open',	9, 8)

--3--
UPDATE Issues 
SET IssueStatus = 'closed'
WHERE AssigneeId = 6

--4--
DELETE FROM RepositoriesContributors
WHERE RepositoryId = (SELECT Id FROM Repositories
WHERE [Name] = 'Softuni-Teamwork')

DELETE FROM Issues
WHERE RepositoryId = (SELECT Id FROM Repositories
WHERE [Name] = 'Softuni-Teamwork')

--5--
SELECT Id, [Message], RepositoryId, ContributorId
FROM Commits
ORDER BY Id, [Message], RepositoryId, ContributorId

--6--
Select Id, [Name], Size 
FROM Files
WHERE Size > 1000 AND [Name] LIKE '%html%'
ORDER BY Size DESC, Id ASC, [Name] ASC

--7--
SELECT i.Id, 
	CONCAT(u.Username,' : ',i.Title) AS IssueAssignee
FROM Issues i
	JOIN Users u ON u.Id = i.AssigneeId 
ORDER BY i.Id DESC, i.AssigneeId ASC

--8--
SELECT f.Id,
	f.[Name],
	CONCAT(f.Size, 'KB') AS [Size]
FROM Files f
WHERE f.Id NOT IN (SELECT ParentId FROM Files WHERE ParentId IS NOT NULL )
ORDER BY f.Id ASC, f.[Name] ASC, f.Size DESC

--9--
SELECT TOP 5 r.Id,
	r.[Name], 
	COUNT(c.Id) AS [Commits]
FROM [Repositories] r
	JOIN Commits c ON r.Id = c.RepositoryId
	JOIN RepositoriesContributors rp ON rp.RepositoryId = r.Id
GROUP BY r.Id, r.[Name]
ORDER BY [Commits] DESC, r.Id ASC, r.[Name] ASC

--10--
SELECT u.Username,
	AVG(f.Size) AS [Size]
FROM Users u 
	JOIN Commits c ON c.ContributorId = u.Id
	JOIN RepositoriesContributors rp ON rp.ContributorId = u.Id
	JOIN Files f ON f.CommitId = c.Id
GROUP BY u.Username
ORDER BY [Size] DESC, u.Username ASC

--11--
CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(*)
			FROM Commits c
			JOIN Users u ON c.ContributorId = u.Id
			WHERE u.Username = @username)
END

--12--
CREATE OR ALTER PROC usp_SearchForFiles(@fileExtension VARCHAR(MAX))
AS
BEGIN
	SELECT f.Id, f.[Name], CONCAT(f.Size, 'KB') AS [Size]
	FROM Files f
	WHERE CHARINDEX(CONCAT('.', @fileExtension), f.[Name]) <> 0
	ORDER BY f.Id ASC, f.[Name] ASC, f.Size DESC
END
