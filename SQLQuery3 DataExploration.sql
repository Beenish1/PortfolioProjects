select *
from CovidDeaths
order by 3,4

--select *
--from CovidVaccinations
--order by 3,4

--SELECT DATA THAT WE ARE GOING TO BE USING 

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in Canada
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like'%Canada%'
order by 1,2

--Looking at Total cases vs Population
--Shows what percentage of population got covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationinfected
from CovidDeaths
where location like'%Canada%'
order by 1,2

--Looking at countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
from CovidDeaths
--where location like'%Canada%'
where continent is not null
group by Location, Population
order by PercentagePopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like'%Canada%'
where continent is not null
group by Location
order by TotalDeathCount desc

--let's Break things down by continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like'%Canada%'
where continent is not null
group by continent
order by TotalDeathCount desc


--Showing Continents with the highest death count per population 

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like'%Canada%'
where continent is not null
group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

Select date, SUM(new_cases) AS TOTAL_CASES, SUM(cast(new_deaths as int))AS TOTAL_DEATHS, SUM(CAST(new_deaths AS INT))/
SUM(NEW_cases)*100 as DeathPercentage
from CovidDeaths
--where location like'%Canada%'
where continent is not null
group by date
order by 1,2

--lOOKING AT TOTAL POPULATION VS VACCINATION

SELECT DEA.CONTINENT, DEA.LOCATION, DEA.DATE, DEA.POPULATION, VAC.new_vaccinations
,SUM(CAST(VAC.NEW_VACCINATIONS AS int)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION, 
DEA.DATE) AS ROLLINGPEOPLEVACCINATED
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
	ON DEA.LOCATION = VAC.LOCATION
	AND DEA.DATE = VAC.DATE
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3

--USE CTE 

WITH POPVSVAC(CONTINENT, LOCATION, DATE, POPULATION, NEW_VACCINATIONS, ROLLINGPEOPLEVACCINATED)
AS
(
SELECT DEA.CONTINENT, DEA.LOCATION, DEA.DATE, DEA.POPULATION, VAC.NEW_VACCINATIONS,
SUM(CONVERT(INT, VAC.NEW_VACCINATIONS)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,
DEA.DATE) AS ROLLINGPEOPLEVACCINATED
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
	ON DEA.LOCATION = VAC.LOCATION
	AND DEA.DATE = VAC.DATE
WHERE DEA.continent IS NOT NULL
)
SELECT *, (ROLLINGPEOPLEVACCINATED/POPULATION)* 100
FROM POPVSVAC
	
--TEMP TABLE

drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar (255),
Location nvarchar (255),
Date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) over (Partition by dea.location order by dea.location,
dea.Date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	ON DEA.LOCATION = VAC.LOCATION
	AND DEA.DATE = VAC.DATE
--WHERE DEA.continent IS NOT NULL

SELECT *, (ROLLINGPEOPLEVACCINATED/POPULATION)* 100
FROM #PercentPopulationVaccinated


-- Creating view to store data for later visualization

create view PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated