{{
config(
  materialized='view'
  )
}}

select * from  {{ source('emissions_factors','purchased_electricity_regional_location_based') }}