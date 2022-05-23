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
  SUM(ahi.HOURLY_KGCO2*huf.FACTOR) AS "WEIGHTED_DAILY_KGCO2"
FROM average_hourly_intensity ahi
LEFT JOIN {{ ref('stg_additional_modelling_resources__hourly_usage_factors') }} huf ON huf.HOUR=ahi.INTENSITY_HOUR
GROUP BY 1,2
)
SELECT
  ac.INTENSITY_DATE as DATE,
  cd.LOCATION_SIZE_SQ_FT,
  cd.LOCATION_ID,
  cd.LOCATION_LATITUDE,
  cd.LOCATION_LONGITUDE,
  ac.REGION_NAME as CARBON_INTENSITY_REGION_NAME,
  dem.TYPE AS LOCATION_CATEGORY,
  ROUND(cd.LOCATION_SIZE_SQ_FT*(dem.ANNUAL_KWH_DEMAND/365)*"WEIGHTED_DAILY_KGCO2",3) AS TOTAL_KGCO2E
FROM {{ ref('stg_operational_data__company_locations') }} CD
LEFT JOIN {{ ref('stg_additional_modelling_resources__us_commercial_buildings_demand') }} dem ON upper(dem.TYPE)=upper(cd.location)
LEFT JOIN {{ ref('stg_additional_modelling_resources__carbon_intensity_regions_mapped') }} r ON r.POST_CODE=cd.ABBREVIATED_POST_CODE
LEFT JOIN weighted_daily_intensity ac on ac.REGION_NAME=r.CARBON_INTENSITY_REGION
