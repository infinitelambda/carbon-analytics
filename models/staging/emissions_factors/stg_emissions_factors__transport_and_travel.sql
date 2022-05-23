{{
config(
  materialized='view'
  )
}}

select * from  {{ source('emissions_factors','transport_and_travel') }}