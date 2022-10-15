Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by Location 



select location, population, max(people_vaccinated) as MaxVacc, max(people_vaccinated/population) as PercentPopulationVaccinated
From PortfolioProject1..CovidVactinations
--Where location like '%states%'
Group by Location, Population
order by location 

select location, max(Cast(total_deaths as int)) as MaxDeaths, max(total_deaths/population) as PercentPopulationDied
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
Group by Location
order by location 

select continent, population, max(total_tests) as MaxTests, max(total_tests/population) as PercentPopulationtested
From PortfolioProject1..CovidVactinations
--Where location like '%states%'
Where continent is not null 
Group by continent, Population
order by continent 

