-- =============================================
-- Author:        Annelie Coetzee
-- Create date:   17 October 2017
-- Description:   Created tables for use in Movie tracker application
-- =============================================



DROP TABLE IF EXISTS Actor;
CREATE TABLE  Actor (
  ActorID int IDENTITY(1,1) NOT NULL,
  FullName varchar(100) NOT NULL,
  PRIMARY KEY (ActorID)
);

DROP TABLE IF EXISTS MovieCast;
CREATE TABLE  MovieCast (
  MovieCastID int IDENTITY(1,1) NOT NULL,
  ActorID int NOT NULL,
  MovieID int NOT NULL,
  PRIMARY KEY (MovieCastID)
);


DROP TABLE IF EXISTS Genre;
CREATE TABLE  Genre (
  GenreID int IDENTITY(1,1) NOT NULL,
  Name varchar(45) NOT NULL,
  PRIMARY KEY (GenreID)
);


DROP TABLE IF EXISTS MovieGenre;
CREATE TABLE  MovieGenre (
  MovieGenreID int IDENTITY(1,1) NOT NULL,
  MovieID int NOT NULL,
  GenreID int NOT NULL,
  PRIMARY KEY (MovieGenreID)
);

DROP TABLE IF EXISTS Movie;
CREATE TABLE  Movie (
  MovieId int IDENTITY(1,1) NOT NULL,
  Title varchar(400) NOT NULL,
  MovieYear int DEFAULT NULL,
  MovieType varchar(20) DEFAULT NULL,
  Location varchar(100) DEFAULT NULL,
  Director varchar(50) DEFAULT NULL,
  Plot varchar(400) NULL,
  Poster varchar(400) NULL,
  ActorString varchar(400) NULL,
  GenreString varchar(400) NULL,
  PRIMARY KEY (MovieId)
);