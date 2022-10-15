select *
from PortfolioProject1..CovidDeaths;
select *
from PortfolioProject1..CovidVactinations


Select Location, date, total_Cases, population
from PortfolioProject1..CovidDeaths

Select Location, date, total_Cases, population, (total_cases/population)*100
from PortfolioProject1..CovidDeaths

Select dea.Location, dea.date, dea.new_deaths, dea.total_cases, (dea.total_deaths/dea.population)*100 as CovidDeathRate, (vac.cardiovasc_death_rate/vac.population) as HeartDeathRate
from PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVactinations vac
on dea.location=vac.location
and dea.date=vac.date
--order by 1,2


Select dea.Location, dea.date, dea.new_deaths, dea.total_cases, (dea.total_deaths/dea.population)*100 as CovidDeathRate, (vac.cardiovasc_death_rate/vac.population) as HeartDeathRate
from PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVactinations vac
on dea.location=vac.location
and dea.date=vac.date


Select dea.Location,  vac.hospital_beds_per_thousand, max(dea.total_deaths/dea.population)*100 as CovidDeathRate
from PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVactinations vac
on dea.location=vac.location
and dea.date=vac.date
group by dea.location, vac.hospital_beds_per_thousand

--Number of beds compared to Number od Deaths

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--Nations with highest number of Total Vaccinations

select location, Max(total_vaccinations_per_hundred) as MaxVaccinated
from PortfolioProject1..CovidVactinations
group by location
order by location

--Global Figures

select sum(convert(bigint,people_fully_vaccinated)), sum(population) as GlobalPopulation,sum(convert(bigint,people_fully_vaccinated)/population) as percVacc
from PortfolioProject1..CovidVactinations

Update PortfolioProject1..CovidDeaths
SET CovidDeaths.new_cases= 0
From PortfolioProject1..CovidDeaths
Where CovidDeaths.new_cases is null

select location, date, CovidDeaths.new_cases
From PortfolioProject1..CovidDeaths
where CovidDeaths.location ='Afghanistan'


--Rolling Number of new Casses

SELECT dea.Location, dea.date, SUM(dea.new_cases) OVER (PARTITION by dea.Location, dea.Date ORDER BY dea.Location, dea.Date ) as RollingNumberofNewCasses
FROM PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVactinations vac
on dea.location=vac.location
and dea.date=vac.date


--percent of New Casses compared to New Tests

WITH RollNewCasses as
(
SELECT dea.Location, dea.date, vac.new_tests, SUM(dea.new_cases) OVER (PARTITION by dea.Location, dea.Date ORDER BY dea.Location, dea.Date ) as RollingNumberofNewCasses
FROM PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVactinations vac
on dea.location=vac.location
and dea.date=vac.date
)
select * , (RollingNumberofNewCasses/new_tests) as ee
from RollNewCasses




