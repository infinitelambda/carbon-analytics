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
emissions as (
SELECT
  fm.SK_FACTORY_MACHINERY,
  ROUND(mc.CONSUMPTION_VOLUME*12*sc.HEAT_CONTENT_HHV*sc.TOTAL_KGCO2E,3) as TOTAL_KGCO2E --we assume machines run for 12 hours each per day
FROM {{ ref('stg_operational_data__factory_machinery') }} fm
LEFT JOIN {{ ref('stg_additional_modelling_resources__machinery_consumption') }} mc on
mc.MACHINERY_TYPE=fm.MACHINE_TYPE and mc.SIZE=fm.SIZE_KW and mc.LOAD=0.5 --we assume machines run on 50% load
LEFT JOIN {{ ref('stg_emissions_factors__stationary_combustion') }} sc on
(CASE WHEN sc.FUEL_TYPE = 'Biodiesel (100%)' THEN 'Diesel' ELSE sc.FUEL_TYPE END) = fm.FUEL_TYPE
)
SELECT
  dsf.DATE,
  SUM(TOTAL_KGCO2E) as TOTAL_KGCO2E
FROM date_spine_filtered dsf
CROSS JOIN emissions
GROUP BY 1
