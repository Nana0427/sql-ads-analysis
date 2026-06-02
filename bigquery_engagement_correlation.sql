-- BigQuery Query 5: User Engagement vs Purchase Correlation (Optional)

WITH session_data AS (
  SELECT
    CONCAT(
      user_pseudo_id,
      CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING)
    ) AS session_user_id,
    MAX(CASE WHEN (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'session_engaged') = '1' THEN 1 ELSE 0 END) AS is_engaged,
    SUM(COALESCE((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'engagement_time_msec'), 0)) AS total_engagement_time,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS has_purchase
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY session_user_id
)
SELECT
  CORR(is_engaged, has_purchase) AS engagement_vs_purchase_corr,
  CORR(total_engagement_time, has_purchase) AS engagement_time_vs_purchase_corr
FROM session_data
