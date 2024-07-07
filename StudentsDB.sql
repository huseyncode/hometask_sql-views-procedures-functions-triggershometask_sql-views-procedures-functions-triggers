CREATE DATABASE StudentsDB
USE StudentsDB

CREATE TABLE Groups(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL UNIQuE,
    Limit INT NOT NULL,
    BeginDate DATE NOT NULL,
    EndDate DATE NOT NULL,
);

INSERT INTO Groups (Name, Limit, BeginDate, EndDate) 
VALUES
('Backend PB401', 3, '2024-09-01', '2025-01-31'),
('Frontend PF402', 3, '2024-09-01', '2025-01-31'),
('Design PD403', 3, '2024-09-01', '2025-01-31'),
('Mobile Development PM404', 3, '2024-09-01', '2025-01-31'),
('Data Analytics DA405', 3, '2024-09-01', '2025-01-31');

CREATE TABLE Students (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    Surname NVARCHAR(50) NOT NULL,
    Email NVARCHAR(50)NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(50) NOT nULL,
    BirthDate DATE NOT NULL,
	GPA DECIMAL(5,2) NOT NULL,
	GroupId INT NOT NULL,
	FOREIGN KEY(GroupId) REFERENCES Groups(Id),

);

INSERT INTO Students (Name, Surname, Email, PhoneNumber, BirthDate, GPA, GroupId) VALUES
('Elnur', 'Hüseynov', 'elnur.huseynov@example.com', '0501234567', '2000-05-12', 3.8, 1),
('Aysel', 'Quliyeva', 'aysel.quliyeva@example.com', '0511234567', '1999-08-25', 3.6, 1),
('Rəşad', 'Əliyev', 'reshad.aliyev@example.com', '0521234567', '1998-11-30', 3.9, 1),
('Leyla', 'Əliyeva', 'leyla.aliyeva@example.com', '0531234567', '2001-03-15', 3.7, 2),
('Samir', 'Məmmədov', 'samir.mammadov@example.com', '0541234567', '1997-07-19', 3.5, 2),
('Nigar', 'Həsənova', 'nigar.hasanova@example.com', '0551234567', '1996-12-05', 3.4, 3),
('Farid', 'Qasımov', 'farid.qasimov@example.com', '0561234567', '1995-09-22', 3.8, 4),
('Günay', 'Mustafayeva', 'gunay.mustafayeva@example.com', '0571234567', '2002-04-18', 3.6, 5);

SELECT * FROM Students
SELECT * FROM Groups

--a.
CREATE TRIGGER GroupLimiter
ON Students
AFTER INSERT
AS
IF EXISTS (SELECT Count(Students.GroupId)as Students , Groups.Limit as Limit,Groups.Name
				FROM Students
				INNER JOIN Groups ON Groups.Id=Students.GroupId
				Group by Groups.Name,  Groups.Limit
				Having Groups.Limit < Count(Students.GroupId)
				)
	BEGIN
	ROLLBACK
	RAISERROR('Qrupun limiti dolub!',16,1)
END
GO
--Yoxlamag ucun insert
INSERT INTO Students (Name, Surname, Email, PhoneNumber, BirthDate, GPA, GroupId)
VALUES ('John', 'Doe', 'john.doe@example.com', '123-456-7890', '2000-05-15', 3.8, 1);
--b
Create TRIGGER AgeChecker
On Students
AFTER INSERT
AS

IF EXISTS(SELECT Students.BirthDate
				FROM Students
				WHERE DATEDIFF(day,Students.BirthDate,GETDATE())<=365.25*16
)
	BEGIN
	ROLLBACK
    RAISERROR ('Yaş 16-dan kiçik ola bilməz!', 16, 1);
END
GO
----Yoxlamag ucun insert
INSERT INTO Students (Name, Surname, Email, PhoneNumber, BirthDate, GPA, GroupId)
VALUES ('Alice', 'Smith', 'alice.smith@example.com', '123-456-7890', '2009-01-01', 3.5, 2);

--c
Create FUNCTION dbo.AvarageGpaOfGroup (@GroupId int)
RETURNS DECIMAL(5,2)
AS
BEGIN
	DECLARE @AvarageGPA DECIMAL(5,2)
	Select  @AvarageGPA=AVG(Students.GPA)
	from Students
	inner join Groups on Groups.Id=Students.GroupId
	WHERE @GroupId=Groups.Id
	GROUP BY Groups.Name
	Return @AvarageGPA;
End;
	
Select dbo.AvarageGpaOfGroup(1) AS AvarageGpaOfGroup

