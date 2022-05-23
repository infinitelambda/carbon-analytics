{{
config(
  materialized='view'
  )
}}

select * from {{ var(var('operational_data_source') ~ '.' ~ 'employee_work_from_home_days') }}