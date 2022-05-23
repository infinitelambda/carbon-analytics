{{
config(
  materialized='table'
  )
}}

with OPERATIONAL_VEHICLES_COMPANY_1 as (
    SELECT
        date as date,
        vehicle_id,
        distance_miles,
        weight_tonne,
        vehicle_type,
        product_shipped,
        company_name
    FROM {{ ref('stg_operational_data__operational_vehicles_company_1') }}
)

, TRANSPORT_AND_TRAVEL as (
    SELECT
        transport_type,
        total_kgco2e
    FROM {{ ref('stg_emissions_factors__transport_and_travel') }}
    WHERE
        unit = 'ton-mile'
)

SELECT
    ov.date::DATE as date,
    ov.company_name,
    ov.vehicle_id,
    ov.vehicle_type,
    ov.product_shipped,
    (ov.distance_miles * weight_tonne * tt.total_kgco2e) as total_kgco2e
FROM OPERATIONAL_VEHICLES_COMPANY_1 ov
JOIN TRANSPORT_AND_TRAVEL tt
    ON ov.vehicle_type = tt.transport_type
