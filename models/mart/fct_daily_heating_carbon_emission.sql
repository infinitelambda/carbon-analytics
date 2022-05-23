{{
config(
  materialized='table'
  )
}}
WITH date_spine AS (
  {{dbt_utils.date_spine("day", "to_date('1970-01-01')", "current_date()")}}
),
date_spine_filtered as (
SELECT date_day as DATE FROM date_spine WHERE date_day >= DATE('{{var("emissions_start_date")}}')
),
heating as (
SELECT
  cl.LOCATION_ID,
  cl.LOCATION_LATITUDE,
  cl.LOCATION_LONGITUDE,
  ROUND(((d.ANNUAL_HEATING_DEMAND_BTU*cl.LOCATION_SIZE_SQ_FT/1000000)*com.TOTAL_KGCO2E/365),3)  as TOTAL_KGCO2E --this is the daily demand, assumes equal demand across the year
FROM {{ ref('stg_operational_data__company_locations') }} cl
LEFT JOIN {{ ref('stg_additional_modelling_resources__us_commercial_buildings_demand') }} d on cl.LOCATION=d.TYPE
LEFT JOIN {{ ref('stg_emissions_factors__stationary_combustion') }} com on com.FUEL_TYPE='Natural Gas' --we assume all heating is done via Natural Gas
)
SELECT
  d.DATE,
  h.LOCATION_ID,
  h.LOCATION_LATITUDE,
  h.LOCATION_LONGITUDE,
  h.TOTAL_KGCO2E
FROM date_spine_filtered d
CROSS JOIN heating h
