-- Query 4: Campaign with Biggest Monthly Reach Growth
-- Finds the campaign with the largest absolute reach increase month over month

WITH MonthlyReach AS (
    SELECT
        TO_CHAR(ad_date, 'YYYY-MM') AS ad_month, 
        campaign_name,
        SUM(
            CASE
                WHEN T.platform = 'Facebook' THEN T.reach
                ELSE T.impressions
            END
        ) AS monthly_reach
    FROM (
        SELECT 
            fb.ad_date, 
            fc.campaign_name, 
            fb.reach, 
            NULL::bigint AS impressions, 
            'Facebook' AS platform
        FROM public.facebook_ads_basic_daily fb
        JOIN public.facebook_campaign fc 
            ON fb.campaign_id = fc.campaign_id

        UNION ALL

        SELECT 
            gad.ad_date, 
            gad.campaign_name, 
            NULL::bigint AS reach, 
            gad.impressions, 
            'Google' AS platform
        FROM public.google_ads_basic_daily gad
    ) AS T
    GROUP BY ad_month, campaign_name
),
MonthlyReachChange AS (
    SELECT
        ad_month,
        campaign_name,
        monthly_reach,
        LAG(monthly_reach, 1, 0) OVER (PARTITION BY campaign_name ORDER BY ad_month) AS previous_month_reach
    FROM MonthlyReach
)
SELECT
    ad_month,
    campaign_name,
    monthly_reach,
    (monthly_reach - previous_month_reach)::numeric AS monthly_growth
FROM
    MonthlyReachChange
WHERE
    previous_month_reach > 0
ORDER BY
    monthly_growth DESC
LIMIT 1;
