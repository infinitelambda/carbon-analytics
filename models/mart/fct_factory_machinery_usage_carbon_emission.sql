{{
config(
  materialized='table'
  )
}}


with machinery_usage as (
SELECT
    DATE,
    FUEL_TYPE,
    {{ volume_converter('litre', 'gallon', 'FUEL_VOLUME_USED')}} as FUEL_VOLUME_USED_GALLONS
FROM {{ ref('stg_operational_data__factory_machinery_usage') }}
),
emissions as (
SELECT
    FUEL_TYPE,
    HEAT_CONTENT_HHV,
    HEAT_CONTENT_UNIT,
    TOTAL_KGCO2E
FROM {{ ref('stg_emissions_factors__stationary_combustion') }}
)
SELECT
    mu.DATE,
    ROUND(SUM(mu.FUEL_VOLUME_USED_GALLONS*e.HEAT_CONTENT_HHV*TOTAL_KGCO2E),3) as TOTAL_KGCO2E
FROM machinery_usage mu
LEFT JOIN emissions e on (CASE WHEN e.FUEL_TYPE = 'Biodiesel (100%)' THEN 'Diesel'
                          ELSE e.FUEL_TYPE END) = mu.FUEL_TYPE
GROUP BY 1
