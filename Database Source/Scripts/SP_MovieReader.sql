SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Annelie Coetzee
-- Create date:   17 October 2017
-- Description:   Inserts new movie details, or updates existing.
-- =============================================
CREATE PROCEDURE Movie_Reader
	@searchString varchar(400)
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT
		--Movie Details
		M.[MovieID]
		,[Title]
		,[MovieYear]
		,[MovieType]
		,[Location]
		,[Director]
		,[Plot]
		,[Poster]
		--Actor Details
		,ActorString AS Actors
		--Genre Details
		,GenreString AS Genres
  FROM [dbo].[Movie] M
		--Get Actors
		LEFT JOIN [dbo].[MovieCast] MC
		ON M.MovieId = MC.MovieID
		LEFT JOIN [dbo].[Actor] A
		ON MC.ActorID = A.ActorID
		--Get Genres
		LEFT JOIN [dbo].[MovieGenre] MG
		ON M.MovieID = MG.MovieID
		LEFT JOIN [dbo].[Genre] G
		ON MG.GenreID = G.GenreID

	WHERE
	[Title] LIKE '%' + @searchString + '%' OR 
	CAST([MovieYear] AS VARCHAR) = @searchString OR 
	[MovieType] LIKE '%' + @searchString + '%' OR 
	[Location]  LIKE '%' + @searchString + '%' OR 
	[Director]  LIKE '%' + @searchString + '%' OR 
	[FullName]  LIKE '%' + @searchString + '%' OR 
	G.Name = @searchString

	ORDER BY [Title]

END
GO
