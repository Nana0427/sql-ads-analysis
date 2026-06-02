-- Query 3: Top Weekly Campaign by Value (Google + Facebook)
-- Finds the campaign with highest total value in a single week

WITH WeeklyCampaignValue AS (
    SELECT
        DATE_TRUNC('week', ad_date)::date AS week_start,
        campaign_name,
        SUM(value) AS weekly_value
    FROM (
        SELECT ad_date, campaign_name, value 
        FROM public.google_ads_basic_daily 

        UNION ALL

        SELECT 
            fb.ad_date,
            fc.campaign_name,
            fb.value
        FROM public.facebook_ads_basic_daily fb
        JOIN public.facebook_campaign fc 
            ON fb.campaign_id = fc.campaign_id
    ) AS CombinedAds
    GROUP BY week_start, campaign_name
)
SELECT
    week_start,
    campaign_name,
    weekly_value::numeric(12,2) AS weekly_value
FROM
    WeeklyCampaignValue
ORDER BY
    weekly_value DESC
LIMIT 1;
