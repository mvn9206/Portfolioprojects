select * from CovidDeaths$ order by 3,4
select * from CovidVaccinations$ order by 3,4

--select the data that we are going to be using
select location,date,total_cases,new_cases,total_deaths,population   from CovidDeaths$
order by 1,2

---Looking at Total Cases vs Total deaths
---Shows the likelyhood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage   from CovidDeaths$
where location like '%states%'
order by 1,2


---Looking at Total Cases Vs  Population
---Shows What Percentage of Population got Covid

select location,date,population,total_cases, (total_cases/population)*100 as DeathPercentage   from CovidDeaths$
--where location like '%states%'
order by 1,2

--Looking at Countries with Highest Infection rate Compared to Population

select location,population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected   from CovidDeaths$
--where location like '%states%'
group by location,population
order by PercentPopulationInfected desc

--Showing countries with highest death count Per Population

select location,max(cast(total_deaths as int)) as TotaldeathCount from CovidDeaths$
--where location like '%states%'
where continent is not null
group by location
order by TotaldeathCount desc

--LET'S BREAK THINGS BY CONTINENT
--Showing Continents with highest death count per population

select continent,max(cast(total_deaths as int)) as TotaldeathCount from CovidDeaths$
--where location like '%states%'
where continent is null
group by location
order by TotaldeathCount desc

--GLOBAL NUMBERS'

select sum(new_cases) as total_cases,sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)* 100
as deathpercentage from CovidDeaths$
--where location like '%states%'
where continent is null
--group by date
order by 1,2

--Looking At Total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as RollingpeopleVaccinated
--(RollingpeopleVaccinated/population) * 100
from CovidDeaths$ dea join 
CovidVaccinations$ vac on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 2,3


--USE CTE
WITH POPVSVAC (continent,location,date,population,new_vaccinations,RollingpeopleVaccinated)
as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as RollingpeopleVaccinated
--(RollingpeopleVaccinated/population) * 100
from CovidDeaths$ dea join 
CovidVaccinations$ vac on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingpeopleVaccinated/population)*100 from POPVSVAC

--VIEW
CREATE VIEW PERCENTPOPULATIONVACCINATED AS
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as RollingpeopleVaccinated
--(RollingpeopleVaccinated/population) * 100
from CovidDeaths$ dea join 
CovidVaccinations$ vac on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

SELECT * FROM PERCENTPOPULATIONVACCINATED


 

