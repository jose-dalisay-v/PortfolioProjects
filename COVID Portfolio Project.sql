Select *
From PortfolioProject..CovidDeaths
Order by 3, 4

Select *
From PortfolioProject..CovidVaccinations
Order by 3, 4

--Select the data to be used

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1, 2


--DATA BY COUNTRY

--Looking at countries with the highest infection rate compared to the population

Select location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/population) * 100 as CasesPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location, population
Order by 4 desc

--Looking at countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
Order by 2 desc

--Looking at Total Cases v. Total Deaths in the Philippines
--Shows the likelihood of death upon contracting Covid in the Philippines

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathsPercentage
From PortfolioProject..CovidDeaths
Where location = 'Philippines'
Order by 1, 2

--Looking at Total Cases v. Population in the Philippines
--Shows the likelihood of contracting Covid in the Philippines

Select location, date, population, total_cases, (total_cases/population) * 100 as CasesPercentage
From PortfolioProject..CovidDeaths
Where location = 'Philippines'
Order by 1, 2


--DATA BY CONTINENT

--Looking at continents with the highest infection rate compared to the population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as CasesPercentage
From PortfolioProject..CovidDeaths
where continent is null
and location != 'World'
and location != 'European Union'
and location != 'International'
Group by location, population
Order by 4 desc

--Looking at continents with highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location != 'World'
Group by location
Order by 2 desc

--Looking at Total Cases v. Total Deaths in Asia
--Shows the likelihood of death upon contracting Covid in Asia

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathsPercentage
From PortfolioProject..CovidDeaths
Where location = 'Asia'
Order by 1, 2

--Looking at Total Cases v. Population in Asia
--Shows the likelihood of contracting Covid in Asia

Select location, date, population, total_cases, (total_cases/population) * 100 as CasesPercentage
From PortfolioProject..CovidDeaths
Where location = 'Asia'
Order by 1, 2


--GLOBAL NUMBERS

--Looking at the total global number of cases and deaths from 2020-2021

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathsPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Order by 1, 2

--Looking at Total Population v. Vaccinations

--Via CTE
With PopvsVac as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.date) as RollingVaccinations
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingVaccinations/population)*100 as RollingVaccinationsPercentage
From PopvsVac

--Via Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinations numeric)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.date) as RollingVaccinations
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingVaccinations/population)*100 as RollingVaccinationsPercentage
From #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentageVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.date) as RollingVaccinations
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Create View Countries_HighestCasePercentage as
Select location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/population) * 100 as CasesPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location, population

Create View HighestCaseCount_PerCountry as
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location

Create View HighestDeathCount_PerCountry as
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location

Create View DeathsPercentage_Philippines as
Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathsPercentage
From PortfolioProject..CovidDeaths
Where location = 'Philippines'

Create View CasePercentage_Philippines as
Select location, date, population, total_cases, (total_cases/population) * 100 as CasesPercentage
From PortfolioProject..CovidDeaths
Where location = 'Philippines'

Create View TotalCaseCount_PerContinent as
Select location, population, max(total_cases) as TotalInfectionCount, max(new_cases)/population * 100 as CasesPercentage
From PortfolioProject..CovidDeaths
where continent is null
and location != 'World'
and location != 'European Union'
and location != 'International'
Group by location, population

Create View TotalDeathsCount_PerContinent as
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location != 'World'
and location != 'European Union'
and location != 'International'
Group by location

Create View DeathsPercentage_Asia as
Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathsPercentage
From PortfolioProject..CovidDeaths
Where location = 'Asia'

Create View CasePercentage_Asia as
Select location, date, population, total_cases, (total_cases/population) * 100 as CasesPercentage
From PortfolioProject..CovidDeaths
Where location = 'Asia'

Create View GlobalNumbers as
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathsPercentage
From PortfolioProject..CovidDeaths
where continent is not null