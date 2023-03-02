
Select *
From PortofolioProject..CovidDeaths
Order by 3,4

--Select *
--From PortofolioProject..CovidV
--Order by 3,4

--Looking at total cases vs total deaths
--Shows the likelihood of dying

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Looking at total cases vs poulation
-- Shows percentage of population with covid

Select location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
From PortofolioProject..CovidDeaths
--Where location like '%italy%'
Order by 1,2

--Looking at countries with the highest infection rates compared to Population

Select location, MAX(total_cases), population, MAX((total_cases/population))*100 as CasesPercentage
From PortofolioProject..CovidDeaths
--Where location like '%Italy%'
Group by location, population
Order by CasesPercentage desc

--Countries with the highest death count per population

Select location, MAX(total_deaths) as TotalDeathCount
From PortofolioProject..CovidDeaths
--Where location like '%Italy%'
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Showing the countries with the highest death count

Select continent, MAX(total_deaths) as TotalDeathCount
From PortofolioProject..CovidDeaths
--Where location like '%Italy%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Looking at total population vs vaccination

Select dea.continent, dea.location, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location)
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidV vac
    On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


Select dea.continent, dea.location, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidV vac
    On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--USE CTE
 With PopvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
 as
 (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidV vac
    On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *
From PopvsVac


With PopvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
 as
 (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidV vac
    On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


--TEMP TABLE
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric,
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidV vac
    On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric,
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidV vac
    On  dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



--Creating view to store data for late visualizations

Create View PercentPopulationVaccinatedd as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidV vac
    On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

SELECT * FROM PercentPopulationVaccinated


CREATE VIEW NewVaccinationRates AS
SELECT dea.continent, dea.location, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as VaccinationTotal
FROM PortofolioProject..CovidDeaths dea 
JOIN PortofolioProject..CovidV vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT * FROM NewVaccinationRates
