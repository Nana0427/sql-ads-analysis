# SQL Ads Analysis & GA4 Conversion Funnel

## 📊 Project Overview
Analysis of online ad campaign performance (Google & Facebook) and GA4 e-commerce conversion funnel using PostgreSQL and BigQuery.

## 🛠️ Tools Used
- **PostgreSQL / DBeaver** — Online ad campaign analysis
- **BigQuery** — GA4 e-commerce funnel analysis

## 📁 SQL Queries

### Part 1 — Online Ad Campaign Analysis (PostgreSQL)
| File | Description |
|------|-------------|
| `query1_daily_spend_metrics.sql` | Average, max and min spend metrics for Google & Facebook by date |
| `query2_top5_romi_days.sql` | Top 5 days by total ROMI across both platforms |
| `query3_top_weekly_campaign.sql` | Campaign with highest total value in a single week |
| `query4_monthly_reach_growth.sql` | Campaign with biggest monthly reach growth |
| `query5_longest_active_adset.sql` | Adset with longest uninterrupted active streak |

### Part 2 — GA4 Conversion Funnel Analysis (BigQuery)
| File | Description |
|------|-------------|
| `bigquery_ga4_events.sql` | Extracts 2021 funnel events with device and traffic data |
| `bigquery_conversion_by_channel.sql` | Conversion rates by traffic channel and date |
| `bigquery_landing_page_conversion.sql` | Landing page conversion analysis for 2020 |
| `bigquery_engagement_correlation.sql` | User engagement vs purchase correlation (optional) |

## 📈 Key Findings
- Facebook and Google have significantly different spend distributions
- ROMI varies greatly by day — top days show 10x+ returns
- Landing page has major impact on purchase conversion rate
- Engaged users are significantly more likely to purchase
