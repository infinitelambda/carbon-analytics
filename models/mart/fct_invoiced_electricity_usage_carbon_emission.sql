{{
config(
  materialized='table'
  )
}}

WITH date_spine AS (
  {{dbt_utils.date_spine("day", "to_date('1970-01-01')", "current_date()")}}
),
date_spine_filtered as (
  SELECT
  DATE_DAY AS DATE,
  CASE
    WHEN dayname(date_day) IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri') THEN 'Weekday'
    WHEN dayname(date_day) IN ('Sat', 'Sun') THEN 'Weekend'
    ELSE NULL
  END AS DAY_TYPE
FROM date_spine
WHERE date_day >= (
  SELECT MIN(PERIOD_START) FROM {{ ref('stg_operational_data__company_quarterly_electricity_usage') }}
)
AND date_day <= (
  SELECT MAX(PERIOD_END) FROM {{ ref('stg_operational_data__company_quarterly_electricity_usage') }}
)
),
period_factors_preliminary as (
  SELECT
    CD.PERIOD,
    PERIOD_START,
    PERIOD_END,
    CD.LOCATION_ID,
    CD.LOCATION,
    DATEDIFF(DAY, PERIOD_START, PERIOD_END)+1 AS PERIOD_SPAN,
    SUM(CASE WHEN DAY_TYPE = 'Weekday' THEN 1 ELSE 0 END) AS WEEKDAY_COUNT,
    SUM(CASE WHEN DAY_TYPE = 'Weekend' THEN 1 ELSE 0 END) AS WEEKEND_COUNT
  FROM date_spine_filtered DSF
  LEFT JOIN {{ ref('stg_operational_data__company_quarterly_electricity_usage') }} CD ON DSF.DATE >= CD.PERIOD_START AND DSF.DATE <= CD.PERIOD_END
  GROUP BY 1,2,3,4,5,6
),
period_factors AS (
SELECT
  PERIOD,
  PERIOD_START,
  PERIOD_END,
  LOCATION_ID,
  FA.WEEKDAY_FACTOR/(WEEKDAY_COUNT*FA.WEEKDAY_FACTOR+WEEKEND_COUNT*FA.WEEKEND_FACTOR) AS WEEKDAY_FACTOR_ADJUSTED,
  FA.WEEKEND_FACTOR/(WEEKDAY_COUNT*FA.WEEKDAY_FACTOR+WEEKEND_COUNT*FA.WEEKEND_FACTOR) AS WEEKEND_FACTOR_ADJUSTED
FROM period_factors_preliminary pfp
LEFT JOIN {{ ref('stg_additional_modelling_resources__daily_usage_factors') }} FA ON FA.PREMISE_TYPE=pfp.LOCATION
)
SELECT
  DSF.DATE,
  CD.LOCATION_ID,
  CD.LOCATION_LATITUDE,
  CD.LOCATION_LONGITUDE,
  CASE
    WHEN DSF.DAY_TYPE = 'Weekday' THEN ROUND(CD.KWH_USAGE * WEEKDAY_FACTOR_ADJUSTED, 2)
    WHEN DSF.DAY_TYPE = 'Weekend' THEN  ROUND(CD.KWH_USAGE * WEEKEND_FACTOR_ADJUSTED, 2)
  END AS TOTAL_KGCO2E
FROM date_spine_filtered DSF
LEFT JOIN {{ ref('stg_operational_data__company_quarterly_electricity_usage') }} CD ON DSF.DATE >= CD.PERIOD_START AND DSF.DATE <= CD.PERIOD_END
LEFT JOIN period_factors PF ON DSF.DATE >= PF.PERIOD_START AND DSF.DATE <= PF.PERIOD_END AND CD.LOCATION_ID = PF.LOCATION_ID
ORDER BY 2,1
