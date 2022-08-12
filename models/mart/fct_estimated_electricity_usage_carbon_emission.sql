{{
config(
  materialized='table'
  )
}}

with average_hourly_intensity AS (
SELECT
  to_date(FROM_DATE) AS INTENSITY_DATE,
  EXTRACT(HOUR FROM FROM_DATE) AS INTENSITY_HOUR,
  REGION_ID,
  REGION_SHORT_NAME AS REGION_NAME,
  AVG(KGCO2) AS HOURLY_KGCO2
FROM {{ ref('stg_emissions_factors__purchased_electricity_uk_regional_carbon_intensity') }}
GROUP BY 1,2,3,4
),
weighted_daily_intensity AS (
SELECT
  ahi.INTENSITY_DATE,
  ahi.REGION_NAME,
  huf.PREMISE_TYPE,
  SUM(ahi.HOURLY_KGCO2*huf.FACTOR) AS "WEIGHTED_DAILY_KGCO2"
FROM average_hourly_intensity ahi
LEFT JOIN {{ ref('stg_additional_modelling_resources__hourly_usage_factors') }} huf ON huf.HOUR=ahi.INTENSITY_HOUR
AND (
  CASE
    WHEN dayname(ahi.INTENSITY_DATE) IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri') THEN TRUE
    WHEN dayname(ahi.INTENSITY_DATE) IN ('Sat', 'Sun') THEN FALSE
  ELSE NULL END
) = huf.IS_WEEKDAY
GROUP BY 1,2,3
),
factored_locations as (
SELECT DISTINCT PREMISE_TYPE
FROM {{ ref('stg_additional_modelling_resources__hourly_usage_factors') }}
),
company_locations as (
  SELECT
  cd.LOCATION_SIZE_SQ_FT,
  cd.LOCATION_ID,
  cd.LOCATION,
  cd.LOCATION_LATITUDE,
  cd.LOCATION_LONGITUDE,
  cd.ABBREVIATED_POST_CODE,
  CASE
    WHEN fl.PREMISE_TYPE IS NULL THEN 'Office'
    ELSE fl.PREMISE_TYPE
  END AS PREMISE_TYPE_FOR_JOINING --when the client has location types for which we do not have factors, we just use the Office factors
  FROM {{ ref('stg_operational_data__company_locations') }} CD
  LEFT JOIN factored_locations FL on FL.PREMISE_TYPE=cd.LOCATION
)
SELECT
  ac.INTENSITY_DATE as DATE,
  cd.LOCATION_SIZE_SQ_FT,
  cd.LOCATION_ID,
  cd.LOCATION_LATITUDE,
  cd.LOCATION_LONGITUDE,
  ac.REGION_NAME as CARBON_INTENSITY_REGION_NAME,
  dem.TYPE AS LOCATION_CATEGORY,
  ROUND(cd.LOCATION_SIZE_SQ_FT*(dem.ANNUAL_KWH_DEMAND/365), 2) as ESTIMATED_KWH_USAGE,
  ROUND(cd.LOCATION_SIZE_SQ_FT*(dem.ANNUAL_KWH_DEMAND/365)*"WEIGHTED_DAILY_KGCO2",3) AS TOTAL_KGCO2E
FROM company_locations CD
LEFT JOIN {{ ref('stg_additional_modelling_resources__us_commercial_buildings_demand') }} dem ON upper(dem.TYPE)=upper(cd.PREMISE_TYPE_FOR_JOINING)
LEFT JOIN {{ ref('stg_additional_modelling_resources__carbon_intensity_regions_mapped') }} r ON r.POST_CODE=cd.ABBREVIATED_POST_CODE
LEFT JOIN weighted_daily_intensity ac on ac.REGION_NAME=r.CARBON_INTENSITY_REGION and cd.PREMISE_TYPE_FOR_JOINING = ac.PREMISE_TYPE
