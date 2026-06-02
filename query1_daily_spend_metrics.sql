-- Query 1: Daily Spend Metrics (Google & Facebook)
-- Shows average, max and min spend metrics for each platform by date

SELECT
    gad.ad_date,
    'Google' AS media_source,
    AVG(gad.spend)::numeric(10,2) AS avg_spend,
    MAX(gad.spend)::numeric(10,2) AS max_spend,
    MIN(gad.spend)::numeric(10,2) AS min_spend
FROM
    public.google_ads_basic_daily gad
GROUP BY
    gad.ad_date

UNION ALL

SELECT
    fb.ad_date,
    'Facebook' AS media_source,
    AVG(fb.spend)::numeric(10,2) AS avg_spend,
    MAX(fb.spend)::numeric(10,2) AS max_spend,
    MIN(fb.spend)::numeric(10,2) AS min_spend
FROM
    public.facebook_ads_basic_daily fb
JOIN
    public.facebook_adset fa ON fb.adset_id = fa.adset_id
JOIN
    public.facebook_campaign fc ON fb.campaign_id = fc.campaign_id
GROUP BY
    fb.ad_date
ORDER BY
    ad_date,
    media_source;
