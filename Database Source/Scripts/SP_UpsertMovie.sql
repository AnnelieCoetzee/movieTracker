SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Annelie Coetzee
-- Create date:   17 October 2017
-- Description:   Inserts new movie details, or updates existing.
-- =============================================
CREATE PROCEDURE Upsert_Movie
	--Movie Table
	@MovieID int= null,
	@Title varchar(400),
	@MovieYear int,
	@MovieType varchar(20),
	@Location varchar(100),
	@Director varchar(50),
	@Plot varchar(400),
	@Poster varchar(400),
	--Actor Table
	@ActorString varchar(400),
	--Genre Table
	@GenreString varchar(400)
AS
BEGIN
	SET NOCOUNT ON;

	--Check if movie doesn't already exist, if so, rather update
	SET @MovieID = (SELECT MovieID FROM
	[Movie]
	WHERE [Title] = @Title AND [MovieYear] = @MovieYear)


    -- Insert into Movie if Movie doesn't exist.
	IF(@MovieID IS NULL OR @MovieID = 0)
		BEGIN
			INSERT INTO [Movie]
				   ([Title]
				   ,[MovieYear]
				   ,[MovieType]
				   ,[Location]
				   ,[Director]
				   ,[Plot]
				   ,[Poster]
				   ,[ActorString]
				   ,[GenreString])
			 VALUES
				   (@Title
				   ,@MovieYear
				   ,@MovieType
				   ,@Location
				   ,@Director
				   ,@Plot
				   ,@Poster
				   ,@ActorString
				   ,@GenreString)
				--Set new movie ID
				SET @MovieID = SCOPE_IDENTITY();
		END
	ELSE
		BEGIN
		--Update Movie Table
			UPDATE [Movie] SET
					[Title] = COALESCE(@Title, [Title])
				   ,[MovieYear] = COALESCE(@MovieYear, [MovieYear])
				   ,[MovieType] = COALESCE(@MovieType, [MovieType])
				   ,[Location] = COALESCE(@Location, [Location])
				   ,[Director] = COALESCE(@Director, [Director])
				   ,[Plot] = COALESCE(@Plot, [Plot])
				   ,[Poster] = COALESCE(@Poster, [Poster])
				   ,[ActorString] = COALESCE(@ActorString, [ActorString])
				   ,[GenreString] = COALESCE(@GenreString, [GenreString])
				   WHERE MovieID = @MovieID
		END
	

	--Add Actors and link to movies
	DECLARE	@return_value int

		EXEC	@return_value = [UpsertActors]
				@ActorString = @ActorString,
				@MovieID = @MovieID

	--Add Genres
		EXEC	@return_value = [UpsertGenre]
				@GenreString = @GenreString,
				@MovieID = @MovieID

END
GO
