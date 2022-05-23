{{
config(
  materialized='view'
  )
}}

select * from {{ var(var('operational_data_source') ~ '.' ~ 'company_business_travels') }}
