{{
config(
  materialized='view'
  )
}}

select * from  {{ source('emissions_factors','purchased_electricity_uk_regional_carbon_intensity') }}