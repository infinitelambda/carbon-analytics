{{
config(
  materialized='table'
  )
}}

with OPERATIONAL_VEHICLES_COMPANY_2 as (
    SELECT
        date,
        vehicle_id,
        vehicle_type,
        vehicle_category,
        distance_miles,
        company_name
    FROM {{ ref('stg_operational_data__operational_vehicles_company_2') }}
)

, TRANSPORT_AND_TRAVEL as (
    SELECT distinct
        transport_type,
        total_kgco2e
    FROM {{ ref('stg_emissions_factors__transport_and_travel') }}
    WHERE
        unit = 'vehicle-mile'
)

SELECT
    ov.date::DATE as date,
    ov.company_name,
    ov.vehicle_id,
    ov.vehicle_type,
    distance_miles * tt.total_kgco2e as total_kgco2e
FROM OPERATIONAL_VEHICLES_COMPANY_2 ov
JOIN TRANSPORT_AND_TRAVEL tt
    ON ov.vehicle_type = tt.transport_type
