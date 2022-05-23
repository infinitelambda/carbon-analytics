{{
config(
  materialized='view'
  )
}}

select * from  {{ source('emissions_factors','stationary_combustion') }}