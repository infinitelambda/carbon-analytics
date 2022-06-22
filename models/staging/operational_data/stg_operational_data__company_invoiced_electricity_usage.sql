{{
config(
  materialized='view'
  )
}}

select * from {{ var(var('operational_data_source') ~ '.' ~ 'company_invoiced_electricity_usage') }}
