{{
config(
  materialized='table'
  )
}}

select * from  {{ source('additional_modelling_resources','daily_usage_factors') }}
