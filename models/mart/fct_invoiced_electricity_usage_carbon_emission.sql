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
  SELECT MIN(PERIOD_START) FROM {{ ref('stg_operational_data__company_invoiced_electricity_usage') }}
)
AND date_day <= (
  SELECT MAX(PERIOD_END) FROM {{ ref('stg_operational_data__company_invoiced_electricity_usage') }}
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
  LEFT JOIN {{ ref('stg_operational_data__company_invoiced_electricity_usage') }} CD ON DSF.DATE >= CD.PERIOD_START AND DSF.DATE <= CD.PERIOD_END
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
),
average_daily_intensity AS (
SELECT
  to_date(FROM_DATE) AS INTENSITY_DATE,
  REGION_ID,
  REGION_SHORT_NAME AS REGION_NAME,
  AVG(KGCO2) AS HOURLY_KGCO2
FROM {{ ref('stg_emissions_factors__purchased_electricity_uk_regional_carbon_intensity') }}
GROUP BY 1,2,3
),
weighted_daily_intensity AS (
SELECT
  ADI.INTENSITY_DATE,
  ADI.REGION_NAME,
  CASE
    WHEN dayname(ADI.INTENSITY_DATE) IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri') THEN SUM(ADI.HOURLY_KGCO2*PF.WEEKDAY_FACTOR_ADJUSTED)
    WHEN dayname(ADI.INTENSITY_DATE) IN ('Sat', 'Sun') THEN SUM(ADI.HOURLY_KGCO2*PF.WEEKEND_FACTOR_ADJUSTED)
    ELSE NULL
  END AS "WEIGHTED_DAILY_KGCO2"
FROM average_daily_intensity ADI
LEFT JOIN period_factors pf on ADI.INTENSITY_DATE >= PF.PERIOD_START and ADI.INTENSITY_DATE <= PF.PERIOD_END
GROUP BY 1,2
)
SELECT
  DSF.DATE,
  CD.LOCATION_ID,
  CD.LOCATION_LATITUDE,
  CD.LOCATION_LONGITUDE,
  WDI.REGION_NAME as CARBON_INTENSITY_REGION_NAME,
  CD.LOCATION AS LOCATION_CATEGORY,
  CASE
    WHEN DSF.DAY_TYPE = 'Weekday' THEN ROUND(CD.KWH_USAGE * WDI."WEIGHTED_DAILY_KGCO2", 2)
    WHEN DSF.DAY_TYPE = 'Weekend' THEN  ROUND(CD.KWH_USAGE * WDI."WEIGHTED_DAILY_KGCO2", 2)
  END AS TOTAL_KGCO2E
FROM date_spine_filtered DSF
LEFT JOIN {{ ref('stg_operational_data__company_invoiced_electricity_usage') }} CD ON DSF.DATE >= CD.PERIOD_START AND DSF.DATE <= CD.PERIOD_END
LEFT JOIN {{ ref('stg_additional_modelling_resources__carbon_intensity_regions_mapped') }} R ON R.POST_CODE=CD.ABBREVIATED_POST_CODE
LEFT JOIN weighted_daily_intensity WDI on WDI.REGION_NAME=r.CARBON_INTENSITY_REGION AND WDI.INTENSITY_DATE = DSF.DATE
ORDER BY 2,1
