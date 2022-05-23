{{
config(
  materialized='table'
  )
}}

select * from  {{ source('additional_modelling_resources','carbon_intensity_regions_mapped') }}
