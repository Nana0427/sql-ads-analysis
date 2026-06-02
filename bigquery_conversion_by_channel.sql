-- BigQuery Query 3: Conversion Rates by Traffic Channel and Date

WITH events AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS event_date,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign,
    event_name,
    CONCAT(
      user_pseudo_id,
      CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING)
    ) AS session_user_id
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    event_name IN ('session_start','view_item','add_to_cart','begin_checkout','add_shipping_info','add_payment_info','purchase')
)
SELECT
  event_date,
  source,
  medium,
  campaign,
  COUNT(DISTINCT CASE WHEN event_name = 'session_start' THEN session_user_id END) AS user_sessions_count,
  COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart' THEN session_user_id END) AS visit_to_cart,
  COUNT(DISTINCT CASE WHEN event_name = 'begin_checkout' THEN session_user_id END) AS visit_to_checkout,
  COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN session_user_id END) AS visit_to_purchase
FROM events
GROUP BY event_date, source, medium, campaign
ORDER BY event_date
