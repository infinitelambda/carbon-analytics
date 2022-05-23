{{
config(
  materialized='table'
  )
}}

select * from  {{ source('additional_modelling_resources','us_commercial_buildings_demand') }}
