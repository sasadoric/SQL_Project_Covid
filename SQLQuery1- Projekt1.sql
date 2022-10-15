select *
from PortfolioProject1..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject1..CovidVactinations
--order by 3,4

--select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject1..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths
--Show likelihood of dying if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject1..CovidDeaths
where Location like '%states%'
order by 1,2

--Looking at Total Cases vs Population
-- showing what percentage of populations got Covid
select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject1..CovidDeaths
order by 1,2

--Looking at Countries with Highest Infection Rate comparet to population

select location, population, max(Total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject1..CovidDeaths
group by location, population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population
select location, max(cast(total_deaths as INT)) as TotalDeathCount
from PortfolioProject1..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Let's Break Things Down by Continent

--Showing Continents with the highest death count per population

select continent, max(cast(total_deaths as INT)) as TotalDeathCount
from PortfolioProject1..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

--breaking Global Numbers

select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject1..CovidDeaths
--where Location like '%states%'
where continent is not null
group by date
order by 1,2;

--Looking at total population vs vactination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.Location, dea.Date) as RollingPeopleVactinated
from PortfolioProject1..CovidDeaths as dea 
join PortfolioProject1..CovidVactinations as vac
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac  (Continent, Location, Date, Population, New_Vaccinations,  RollingPeopleVaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.Location, dea.Date) as RollingPeopleVactinated
from PortfolioProject1..CovidDeaths as dea 
join PortfolioProject1..CovidVactinations as vac
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
)
select*, (RollingPeopleVaccinated/Population)*100
from PopvsVac


--Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVactinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.Location, dea.Date) as RollingPeopleVactinated
from PortfolioProject1..CovidDeaths as dea 
join PortfolioProject1..CovidVactinations as vac
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null

select*, (RollingPeopleVactinated/Population)*100 as ee
from #PercentPopulationVaccinated;

--Creating View to store data for later visualisations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.Location, dea.Date) as RollingPeopleVactinated
from PortfolioProject1..CovidDeaths as dea 
join PortfolioProject1..CovidVactinations as vac
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null;
--order by 2,3

select*from PercentPopulationVaccinated