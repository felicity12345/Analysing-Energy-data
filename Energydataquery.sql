SELECT *
from projectportfolio1.dbo.energydata

-- Here we order the results in ascending order

SELECT country, year 
from projectportfolio1.dbo.energydata
where country = 'United Kingdom'
order by country, year desc


-- Firstlt we calculate the total electricity generated and the total demand in the Uk

SELECT country, year,
SUM(CONVERT(DECIMAL(10, 2), electricity_generation ))  As Total_electricity_generation_TWH,
SUM(CONVERT(DECIMAL(10, 2), electricity_demand ))  As Total_electricity_demand_TWH  
from projectportfolio1.dbo.energydata
where country like '%United Kingdom%' 
GROUP BY country, year
ORDER BY country, year DESC;

--Here i query the electricity demand, and the gdp of Uk
-- We'll use these variables to build a linear regression model to forecast energy demand for future years.
SELECT  country, year,electricity_demand,electricity_generation, population, gdp
FROM projectportfolio1.dbo.energydata
where country like '%United Kingdom%'
ORDER BY year desc;

-- Here i calculate the generation, demand balance
--A positive value for the Generation_Demand_Balance indicates a surplus generation, 
--meaning that more electricity is generated than is currently being demanded or the other way round

SELECT country, year,
SUM(CONVERT(decimal(10, 2), electricity_generation )) - SUM(CONVERT(decimal(10, 2), electricity_demand )) AS Generation_Demand_Balance_TWH
from projectportfolio1.dbo.energydata
where country like '%United Kingdom%' 
GROUP BY country, year
ORDER BY country, year DESC;

-- Here we calculate how much of renewable and non-renewable comes from electricity generated and thier percentages over the years
-- The answer predicted that non-renewable electricity and thier percentage contributed the highest in elctricity generated

SELECT country, year, renewables_electricity, fossil_electricity,   
(CONVERT(float, renewables_electricity)) /NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS renewables_electricity_percentage,
(CONVERT(float, fossil_electricity)) /NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS fossil_electricity_percentage
FROM projectportfolio1.dbo.energydata
WHERE country like '%United Kingdom%' 
order by country, year desc


--Here we calculate which energy sources generate more electricity and thier total percentage for the years
--Gas continued to be the dominant fossil fuel, why wind is dominate renewable generating of electricity.

SELECT country, year,
gas_electricity, oil_electricity, coal_electricity,nuclear_electricity,
solar_electricity, wind_electricity, hydro_electricity, biofuel_electricity,
(CONVERT(float, gas_electricity)) + (CONVERT(float, nuclear_electricity)) + (CONVERT(float, coal_electricity)) + (CONVERT(float, oil_electricity))+ 
(CONVERT(float, solar_electricity)) + (CONVERT(float, wind_electricity)) + (CONVERT(float, hydro_electricity)) + (CONVERT(float, biofuel_electricity)) /
NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS Energy_electricity_percentage_TWh
FROM projectportfolio1.dbo.energydata
WHERE country like '%United Kingdom%' 
order by country, year desc


--Here we  calculate the percentage contribution of each renewable and non-renewable source to the electricity generation in the United Kingdom (UK) for each year
--Gas has the highest percentage of electricity generated in the UK

SELECT country, year,
 CONVERT(float, solar_electricity) / NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS solar_percentage,
 CONVERT(float, wind_electricity) / NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS wind_percentage,
 CONVERT(float, hydro_electricity) / NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS hydro_percentage,
 CONVERT(float, biofuel_electricity) / NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS biofuel_percentage,
 CONVERT(float, coal_electricity) / NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS coal_percentage,
 CONVERT(float, gas_electricity) / NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS gas_percentage,
 CONVERT(float, oil_electricity) / NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS oil_percentage,
 CONVERT(float, nuclear_electricity) / NULLIF(CONVERT(float, electricity_generation), 0) * 100 AS nuclear_percentage
FROM projectportfolio1.dbo.energydata
WHERE country LIKE '%United Kingdom%'
ORDER BY country, year DESC;


-- Here calculate the total renewable energy and fossil fuel consumption and their percentage used in the Uk yearly
-- This answer shows the fossil fuel percentage is high, and implies a greater reliance on fossil fuels for energy consumption.

SELECT country, year,
SUM(CONVERT(decimal(10, 2), renewables_consumption)) AS Total_renewable_energy_consumption,
SUM(CONVERT(decimal(10, 2), fossil_fuel_consumption)) AS Total_fossil_fuel_consumption,
(SUM(CONVERT(decimal(10, 2), renewables_consumption)) / NULLIF(SUM(CONVERT(decimal(10, 2), renewables_consumption)) + SUM(CONVERT(decimal(10, 2), fossil_fuel_consumption)), 0)) * 100 AS Renewable_energy_percentage,
(SUM(CONVERT(decimal(10, 2), fossil_fuel_consumption)) / NULLIF(SUM(CONVERT(decimal(10, 2), renewables_consumption)) + SUM(CONVERT(decimal(10, 2), fossil_fuel_consumption)), 0)) * 100 AS Fossil_fuel_percentage
FROM projectportfolio1.dbo.energydata
WHERE country LIKE '%United Kingdom%'
GROUP BY country, year
ORDER BY country, year DESC;

--Here we calculate the average energy consumption 
SELECT country, year, 
(AVG(CONVERT(decimal(10, 2), renewables_consumption))) AS renewables_consumption,
(AVG(CONVERT(decimal(10, 2), fossil_fuel_consumption))) AS fossil_fuel_consumption
FROM projectportfolio1.dbo.energydata
WHERE country LIKE '%United Kingdom%'
GROUP BY country, year
ORDER BY country, year desc
    


-- Here we calculate the ratio of Renewable Energy and non renewable ratio consumption to renewables_electricity
-- The result shows a low renewable consumption ratio compared to fossil fuel. 
-- This suggests a high reliance on conventional energy sources such as fossil fuels. 

SELECT country, year,
SUM(CAST(renewables_consumption AS DECIMAL(10, 2)))/ SUM(CAST(renewables_electricity AS DECIMAL(10, 2))) AS renewable_to_total_ratio,
SUM(CAST(fossil_fuel_consumption AS DECIMAL(10, 2)))/ SUM(CAST( fossil_electricity AS DECIMAL(10, 2))) AS  fossil_to_total_ratio
FROM projectportfolio1.dbo.energydata
WHERE country like '%United Kingdom%' 
GROUP BY country, year
ORDER BY country, year DESC;


-- Here we calculate the difference in fossil_fuel_consumption and renewables_consumption in the UK 2021
-- This shows that non_renewable electricity is more consumed.

SELECT SUM(CAST(renewables_consumption AS DECIMAL(10, 2))) AS Total_renewable_consumption,
SUM(CAST(fossil_fuel_consumption AS DECIMAL(10, 2))) AS Total_fossil_fuel_consumption,
SUM(CAST(fossil_fuel_consumption  AS DECIMAL(10, 2))) - SUM(CAST(renewables_consumption AS DECIMAL(10, 2)))  AS Difference
FROM projectportfolio1.dbo.energydata
WHERE country LIKE '%United Kingdom%' AND year = 2021;

--Here we look at the production of energy source and their trend
--This means Oil and gas is the primary success of energy because of the amount of oil and gas production.
-- using energy conversion factor.

SELECT country, year,
(SUM(CONVERT(float, coal_production))) AS coal_production,
(SUM(CONVERT(float, gas_production))) AS gas_production,
(SUM(CONVERT(float, oil_production))) AS oil_production
FROM projectportfolio1.dbo.energydata
WHERE country LIKE '%United Kingdom%'
GROUP BY country, year
ORDER BY country, year DESC;


--Here we calcute the percentage of the non renewable sources and the demand percentage.

SELECT country, year,
SUM(CONVERT(float, coal_production)) / NULLIF(SUM(CONVERT(float, coal_production)) + SUM(CONVERT(float, gas_production)) + SUM(CONVERT(float, oil_production)), 0) * 100 AS coal_percentage,
SUM(CONVERT(float, gas_production)) / NULLIF(SUM(CONVERT(float, coal_production)) + SUM(CONVERT(float, gas_production)) + SUM(CONVERT(float, oil_production)), 0) * 100 AS gas_percentage,
SUM(CONVERT(float, oil_production)) / NULLIF(SUM(CONVERT(float, coal_production)) + SUM(CONVERT(float, gas_production)) + SUM(CONVERT(float, oil_production)), 0) * 100 AS oil_percentage,
SUM(CONVERT(float, electricity_demand)) / NULLIF(SUM(CONVERT(float, coal_production)) + SUM(CONVERT(float, gas_production)) + SUM(CONVERT(float, oil_production)) + SUM(CONVERT(float, electricity_demand)), 0) * 100 AS electricity_demand_percentage
FROM projectportfolio1.dbo.energydata
WHERE country LIKE '%United Kingdom%'
GROUP BY country, year
ORDER BY country, year DESC;


--Here we Calculate total carbon emissions from non_renewable source of energy consumption in the uk

SELECT SUM(CAST(coal_consumption AS DECIMAL(10, 2)) * 0.94) AS Coal_carbon_emissions,
SUM(CAST(oil_consumption AS DECIMAL(10, 2)) *  2.62) AS Oil_carbon_emissions,
SUM(CAST(gas_consumption AS DECIMAL(10, 2)) *  2.03) AS Gas_carbon_emissions
 FROM projectportfolio1.dbo.energydata
WHERE country LIKE '%United Kingdom%'
 AND year = 2021;

 --Here we calculated the greenhouse gas emission and carbon intensity for non renewable source 
SELECT country, year,
SUM(CONVERT(float, greenhouse_gas_emissions)) / NULLIF(SUM(CONVERT(float, fossil_fuel_consumption)), 0) AS oil_greenhouse_gas_emissions,
SUM(CONVERT(float, carbon_intensity_elec)) / NULLIF(SUM(CONVERT(float, oil_consumption)), 0) AS oil_Carbon_intensity,
SUM(CONVERT(float, greenhouse_gas_emissions)) / NULLIF(SUM(CONVERT(float, fossil_fuel_consumption)), 0) AS gas_greenhouse_gas_emissions,
SUM(CONVERT(float, carbon_intensity_elec)) / NULLIF(SUM(CONVERT(float, gas_consumption)), 0) AS gas_Carbon_intensity,
SUM(CONVERT(float, greenhouse_gas_emissions)) / NULLIF(SUM(CONVERT(float, fossil_fuel_consumption)), 0) AS coal_greenhouse_gas_emissions,
SUM(CONVERT(float, carbon_intensity_elec)) / NULLIF(SUM(CONVERT(float, coal_consumption)), 0) AS coal_Carbon_intensity,
SUM(CONVERT(float, greenhouse_gas_emissions)) / NULLIF(SUM(CONVERT(float, fossil_fuel_consumption)), 0) AS nuclear_greenhouse_gas_emissions,
SUM(CONVERT(float, carbon_intensity_elec)) / NULLIF(SUM(CONVERT(float, nuclear_consumption)), 0) AS nuclear_Carbon_intensity
FROM projectportfolio1.dbo.energydata
WHERE country LIKE '%United Kingdom%'
GROUP BY country, year
ORDER BY country, year DESC;


-- Here we calculate for the ratio of carbon intensity of electricity consumption to greenhouse gas emissions
--  emissions intensity per carbon intensity represents the ratio of greenhouse gas emissions to the carbon intensity of electricity consumption
-- In general, a higher emissions intensity per carbon intensity ratio suggests that the carbon emissions associated with electricity consumption are relatively high compared to the carbon intensity of the energy sources used.
SELECT country, year,
    SUM(CONVERT(float, greenhouse_gas_emissions)) AS greenhouse_gas_emissions,
    SUM(CONVERT(float, carbon_intensity_elec)) AS carbon_intensity_elec,
    SUM(CONVERT(float, carbon_intensity_elec)) / NULLIF(SUM(CONVERT(float, greenhouse_gas_emissions)), 0) AS emissions_intensity_per_carbon_intensity
FROM projectportfolio1.dbo.energydata
WHERE country LIKE '%United Kingdom%'
GROUP BY country, year
ORDER BY country, year DESC;


























