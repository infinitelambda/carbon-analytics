{{
config(
  materialized='table'
  )
}}

select * from  {{ source('additional_modelling_resources','hourly_usage_factors') }}
