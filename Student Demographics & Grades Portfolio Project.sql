Create table StudentDemographic
(StudentID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
EnrollmentDate date,
HomeAddress nvarchar(255))

Insert into StudentDemographic Values
(2001, 'Jose V', 'Dalisay', 13, '2007-05-11', 'B1 L1 Macaria Homes, Bacoor, Cavite'),
(2002, 'Jamiel', 'Miana', 14, '2007-04-25', 'B3 L4 Kalayaan, Bacoor, Cavite'),
(2003, 'Darwynn', 'Soriano', 14, '2007-04-30', 'B9 L5 Macaria Homes, Bacoor, Cavite'),
(2004, 'Ashley', 'Turner', 13, '2007-05-02', 'B6 L7 Mary Homes, Bacoor, Cavite'),
(2002, 'Jamiel', 'Miana', 14, '2007-05-11', 'B5 L4 Addas Greenfields, Bacoor, Cavite'),
(2005, 'Jonas', 'Banares', 13, '2007-04-30', 'B5 L4 Addas Greenfields, Bacoor, Cavite'),
(2006, 'Razel', 'Gomez', 14, '2007-05-02', 'B7 L3 Greensite Homes, Bacoor, Cavite'),
(2006, 'Ramices', 'Bayan', NULL, '2007-04-25', 'B4 L2 Greensite Homes, Bacoor, Cavite'),
(NULL, 'Paolo', 'Bueno', 14, '2007-05-25', 'B1 L2 Citta Italia, Bacoor, Cavite'),
(2008, NULL, 'Chan', 14, NULL, 'B12 L5 Town&Country, Bacoor, Cavite')

select *
from PortfolioProject..StudentDemographic

Create table StudentGrades
(StudentID int,
English int,
Math int,
Physics int,
Chemistry int,
History int,
Filipino int,
ChristianLiving int,
Shop int,
HomeEconomics int,
PhysicalEducation int,
PassFail varchar(50))

Insert into StudentGrades values
(2001, 95, 89, 90, 89, 93, 94, 95, 91, 92, 95, 'Pass'),
(2002, NULL, 91, 91, 90, 90, 89, 91, 93, 91, 95, 'P'),
(2003, 96, 92, 88, 90, 91, 94, 92, NULL, 89, 94, 'Pass'),
(2004, 95, 90, 91, 93, 94, 90, 92, 94, 90, 91, 'P'),
(2005, 92, 90, 91, 88, 89, 89, 92, 90, 92, 92, 'Fail'),
(2006, 89, 90, 92, 93, 92, 94, 90, 91, 93, 93, 'P'),
(2007, 89, 88, 94, 93, 90, 95, 93, 90, 88, 95, 'P'),
(2008, 90, 70, 78, 70, 71, 72, 87, 78, 76, 85, 'F'),
(2009, 91, 92, 90, 91, 89, 88, 95, 87, 91, 95, 'Pass')

SELECT *
from PortfolioProject..StudentGrades


--------------------------------------------------------------------------------------------
--Remove duplicates

with RownumCTE as(
Select *, 
	ROW_NUMBER() over (partition by
	FirstName,
	LastName,
	Age
	order by StudentID) as RowNum
From PortfolioProject..StudentDemographic)
DELETE
From RownumCTE
where RowNum > 1

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Fix the student ID numbers

Update PortfolioProject..StudentDemographic
Set StudentID = 2007
where FirstName = 'Ramices'

Update PortfolioProject..StudentDemographic
Set StudentID = 2009
where LastName = 'Chan'

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Fill in the Student ID NULLS

Update PortfolioProject..StudentDemographic
Set StudentID = 2008
where FirstName = 'Paolo'

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Fill in the FirstName NULLS

Update PortfolioProject..StudentDemographic
Set FirstName = 'Jerico'
where LastName = 'Chan'

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Fill in the Age NULLS

Update PortfolioProject..StudentDemographic
Set Age = 13
where FirstName = 'Ramices'

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Fill in the EnrollmentDate NULLS
--where Chan and Bueno enrolled at the same day
--use JOIN method

Select a.FirstName, a.EnrollmentDate, b.FirstName, b.EnrollmentDate, isnull(a.EnrollmentDate, b.EnrollmentDate)
from PortfolioProject..StudentDemographic as a
join PortfolioProject..StudentDemographic as b
on a.age = b.Age --the thing which both Chan and Bueno have in common
where a.EnrollmentDate is null
and b.FirstName = 'Paolo'

Update a
set EnrollmentDate = ISNULL(a.EnrollmentDate, b.EnrollmentDate)
from PortfolioProject..StudentDemographic as a
join PortfolioProject..StudentDemographic as b
	on a.age = b.Age
	where a.EnrollmentDate is null
			and b.FirstName = 'Paolo'

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Fill in the Grade NULLS
--where Miana is 92 in English, and Soriano has the same score in Shop as Chan's score in Home Economics
--use JOIN method on Soriano's score

Update PortfolioProject..StudentGrades
set English = 92
	where StudentID = 2002

Select a.StudentID, a.Shop, b.StudentID, b.HomeEconomics, ISNULL(a.Shop, b.HomeEconomics)
from PortfolioProject..StudentGrades as a
join PortfolioProject..StudentGrades as b
	on a.PassFail = b.PassFail
	where a.Shop is null
	and b.StudentID = 2009

Update a
set a.Shop = ISNULL(a.Shop, b.HomeEconomics)
from PortfolioProject..StudentGrades as a
join PortfolioProject..StudentGrades as b
	on a.PassFail = b.PassFail
	where a.Shop is null
	and b.StudentID = 2009

--check

select *
from PortfolioProject..StudentGrades

--------------------------------------------------------------------------------------------
--Find the overall average grade of Razel Gomez

Select a.StudentID, FirstName, LastName, (English + Math + Physics + Chemistry + History + Filipino + ChristianLiving + Shop + HomeEconomics + PhysicalEducation)/10 as Average
from PortfolioProject..StudentGrades as a
JOIN PortfolioProject..StudentDemographic as b
	on a.StudentID = b.StudentID
	where FirstName = 'Razel' and LastName = 'Gomez'

--------------------------------------------------------------------------------------------
--Find the the highest grade of Jonas Banares

Select a.StudentID, FirstName, LastName,
(Select MAX(Grades) --Temp table
	From (values (English), (Math), (Physics), (Chemistry), (History), (Filipino), (ChristianLiving), (Shop), (HomeEconomics), (PhysicalEducation)) as GradesTable(Grades)) as MaxGrade
From PortfolioProject..StudentGrades as a
Join PortfolioProject..StudentDemographic as b
	on a.StudentID = b.StudentID
	where a.StudentID = 2005

--------------------------------------------------------------------------------------------
--Find the average grade on ChristianLiving for all students
Select AVG(ChristianLiving) as AvgCL
From PortfolioProject..StudentGrades

--------------------------------------------------------------------------------------------
--Find the student with the lowest grade on Physics, including the name of the student

Select a.StudentID, FirstName, LastName, Physics
From PortfolioProject..StudentDemographic as a
join PortfolioProject..StudentGrades as b
	on a.StudentID = b.StudentID
Where Physics = (Select MIN(Physics)
From PortfolioProject..StudentGrades)

--------------------------------------------------------------------------------------------
--Add Birthdate column
--where Jose Dalisay is born in April 12, 1996
--where Jamiel Miana is born in December 9, 1995
--where Darwynn Soriano is born in September 14, 1995
--where Ashley Turner is born in May 20, 1996
--where Jonas Banares is born in January 9, 1996
--where Razel Gomez is born in October 29, 1995
--where Ramices Bayan is born in November 5, 1995
--where Paolo Bueno is born in February 23, 1996
--where Jerico Chan is born in December 4, 1995

Alter table PortfolioProject..StudentDemographic
Add BirthDate date

Update PortfolioProject..StudentDemographic
set BirthDate = '1996-04-12'
where FirstName = 'Jose V' and LastName = 'Dalisay'

Update PortfolioProject..StudentDemographic
set BirthDate = '1995-12-09'
where FirstName = 'Jamiel' and LastName = 'Miana'

Update PortfolioProject..StudentDemographic
set BirthDate = '1995-09-14'
where FirstName = 'Darwynn' and LastName = 'Soriano'

Update PortfolioProject..StudentDemographic
set BirthDate = '1996-05-20'
where FirstName = 'Ashley' and LastName = 'Turner'

Update PortfolioProject..StudentDemographic
set BirthDate = '1996-01-09'
where FirstName = 'Jonas' and LastName = 'Banares'

Update PortfolioProject..StudentDemographic
set BirthDate = '1996-10-29'
where FirstName = 'Razel' and LastName = 'Gomez'

Update PortfolioProject..StudentDemographic
set BirthDate = '1995-11-05'
where FirstName = 'Ramices' and LastName = 'Bayan'

Update PortfolioProject..StudentDemographic
set BirthDate = '1996-02-23'
where FirstName = 'Paolo' and LastName = 'Bueno'

Update PortfolioProject..StudentDemographic
set BirthDate = '1995-12-04'
where FirstName = 'Jerico' and LastName = 'Chan'

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Find the age of each student during the date of enrollment

Select *, DATEDIFF(YEAR, BirthDate, EnrollmentDate) as EnrollmentAge
from PortfolioProject..StudentDemographic

Alter table PortfolioProject..StudentDemographic
add EnrollmentAge int

Update PortfolioProject..StudentDemographic
set EnrollmentAge = DATEDIFF(YEAR, BirthDate, EnrollmentDate)

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Separate the address, city, and province into different columns
--then remove the old Address column

select 
PARSENAME(Replace(HomeAddress, ',', '.'), 3) as HouseAddress,
PARSENAME(Replace(HomeAddress, ',', '.'), 2) as City,
PARSENAME(Replace(HomeAddress, ',', '.'), 1) as Province
from PortfolioProject..StudentDemographic

Alter table PortfolioProject..StudentDemographic
Add HouseAddress nvarchar(255),
City nvarchar(255),
Province nvarchar(255)

Update PortfolioProject..StudentDemographic
set HouseAddress = PARSENAME(Replace(HomeAddress, ',', '.'), 3),
City = PARSENAME(Replace(HomeAddress, ',', '.'), 2),
Province = PARSENAME(Replace(HomeAddress, ',', '.'), 1)

Alter table PortfolioProject..StudentDemographic
Drop column HomeAddress

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Remove Jose's suffix and place it in a separate column

Select 
SUBSTRING(FirstName, 1, Charindex(' ', FirstName)), 
SUBSTRING(FirstName, Charindex(' ', FirstName), LEN(FirstName))
from PortfolioProject..StudentDemographic
where FirstName = 'Jose V'

Alter table PortfolioProject..StudentDemographic
Add SuffixName varchar(50)

Update PortfolioProject..StudentDemographic
Set SuffixName = SUBSTRING(FirstName, Charindex(' ', FirstName), LEN(FirstName)) 
from PortfolioProject..StudentDemographic
where FirstName = 'Jose V'

Update PortfolioProject..StudentDemographic
Set FirstName = (Select 
SUBSTRING(FirstName, 1, Charindex(' ', FirstName)) from StudentDemographic
where FirstName = 'Jose V')
where FirstName = 'Jose V'

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Change all P and F into Pass and Fail

Select distinct(PassFail), COUNT(PassFail)
from PortfolioProject..StudentGrades
Group by PassFail

Select PassFail,
case	
	when PassFail = 'F' then 'Fail'
	when PassFail = 'P' then 'Pass'
	else PassFail
	end
From PortfolioProject..StudentGrades

Update PortfolioProject..StudentGrades
set PassFail = (case	
	when PassFail = 'F' then 'Fail'
	when PassFail = 'P' then 'Pass'
	else PassFail
	end)

--check

select *
from PortfolioProject..StudentGrades

--------------------------------------------------------------------------------------------
--Change Darwynn's enrollment date into the same date as Ashley's without manually inputting the date

update PortfolioProject..StudentDemographic
set EnrollmentDate = (select EnrollmentDate from StudentDemographic where FirstName = 'Ashley')
where FirstName = 'Darwynn'

--check

select *
from PortfolioProject..StudentDemographic

--------------------------------------------------------------------------------------------
--Rearrange the columns in the StudentDemographic table in the following order:
--StudentID
--FirstName
--SuffixName
--LastName
--Age
--BirthDate
--EnrollmentDate
--EnrollmentAge
--HouseAddress
--City
--Province

Select StudentID, FirstName, SuffixName, LastName, Age, BirthDate, EnrollmentDate, EnrollmentAge, HouseAddress, City, Province
into PortfolioProject..StudentDemographic_NEW
from PortfolioProject..StudentDemographic

--check

Select *
from PortfolioProject..StudentDemographic_NEW