Select *
from PortfolioProject..MoviesDataset

--------------------------------------------------------------------------------------------
--Remove the strange characters in the YEAR column

update PortfolioProject..MoviesDataset
set [YEAR] = REPLACE([YEAR], '– ', '-Present')
from PortfolioProject..MoviesDataset

update PortfolioProject..MoviesDataset
set [YEAR] = REPLACE([YEAR], '–', '-')
from PortfolioProject..MoviesDataset

update PortfolioProject..MoviesDataset
set [YEAR] = REPLACE([YEAR], '-', '')
from PortfolioProject..MoviesDataset
where [year] like '-2%' or [year] like '-1%'

SELECT
substring([YEAR], charindex(')', [YEAR]) +1, LEN([YEAR]))
from PortfolioProject..MoviesDataset
WHERE [YEAR] like '(%)%(%)'

update PortfolioProject..MoviesDataset
set [YEAR] = substring([YEAR], charindex(')', [YEAR]) +1, LEN([YEAR]))
from PortfolioProject..MoviesDataset
WHERE [YEAR] like '(%)%(%)'

Select [YEAR]
from PortfolioProject..MoviesDataset
WHERE [YEAR] not like '%(1%)%' 
	AND [YEAR] not like '%(2%)%' 
	AND [YEAR] not like '%2%'
	AND [YEAR] not like '%1%'

Update PortfolioProject..MoviesDataset
Set [YEAR] = null
WHERE [YEAR] not like '%(1%)%' 
	AND [YEAR] not like '%(2%)%' 
	AND [YEAR] not like '%2%'
	AND [YEAR] not like '%1%'

update PortfolioProject..MoviesDataset
set [YEAR] = LTRIM([YEAR])
from PortfolioProject..MoviesDataset

select [YEAR], 
SUBSTRING([YEAR], 1, CHARINDEX(' ', [YEAR]))
from PortfolioProject..MoviesDataset
WHERE [YEAR] like '(%TV%)' or [YEAR] like '(%Video%)' or [YEAR] like '(%Special%)'

update PortfolioProject..MoviesDataset
set [YEAR] = SUBSTRING([YEAR], 1, CHARINDEX(' ', [YEAR]))
from PortfolioProject..MoviesDataset
WHERE [YEAR] like '(%TV%)' or [YEAR] like '(%Video%)' or [YEAR] like '(%Special%)'

Select [YEAR],
SUBSTRING([YEAR], CHARINDEX('(', [YEAR]) +1, LEN([YEAR]))
from PortfolioProject..MoviesDataset

Update PortfolioProject..MoviesDataset
set [YEAR] = SUBSTRING([YEAR], CHARINDEX('(', [YEAR]) +1, LEN([YEAR]))
from PortfolioProject..MoviesDataset

Select [YEAR],
SUBSTRING([YEAR], 1, CHARINDEX(')', [YEAR]) -1)
from PortfolioProject..MoviesDataset
where [YEAR] like '%)'

Update PortfolioProject..MoviesDataset
set [YEAR] = SUBSTRING([YEAR], 1, CHARINDEX(')', [YEAR]) -1)
from PortfolioProject..MoviesDataset
where [YEAR] like '%)'



--------------------------------------------------------------------------------------------
--Remove the unnecessary spaces or tabs in all columns

update PortfolioProject..MoviesDataset
set GENRE = LTRIM(GENRE),
	RATING = LTRIM(RATING),
	[ONE-LINE] = LTRIM([ONE-LINE]),
	VOTES = LTRIM(VOTES),
	MOVIES = LTRIM(Movies),
	RunTime = LTRIM(RunTime),
	Gross = LTRIM(Gross)
from PortfolioProject..MoviesDataset

--DIRECTORS Column
Update PortfolioProject..MoviesDataset --This command removes all whitespaces and tabs outside the data
Set STARS = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(
			STARS, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),
			CHAR(160), CHAR(32)),CHAR(9),CHAR(32)))) 
From PortfolioProject..MoviesDataset 


--------------------------------------------------------------------------------------------
--Separate the directors and stars into individual columns

--Adding a new column named 'DIRECTORS'
Alter table PortfolioProject..MoviesDataset
Add DIRECTORS nvarchar(255)

--Looking at all rows which include both a SINGLE director and the stars in the same column
Select stars,
SUBSTRING(Stars, 1, CHARINDEX('|', STARS) -1)
from PortfolioProject..MoviesDataset
where STARS like 'Director:%|%' 

Update PortfolioProject..MoviesDataset
sET directors = SUBSTRING(Stars, 1, CHARINDEX('|', STARS) -1)
from PortfolioProject..MoviesDataset
where STARS like 'Director:%|%'

--Looking at all rows which include both MULTIPLE directors and the stars in the same column
Select stars,
SUBSTRING(Stars, 1, CHARINDEX('|', STARS) -1)
from PortfolioProject..MoviesDataset
where STARS like 'Directors:%|%'

Update PortfolioProject..MoviesDataset
sET directors = SUBSTRING(Stars, 1, CHARINDEX('|', STARS) -1)
from PortfolioProject..MoviesDataset
where STARS like 'Directors:%|%'

--Looking at all rows which include ONLY multiple directors and no stars in the same column
Select directors,
SUBSTRING(directors, CHARINDEX(': ', Directors) +2, LEN(Directors))
from PortfolioProject..MoviesDataset
where directors like 'Directors:%'

Update PortfolioProject..MoviesDataset
sET directors = SUBSTRING(directors, CHARINDEX(': ', Directors) +2, LEN(Directors))
from PortfolioProject..MoviesDataset
where directors like 'Directors:%'

--Looking at all rows which include ONLY a single director and no stars in the same column
Select STARS, Directors, ISNULL(Directors, STARS)
From PortfolioProject..MoviesDataset
where Directors is null
and STARS like 'Director%'

update PortfolioProject..MoviesDataset
set Directors = ISNULL(Directors, STARS)
From PortfolioProject..MoviesDataset
where Directors is null
and STARS like 'Director%'

--Removing the unnecessary labels in the DIRECTORS column
Select 
REPLACE(DIRECTORS, 'Director: ', '') 
From PortfolioProject..MoviesDataset

Update PortfolioProject..MoviesDataset
Set DIRECTORS = REPLACE(DIRECTORS, 'Director: ', '')
From PortfolioProject..MoviesDataset

Update PortfolioProject..MoviesDataset
Set DIRECTORS = REPLACE(DIRECTORS, 'Directors: ', '') 
From PortfolioProject..MoviesDataset

--Adding a new column named 'StarsSplit'
Alter table PortfolioProject..MoviesDataset
add StarsSplit nvarchar(255)

--Looking at all rows which include only a singular star
Select stars,
SUBSTRING(Stars, CHARINDEX('Star:', STARS) +6, LEN(Stars))
from PortfolioProject..MoviesDataset
where STARS like '%Star:%'

Update PortfolioProject..MoviesDataset
set StarsSplit = SUBSTRING(Stars, CHARINDEX('Star:', STARS) +6, LEN(Stars))
from PortfolioProject..MoviesDataset
where STARS like '%Star:%'

--Looking at all rows which include multiple stars
Select stars,
SUBSTRING(Stars, CHARINDEX('Stars:', STARS) +7, LEN(Stars))
from PortfolioProject..MoviesDataset
where STARS like '%Stars:%'

Update PortfolioProject..MoviesDataset
set StarsSplit = SUBSTRING(Stars, CHARINDEX('Stars:', STARS) +7, LEN(Stars))
from PortfolioProject..MoviesDataset
where STARS like '%Stars:%'

--Removing the unnecessary labels in the StarsSplit column
Select StarsSplit,
REPLACE(StarsSplit, 'Star: ', '') 
From PortfolioProject..MoviesDataset

Update PortfolioProject..MoviesDataset
Set StarsSplit = REPLACE(StarsSplit, 'Star: ', '') 
From MoviesDataset

Select StarsSplit,
REPLACE(StarsSplit, 'Stars: ', '') 
From PortfolioProject..MoviesDataset

Update PortfolioProject..MoviesDataset
Set StarsSplit = REPLACE(StarsSplit, 'Stars: ', '') 
From PortfolioProject..MoviesDataset

--Delete the old Stars column
Alter Table PortfolioProject..MoviesDataset
Drop column STARS


--------------------------------------------------------------------------------------------
--Change all rows with "add a plot" to "null"

select [ONE-LINE], REPLACE([one-line], 'Add a Plot', NULL)
From PortfolioProject..MoviesDataset
where [ONE-LINE] like '%add%plot%'

update PortfolioProject..MoviesDataset
set [ONE-LINE] = NULL
where [ONE-LINE] like '%add%plot%'


--------------------------------------------------------------------------------------------
--Rename Column names into better labels

sp_rename 'MoviesDataset.MOVIES', 'MovieTitle'
sp_rename 'MoviesDataset.STARS', 'Stars'
sp_rename 'MoviesDataset.YEAR', 'Year'
sp_rename 'MoviesDataset.RATING', 'Rating'
sp_rename 'MoviesDataset.ONE-LINE', 'Synopsis'
sp_rename 'MoviesDataset.VOTES', 'Votes'
sp_rename 'MoviesDataset.GENRE', 'Genres'
sp_rename 'MoviesDataset.DIRECTORS', 'Directors'


--------------------------------------------------------------------------------------------
--Find the Top 10 Movies with the highest rating

Select top 10 *
From PortfolioProject..MoviesDataset
Order by Rating DESC


--------------------------------------------------------------------------------------------
--Find the average rating for all the Avatar:TLA animated show episodes

Select MovieTitle, AVG(Rating) as AvgRating
From PortfolioProject..MoviesDataset
where MovieTitle = 'Avatar: The Last Airbender' and [YEAR] is not null
GROUP by MovieTitle


--------------------------------------------------------------------------------------------
--Find the movie with the highest number of votes

Select *
From PortfolioProject..MoviesDataset
Where Votes = (Select MAX(Votes) from MoviesDataset)