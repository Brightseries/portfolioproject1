
SELECT continent,location,date,population,total_cases,total_deaths,new_cases 
FROM covid_deaths
WHERE continent is not null
ORDER BY location,date

SELECT continent,location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS number_of_death_perc 
FROM covid_deaths
--WHERE location LIKE '%STATES%' and 
WHERE continent is not null
ORDER BY location,date




SELECT continent,location,date,population,total_deaths, (total_deaths/population)*100 AS percetagewithcovid 
FROM covid_deaths
WHERE location LIKE '%STATES%'and continent is not null
ORDER BY location,date


SELECT continent,location,date,population,total_cases, (total_cases/population)*100 AS percetagewithcovid 
FROM covid_deaths
--WHERE location LIKE '%STATES%'
WHERE continent is not null
ORDER BY location,date


SELECT continent,location,population,max(total_cases) as hightest_invection, MAX((total_cases/population))*100 AS percetagewithcovid 
FROM covid_deaths
--WHERE location LIKE '%STATES%'
WHERE continent is not null
GROUP BY location,population,continent
ORDER BY percetagewithcovid DESC
  

  
SELECT continent,location,population,max(cast(total_deaths as int)) as hightest_DEATH, MAX((total_deaths/population))*100 AS percetagediewithcovid 
FROM covid_deaths
--WHERE location LIKE '%STATES%'
WHERE continent is not null
GROUP BY location,population 
ORDER BY hightest_DEATH DESC

SELECT continent,max(cast(total_deaths as int)) as hightest_DEATH 
FROM covid_deaths
--WHERE location LIKE '%STATES%'
WHERE continent is not null
GROUP BY continent
ORDER BY hightest_DEATH DESC

SELECT date , sum(new_cases)as sumofnewcases,sum(cast(new_deaths as int)) as sumofnewdeath,
sum(cast(new_deaths as int))/ sum (new_cases)*100 as percetageofnewcasesandnewdeath
FROM covid_deaths
--WHERE location LIKE '%STATES%' 
where continent is not null
GROUP BY date
ORDER BY date


SELECT sum(new_cases)as sumofnewcases,sum(cast(new_deaths as int)) as sumofnewdeath,
sum(cast(new_deaths as int))/ sum (new_cases)*100 as percetageofnewcasesandnewdeath
FROM covid_deaths
--WHERE location LIKE '%STATES%' 
where continent is not null


SELECT*
FROM covid_deaths dea
join _covid_vacination vac
	 on dea.new_cases = vac.new_tests
	 and dea.total_cases = vac.total_tests
WHERE continent is not null
ORDER BY location
select*
from _covid_vacination 


SELECT dea.continent,dea.population,dea.date,vac.new_vaccinations,dea.location,
   SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location,dea.date) as Rolling_count
FROM covid_deaths dea
join _covid_vacination vac
	 on dea.new_cases = vac.new_tests
	 and dea.total_cases = vac.total_tests
WHERE dea.continent is not null
ORDER BY location

 --USE CTE
 
 with Popvsvac(Continet,population,date,new_vaccinations,location,Rolling_count)
 as
 (
SELECT dea.continent,dea.population,dea.date,vac.new_vaccinations,dea.location,
   SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location,dea.date) as Rolling_count
FROM covid_deaths dea
join _covid_vacination vac
	 on dea.new_cases = vac.new_tests
	 and dea.total_cases = vac.total_tests
WHERE dea.continent is not null
--ORDER BY location
)
select *
from Popvsvac


--TEMP TABLE
DROP TABLE IF EXISTS #PERCENTPOPULATIONVACCINATE
CREATE TABLE #PERCENTPOPULATIONVACCINATE
(
continent nvarchar (255),
location nvarchar (255),
population numeric,
date datetime,
new_vaccinations numeric,
Rolling_count numeric
)
INSERT INTO #PERCENTPOPULATIONVACCINATE
SELECT dea.continent,dea.population,dea.date,vac.new_vaccinations,dea.location,
   SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location,dea.date) as Rolling_count
FROM covid_deaths dea
join _covid_vacination vac
	 on dea.new_cases = vac.new_tests
	 and dea.total_cases = vac.total_tests
WHERE dea.continent is not null
--ORDER BY location

select *
from #PERCENTPOPULATIONVACCINATE

--DROP IF EXISTS highest_covid_rate
CREATE VIEW highest_covid_rate as
SELECT continent,location,population,max(total_cases) as hightest_invection, MAX((total_cases/population))*100 AS percetagewithcovid 
FROM covid_deaths
--WHERE location LIKE '%STATES%'
WHERE continent is not null
GROUP BY location,population,continent
--ORDER BY percetagewithcovid DESC