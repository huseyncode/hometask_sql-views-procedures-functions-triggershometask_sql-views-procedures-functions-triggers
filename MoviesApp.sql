CREATE DATABASE MoviesApp
USE MoviesApp
CREATE TABLE Directors (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL,
	Surname NVARCHAR(50) NOT NULL
);
INSERT INTO Directors
VALUES 
('Steven', 'Spielberg'),
('Christopher', 'Nolan'), 
('Quentin', 'Tarantino');
select * from Directors
CREATE TABLE Movies (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL,
	Description NVARCHAR(255) NOT NULL,
	CoverPhoto NVARCHAR(50) NOT NULL,
	DirectorId int Foreign Key References Directors(Id),
	GenreId int Foreign Key References Genres(Id),
	LanguageId int Foreign Key References Languages(Id)
);

INSERT INTO Movies VALUES 
('Inception', 'A mind-bending thriller', 'inception.jpg', 2, 1, 1),
('Django Unchained', 'A story of a freed slave', 'django.jpg', 3, 1, 1),
('Pulp Fiction', 'Intersecting stories of crime', 'pulpfiction.jpg', 3, 1, 1),
('Once Upon a Time in Hollywood', 'An actor and his stunt double', 'onceuponatime.jpg', 3, 2, 1);


CREATE TABLE Actors (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL,
    Surname NVARCHAR(50) NOT NULL
);

INSERT INTO Actors
VALUES
('Leonardo', 'DiCaprio'),
('Brad', 'Pitt'),
('Samuel', 'Jackson');

CREATE TABLE Genres (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL
);

INSERT INTO Genres (Name) VALUES 
('Action'),
('Drama'),
('Comedy');

CREATE TABLE Languages (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL
);

INSERT INTO Languages
VALUES 
('English'),
('Spanish'),
('French');


CREATE TABLE ActorMovies (
    Id INT PRIMARY KEY IDENTITY(1,1),
	MovieId int Foreign Key References Movies(Id),
	ActorId int Foreign Key References Actors(Id),
);
INSERT INTO ActorMovies (MovieId, ActorId) VALUES 
(1, 1),
(2, 1),
(4, 1), 
(2, 2),
(3, 2), 
(4, 2),
(2, 3),
(3, 3);

CREATE TABLE GenreMovies (
    Id INT PRIMARY KEY IDENTITY(1,1),
	MovieId int Foreign Key References Movies(Id),
	GenreId int Foreign Key References Genres(Id),
);
INSERT INTO GenreMovies (MovieId, GenreId) VALUES 
(1, 1),
(2, 1),
(3, 1), 
(4, 2); 

--1
CREATE PROCEDURE DirectorInfo @DirectorId int
AS
SELECT Directors.Name+' '+Directors.Surname as Director,Movies.Name as Movie,Languages.Name as Language
FROM Directors
inner join Movies on Movies.DirectorId=Directors.Id
inner join Languages on Movies.LanguageId=Languages.Id
WHERE Directors.Id = @DirectorId
GO
EXEC DirectorInfo @DirectorId=3
--2
CREATE FUNCTION LanguageCount(@LanguageId int)
Returns int
as
begin
	Declare @count Int;
	select @count=Count(*)
	From Movies
	Where LanguageId=@LanguageId
	Return @count;
END;
SELECT dbo.LanguageCount(1) AS MovieCount;
--3
CREATE PROCEDURE GenreInfo @GenreId int
AS
SELECT Genres.Name As Genre, Movies.Name As Movie, Directors.Name+' '+Directors.Surname as Director
FROM Directors
inner join Movies on Movies.DirectorId=Directors.Id
inner join Genres on Movies.GenreId=Genres.Id
WHERE Genres.Id = @GenreId
GO
EXEC GenreInfo @GenreId=1
--4
Create function MoreThan2Movie(@ActorId int)
Returns bit
as
begin
	declare @count int;
	declare @result bit;
	select @count=Count(*)
	From Movies
	inner join ActorMovies on Movies.Id=ActorMovies.MovieId
	inner join Actors on Actors.Id=ActorMovies.ActorId
	Where Actors.Id=@ActorId;
	
	if @count>2
	set @result=1;
	else
	set @result=0;

	return @result;
End;
SELECT dbo.MoreThan2Movie(3) AS MoreThan2Movies;

--5
Create trigger NewInsertDetails
on movies
after insert 
as
begin
	select Movies.Name, Directors.Name, Languages.Name
	from Movies
	inner join Directors ON Movies.DirectorId=Directors.Id
	inner join Languages ON Movies.LanguageId=Languages.Id

	End;
	Go

INSERT INTO Movies (Name, Description, CoverPhoto, DirectorId, GenreId, LanguageId)
VALUES ('Interstellar', 'A team of explorers travel through a wormhole in space.', 'interstellar.jpg', 2, 1, 1);

