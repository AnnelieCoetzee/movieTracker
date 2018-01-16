SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Annelie Coetzee
-- Create date:   19 October 2017
-- Description:   Adds new Genres and maps to movieID
-- =============================================
CREATE PROCEDURE UpsertGenre
	(@GenreString varchar(400) = '', @MovieID int)
AS
BEGIN
	SET NOCOUNT ON;

	--Call function to split GenreString into a table
	SELECT Split 
	INTO #SplitGenres
	FROM dbo.SplitString(@GenreString, ',')

	--Make sure to delete the genres that were removed in the update
	DELETE FROM [dbo].[MovieGenre]
	WHERE MovieID = @MovieID AND
	 MovieGenreID NOT IN (SELECT [MovieGenreID] FROM [dbo].[MovieGenre] MG
											INNER JOIN [dbo].[Genre] G
											ON G.GenreID = MG.[GenreID]
											AND MG.MovieID = @MovieID
											INNER JOIN #SplitGenres SG
											ON G.[Name] = SG.Split)

	--We've got all the genres, now update the Genre table
	-- Do not insert a genre if it already exists.
	INSERT INTO [dbo].[Genre]
			  (Name)
			SELECT Split
			  FROM #SplitGenres SG
			 WHERE NOT EXISTS(SELECT Name
								FROM Genre G
							   WHERE G.Name = SG.Split)


	----Actor Table updated, let's update the MovieGenre Table
	INSERT INTO [dbo].[MovieGenre] ([MovieID], [GenreID])
		SELECT	@MovieID,
				G.[GenreID]
			FROM [dbo].[Genre] G INNER JOIN 
			#SplitGenres SG ON G.Name = SG.Split
			WHERE NOT EXISTS (SELECT [MovieID], [GenreID] FROM [dbo].[MovieGenre] MG
								WHERE MG.[GenreID] = G.GenreID AND [MovieID] = @MovieID)
END
GO
