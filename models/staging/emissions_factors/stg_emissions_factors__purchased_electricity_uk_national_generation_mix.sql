{{
config(
  materialized='view'
  )
}}

select * from  {{ source('emissions_factors','purchased_electricity_uk_national_generation_mix') }}