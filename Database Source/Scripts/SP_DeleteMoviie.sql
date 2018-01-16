SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Annelie Coetzee
-- Create date:   19 October 2017
-- Description:   Deletes a movie from the database, and all associations
CREATE PROCEDURE DeleteMovie
	@MovieID INT
AS
BEGIN
	SET NOCOUNT ON;

	--Cleanup associations
    --Delete Cast:
	DELETE FROM [dbo].[MovieCast]
	WHERE [MovieID] = @MovieID

	--Delete all genres linked to Movie
	DELETE FROM [dbo].[MovieGenre]
	WHERE [MovieID] = @MovieID

	--Finally, delete the movie from main database
	DELETE FROM [dbo].[Movie]
	WHERE [MovieID] = @MovieID
END
GO
