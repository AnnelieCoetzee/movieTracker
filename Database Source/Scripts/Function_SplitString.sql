-- =============================================
-- Author:        Annelie Coetzee
-- Create date:   19 October 2017
-- Description:   Function allows the split of actors into a table
-- Code sourced from: https://stackoverflow.com/questions/2647/how-do-i-split-a-string-so-i-can-access-item-x
-- =============================================



CREATE FUNCTION dbo.SplitString 
(
    @str NVARCHAR(MAX) = '', 
    @separator CHAR(1)
)
RETURNS TABLE
AS
RETURN (
WITH tokens(p, a, b) AS (
    SELECT 
        CAST(1 AS BIGINT), 
        cast(1 AS BIGINT), 
        CHARINDEX(@separator, @str)
    UNION ALL
    SELECT
        p + 1, 
        b + 1, 
        CHARINDEX(@separator, @str, b + 1)
    FROM tokens
    WHERE b > 0
)
SELECT
    p-1 ItemIndex,
    LTRIM(SUBSTRING(
        @str, 
        a, 
        CASE WHEN b > 0 THEN b-a ELSE LEN(@str) END) )
    AS Split
FROM tokens
);

GO