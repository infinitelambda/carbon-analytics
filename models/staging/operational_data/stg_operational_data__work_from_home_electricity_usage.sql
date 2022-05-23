{{
config(
  materialized='view'
  )
}}

select * from {{ var(var('operational_data_source') ~ '.' ~ 'work_from_home_electricity_usage') }}