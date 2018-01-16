SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Annelie Coetzee
-- Create date:   17 October 2017
-- Description:   Adds new actors and maps to movieID, or updates existing connections
-- =============================================
CREATE PROCEDURE UpsertActors

	(@ActorString varchar(400) = '', @MovieID int)
AS
BEGIN
	SET NOCOUNT ON;

	--Call function to split ActorString into a table
	SELECT Split 
	INTO #SplitActors
	FROM dbo.SplitString(ISNULL(@ActorString, ''), ',')

	--If any actors were removed from the movie, delete them from Movie Cast table.
	DELETE FROM [dbo].MovieCast 
	WHERE  MovieID = @MovieID
	AND MovieCastID NOT IN (SELECT [MovieCastID] FROM [dbo].MovieCast MC
											INNER JOIN Actor A
											ON A.ActorID = MC.ActorID
											AND MC.MovieID = @MovieID
											INNER JOIN #SplitActors SA
											ON A.FullName = SA.Split)

	--We've got all the actors, now update the Actor table
	-- Do not insert an actor if he/she already exists.
	INSERT INTO [dbo].Actor
			  (FullName)
			SELECT Split
			  FROM #SplitActors SA
			 WHERE NOT EXISTS(SELECT FullName
								FROM Actor A
							   WHERE A.FullName = SA.Split)

	--Actor Table updated, let's update the MovieCast Table
	INSERT INTO [dbo].MovieCast ([ActorID], [MovieID])
		SELECT	A.ActorID,
				@MovieID
			FROM [dbo].Actor A INNER JOIN
			#SplitActors SA ON A.FullName = SA.Split
			WHERE NOT EXISTS (SELECT [ActorID], [MovieID] FROM [dbo].[MovieCast] 
								WHERE [ActorID] = A.ActorID AND [MovieID] = @MovieID)
END
GO