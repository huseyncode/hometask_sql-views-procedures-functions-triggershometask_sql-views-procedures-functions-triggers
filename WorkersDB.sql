CREATE DATABASE WorkerDB
USE WorkerDB

CREATE TABLE Departments(
Id INT PRIMARY KEY IDENTITY,
 Name NVARCHAR(50) NOT NULL UNIQUE,
 )

 CREATE TABLE Positions(
	 Id INT PRIMARY KEY IDENTITY,
	 Name NVARCHAR(50) NOT NULL UNIQUE,
	 Limit int not null,
	 DepartmentId INT,
	 FOREIGN KEY(DepartmentId) REFERENCES Departments(Id)
 )

 CREATE TABLE Workers (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    Surname NVARCHAR(50) NOT NULL,
    PhoneNumber NVARCHAR(50) NOT nULL UNIQUE,
	Salary DECIMAL(10,2) NOT NULL,
    BirthDate DATE NOT NULL CHECK(BirthDate <= DATEADD(YEAR, -18, GETDATE())),
	PositionId INT,
	FOREIGN KEY(PositionId) REFERENCES Positions(Id)
);

--Inserts
INSERT INTO Departments
VALUES
('Human Resources'),
('Finance'),
('Engineering'),
('Marketing');

INSERT INTO Positions 
VALUES
('HR Manager', 2, 1),  
('HR Assistant', 5, 1), 
('Accountant', 3, 2),
('Financial Analyst', 4, 2), 
('Software Engineer', 10, 3), 
('DevOps Engineer', 5, 3), 
('Marketing Manager', 2, 4), 
('Content Creator', 6, 4); 

INSERT INTO Workers 
VALUES
('John', 'Doe', '555-123-4567', 50000.00, '1985-04-12', 1), 
('Jane', 'Smith', '555-234-5678', 45000.00, '1990-05-24', 2), 
('Michael', 'Brown', '555-345-6789', 55000.00, '1982-06-30', 3),  
('Emily', 'Davis', '555-456-7890', 53000.00, '1992-07-15', 4), 
('Chris', 'Wilson', '555-567-8901', 70000.00, '1988-08-25', 5), 
('Sarah', 'Johnson', '555-678-9012', 72000.00, '1991-09-05', 6), 
('Matthew', 'Lee', '555-789-0123', 48000.00, '1987-10-10', 7), 
('Laura', 'White', '555-890-1234', 45000.00, '1993-11-20', 8);  

--a
CREATE FUNCTION dbo.AvarageSalary (@DepartmentId int)
Returns DECIMAL(10,2)
AS 
BEGIN
	DECLARE @AvarageSalary decimal(10,2)
	Select @AvarageSalary=AVG(Workers.Salary)
	From Workers
	INNER JOIN Positions ON Positions.Id=Workers.PositionId
	INNER JOIN Departments ON Departments.Id=Positions.DepartmentId
	Where @DepartmentId=Departments.Id
	Return @AvarageSalary;
END;

SELECT dbo.AvarageSalary(1) AS AvarageSalary
--b
--18 yas?na bir gin qalm?s s?xsin inserti
INSERT INTO Workers (Name, Surname, PhoneNumber, Salary, BirthDate, PositionId) VALUES
('Eva', 'Clark', '555-789-1234', 40000.00, DATEADD(YEAR, -18, GETDATE() + 1), 2);

--c
Create Trigger PositionLimiter
ON Workers
AFTER INSERT
AS
BEGIN
IF EXISTS(SELECT Positions.Name,COUNT(Workers.Id) As WorkerCount,Positions.Limit
			FROM Workers
			INNER JOIN Positions ON Positions.Id=Workers.PositionId
			Group By Positions.Name,Positions.Limit
			Having COUNT(Workers.Id)>Positions.Limit
			)
			BEGIN
			ROLLBACK
			RAISERROR ('Positionsun limiti dolub!',16,1);
			END
END;
--Yoxlama üçün insert
INSERT INTO Workers (Name, Surname, PhoneNumber, Salary, BirthDate, PositionId)
VALUES ('Peter', 'Parker', '555-789-3456', 47000.00, '1985-01-15', 1),
       ('Bruce', 'Wayne', '555-890-4567', 48000.00, '1980-02-20', 1);
	   delete from Workers Where Id>10
	   select*from Workers
	   select*from Positions
