select *
from ProtfoiloProject..CovidDeaths
order  by 3,4 

--select *
--from ProtfoiloProject..CovidVaccinations
--order by 3,4

select location, date , total_cases, new_cases, total_deaths, population
from ProtfoiloProject..CovidDeaths
order by 1,2

select location, date , total_cases, new_cases,(total_deaths/total_cases)*100 as DeathPercentage
from ProtfoiloProject..CovidDeaths
where location  like '%states%'
order by 1,2


select location, date , total_cases,population,(total_cases/population)*100 as  PercentPopulationInfected
from ProtfoiloProject..CovidDeaths
where location  like '%states%'
order by 1,2

select location, max(total_cases),population as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from ProtfoiloProject..CovidDeaths
group by location, population 
order by PercentPopulationInfected desc 

select location, max(cast(total_cases as int)) as TotalDeathCount
from ProtfoiloProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc 

select continent,  max(cast(total_cases as int)) as TotalDeathCount
from ProtfoiloProject..CovidDeaths
where continent is not null
group by continent 
order by TotalDeathCount desc


select  date, SUM(new_cases)  as total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from ProtfoiloProject..CovidDeaths
where continent is not null
group by date
order by 1,2

select  SUM(new_cases)  as total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from ProtfoiloProject..CovidDeaths
where continent is not null
order by 1,2

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from ProtfoiloProject..CovidDeaths dea
join ProtfoiloProject..CovidVaccinations vac
   on dea.location= vac.location
   and dea.date = vac.date 
where dea.continent is not null
order by 2,3 

with PopvsVac (Continent,location,population,date, new_vaccinations, RollingPeopleVaccinated) 
as
(
Select dea.continent, dea.location, dea.population,dea.date, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location,dea.date)  as RollingPeopleVaccinated
from ProtfoiloProject..CovidDeaths dea
join ProtfoiloProject..CovidVaccinations vac
   on dea.location= vac.location
   and dea.date = vac.date 
where dea.continent is not null
--order by 2,3
)
select*,(RollingPeopleVaccinated/population)*100
from PopvsVac


CREATE VIEW PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.population,dea.date, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location,dea.date)  as RollingPeopleVaccinated
from ProtfoiloProject..CovidDeaths dea
join ProtfoiloProject..CovidVaccinations vac
   on dea.location= vac.location
   and dea.date = vac.date 
where dea.continent is not null

select *
from PercentPopulationVaccinated