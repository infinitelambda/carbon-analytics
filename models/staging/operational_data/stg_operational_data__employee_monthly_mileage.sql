{{
config(
  materialized='view'
  )
}}

select * from {{ var(var('operational_data_source') ~ '.' ~ 'employee_monthly_mileage') }}