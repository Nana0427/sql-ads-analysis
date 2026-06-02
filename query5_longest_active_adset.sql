-- Query 5: Longest Continuously Active Adset (Google + Facebook)
-- Finds the adset with the longest uninterrupted streak of impressions/reach

WITH AdSetDailyActivity AS (
  SELECT
    ad_date::date AS ad_date,
    adset_name,
    CASE
      WHEN SUM(COALESCE(impressions, 0) + COALESCE(reach, 0)) > 0 THEN 1
      ELSE 0
    END AS is_active
  FROM (
    SELECT ad_date::date, adset_name, impressions, NULL::bigint AS reach
    FROM public.google_ads_basic_daily

    UNION ALL

    SELECT fb.ad_date::date, fa.adset_name, NULL::bigint AS impressions, fb.reach
    FROM public.facebook_ads_basic_daily fb
    JOIN public.facebook_adset fa ON fb.adset_id = fa.adset_id
  ) AS t
  GROUP BY ad_date::date, adset_name
),
ActiveDays AS (
  SELECT ad_date, adset_name
  FROM AdSetDailyActivity
  WHERE is_active = 1
),
Numbered AS (
  SELECT
    adset_name,
    ad_date,
    ROW_NUMBER() OVER (PARTITION BY adset_name ORDER BY ad_date) AS rn
  FROM ActiveDays
),
Grouped AS (
  SELECT
    adset_name,
    ad_date,
    (ad_date - (rn || ' days')::interval)::date AS grp
  FROM Numbered
)
SELECT
  adset_name,
  MIN(ad_date) AS streak_start,
  MAX(ad_date) AS streak_end,
  COUNT(*) AS streak_length
FROM Grouped
GROUP BY adset_name, grp
ORDER BY streak_length DESC
LIMIT 1;
