{{
config(
  materialized='view'
  )
}}

select * from  {{ source('emissions_factors','mobile_combustion') }}