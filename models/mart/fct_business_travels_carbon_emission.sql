{{
config(
  materialized='table'
  )
}}

with COMPANY_BUSINESS_TRAVELS as (
    SELECT
        transport_type,
        total_miles,
        date
    FROM {{ ref('stg_operational_data__company_business_travels') }}
)

, TRANSPORT_AND_TRAVEL as (
    SELECT
        transport_type,
        total_kgco2e,
        unit
    FROM {{ ref('stg_emissions_factors__transport_and_travel') }}
    WHERE
        unit = 'passenger-mile'
 )
  
SELECT
    ct.date::DATE as date,
    transport_type,
    total_miles * tt.total_kgco2e as total_kgco2e
FROM COMPANY_BUSINESS_TRAVELS ct
JOIN TRANSPORT_AND_TRAVEL tt
    USING(transport_type)
