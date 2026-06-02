-- BigQuery Query 4: Landing Page Conversion Analysis (2020)

WITH session_pages AS (
  SELECT
    CONCAT(
      user_pseudo_id,
      CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING)
    ) AS session_user_id,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_location') AS page_path,
    event_name
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
    AND event_name IN ('session_start', 'purchase')
)
SELECT
  page_path,
  COUNT(DISTINCT session_user_id) AS unique_sessions,
  COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN session_user_id END) AS purchases,
  ROUND(
    COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN session_user_id END) * 100.0
    / NULLIF(COUNT(DISTINCT session_user_id), 0), 2
  ) AS conversion_rate
FROM session_pages
GROUP BY page_path
ORDER BY unique_sessions DESC
