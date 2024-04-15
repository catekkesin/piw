-- Step 1: Calculate the median daily vaccinations for each country
CREATE TEMPORARY TABLE MedianValues AS
SELECT 
    country, 
    AVG(daily_vaccinations) AS median_daily_vaccinations
FROM 
    country_vaccination_stats
WHERE 
    daily_vaccinations IS NOT NULL
GROUP BY 
    country;

-- Step 2: Update the missing daily vaccination numbers with the calculated median values
UPDATE country_vaccination_stats
SET daily_vaccinations = (
    SELECT mv.median_daily_vaccinations
    FROM MedianValues AS mv
    WHERE country_vaccination_stats.country = mv.country
)
WHERE daily_vaccinations IS NULL;


-- Step 3: Insert records for countries with missing data and fill their daily vaccinations with the calculated median value
INSERT INTO country_vaccination_stats (country, date, daily_vaccinations, vaccines)
SELECT
    mv.country,
    NULL AS date,
    mv.median_daily_vaccinations AS daily_vaccinations,
    NULL AS vaccines
FROM 
    MedianValues AS mv
LEFT JOIN 
    country_vaccination_stats AS cvs ON mv.country = cvs.country
WHERE 
    cvs.country IS NULL;

-- Step 4
UPDATE country_vaccination_stats
SET daily_vaccinations = 0
WHERE daily_vaccinations IS NULL;