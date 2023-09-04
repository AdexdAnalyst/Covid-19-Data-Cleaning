use [Covid Project];
select * from dbo.CovidDeath order by 3,4;
select * from dbo.CovidVaccinations order by 3,4;


select location, date, total_cases, new_cases, total_deaths,
population from dbo.CovidDeath  where continent is not null order by 1,2;
 
-- Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, cast(total_deaths as decimal)/cast (total_cases as decimal) *100 as Death_Percentage
from dbo.CovidDeath where location is not null order by 1,2

select max(total_cases) as TotalCases, max(total_deaths) as TotalDeaths, max(cast(total_deaths as decimal)/cast(total_cases as decimal))--cast(max(total_deaths as decimal))/cast(max((total_cases as decimal)) *100 as Death_Percentage
from dbo.CovidDeath where location = 'NIGERIA'

select Location, max(total_cases) as TotalCases, max(total_deaths) as TotalDeaths, max(cast(total_deaths as decimal)/cast(total_cases as decimal)) as PercentageDeath--cast(max(total_deaths as decimal))/cast(max((total_cases as decimal)) *100 as Death_Percentage
from dbo.CovidDeath where continent is not null Group by location order by TotalDeaths desc


 --Countries with the Highest Infection Rate compared to Population
 select * from dbo.CovidVaccinations order by 3,4;

select location, population, Max(total_cases) as highestInfectionCount, Max(cast(total_cases as float)/cast (population as float)) * 100 as InfectedPopulationPercentage
from dbo.CovidDeath where continent is not null group by Location, population order by InfectedPopulationPercentage desc


-- Countries highest death count per population by Countries
 
select location, max(total_deaths) as TotalDeathCount
from dbo.CovidDeath where continent is not null group by location order by TotalDeathCount desc

-- Countries highest death count per population by Continent

select continent, max(total_deaths) as TotalDeathCount
from dbo.CovidDeath where continent is not null group by continent order by TotalDeathCount desc


-- Global Deaths

select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths
where continent is not null order by 1,2





-- Population Vs Vaccinations
select continent,location,date,population,new_vaccinations, 
sum(cast(new_vaccinations as float)) over (partition by location order by location, date) as RollingPeopleVaccinated
from [owid-covid-data]
where continent is not null order by 1,2,3

select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeath as dea join CovidVaccinations 
as vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null order by 2,3

with PopvsVac (Continent, Loction, Date, Population, New_vaccinations, RollingpeopleVaccinated) 
as 
(
select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date)as RollingPeopleVaccinated
from CovidDeath as dea join CovidVaccinations 
as vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null --order by 2,3
)
select *, (RollingpeopleVaccinated/Population)*100 from PopvsVac

 

create view PercentagePopulationVaccinated
as
select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date)as RollingPeopleVaccinated
from CovidDeath as dea join CovidVaccinations 
as vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null --order by 2,3

select * from PercentagePopulationVaccinated

select location, Max(population) as Populations , max(RollingPeopleVaccinated) as Vaccinated from PercentagePopulationVaccinated group by location 