{{
config(
  materialized='table'
  )
}}

select * from  {{ source('additional_modelling_resources','machinery_consumption') }}
