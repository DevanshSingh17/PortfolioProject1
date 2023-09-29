Select *
From portfolioproject_1..Unicorn_Companies
Order by 3,9


--taking the useful data required

Select Company,[Valuation ($B)] ,Country,[Date Joined],[Founded Year] ,ABS(YEAR([Date Joined]) - [Founded Year]) AS time_taken,Industry
From portfolioproject_1..Unicorn_Companies
ORDER BY time_taken DESC,2


-- CHECKING THE cumber of companies in every country 
SELECT COUNT(Company) AS Count_companies, Country 
from portfolioproject_1..Unicorn_Companies
GROUP BY Country
ORDER BY 1 DESC

-- Different number of Industries
SELECT Industry,COUNT(Company) 
FROM portfolioproject_1..Unicorn_Companies
GROUP BY Industry 
ORDER BY COUNT(company) DESC

--Number of countries the Industries are present 
SELECT Industry,COUNT(Country)
FROM portfolioproject_1..Unicorn_Companies
GROUP BY Industry
ORDER BY COUNT(Country) DESC



--average TIME  to become a unicorn company in India
SELECT ROUND(AVG(YEAR ([Date Joined]) - [Founded Year]),2) AS AVERAGE_AGE 
From portfolioproject_1..Unicorn_Companies 
WHERE Country = 'India'

UNION

 --finding the average time a country took to become a unicorn company 
Select Country,AVG(YEAR([Date Joined]) - [Founded Year]) AS avg_time
From portfolioproject_1..Unicorn_Companies
GROUP BY Country

 Select Industry,AVG(YEAR([Date Joined]) - [Founded Year]) AS avg_time
From portfolioproject_1..Unicorn_Companies
GROUP BY Industry


 -- Companies that took less than average time to become unicorn
SELECT TOP 10 Company,[Valuation ($B)],ABS(YEAR([Date Joined]) - [Founded Year]) AS time_taken
From portfolioproject_1..Unicorn_Companies
WHERE (YEAR ([Date Joined]) - [Founded Year]) < (SELECT ROUND(AVG(YEAR([Date Joined]) - [Founded Year]),2)
From portfolioproject_1..Unicorn_Companies)
ORDER BY time_taken ASC  
-- total 681 companies

--BOTH THE TWO CODES THE ONE ABOVE AND THE ONE BELOW REPRESENT THE SAME DATA 

 -- top  companies that became unicorns in least time in years 
SELECT  company,country, [Valuation ($B)],YEAR ([Date Joined]) AS Formed,[Founded Year] ,ABS(YEAR ( [Date Joined]) - [Founded Year]) AS Time_taken 
From portfolioproject_1..Unicorn_Companies
ORDER BY Time_taken ASC 

--TOP 10 companies with their valuation and time taken to become unicorn company  and relation between valuation and time taken
SELECT TOP 10  [Valuation ($B)],ABS(YEAR ( [Date Joined]) - [Founded Year]) as Time_taken 
From portfolioproject_1..Unicorn_Companies
ORDER BY [Valuation ($B)] DESC


--CHECKING THE RESPECTIVE COMPANIES PORTFOLIO AND FINANICAL STAGE
SELECT Company,[Financial Stage], [Portfolio Exits]
From portfolioproject_1..Unicorn_Companies
WHERE [Financial Stage]!='None'
ORDER BY [Portfolio Exits] DESC

-- companies in silicon valley of india: bengaluru
SELECT Company,Country,City, [Valuation ($B)], Industry 
FROM portfolioproject_1..Unicorn_Companies
WHERE city = 'Bengaluru' 
ORDER BY [Valuation ($B)] DESC

