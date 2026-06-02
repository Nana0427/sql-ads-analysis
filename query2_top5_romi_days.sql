-- Query 2: Top 5 Days by Total ROMI (Google + Facebook)
-- Returns the 5 highest ROMI days in descending order

WITH DailyMetrics AS (
    SELECT
        ad_date,
        SUM(spend) AS total_spend,
        SUM(value) AS total_value
    FROM (
        SELECT ad_date, spend, value FROM public.google_ads_basic_daily
        UNION ALL
        SELECT ad_date, spend, value FROM public.facebook_ads_basic_daily
    ) AS CombinedAds
    GROUP BY ad_date
)
SELECT
    ad_date,
    (1.00 * COALESCE(total_value, 0) / NULLIF(total_spend, 0))::numeric(18,10) AS romi
FROM
    DailyMetrics
WHERE
    total_spend > 0
ORDER BY
    romi DESC
LIMIT 5;
