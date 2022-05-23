{{
config(
  materialized='table'
  )
}}

with EMPLOYEE_BUSINESS_EXPENSES as (
    SELECT
        date,
        fuel_type,
        volume,
        employee_id
    FROM {{ ref('stg_operational_data__employee_business_expenses') }}
    WHERE
        expense_type = 'Fuel'
)

, MOBILE_COMBUSTION as (
    SELECT
      CASE
        WHEN fuel_type = 'Electricity - Mobile - Electric Vehicle' THEN 'electric'
        WHEN lower(regexp_substr(fuel_type, ' ([^-]+) Passenger Cars', 1,1,'e')) = 'gasoline' THEN 'petrol'
        ELSE lower(regexp_substr(fuel_type, ' ([^-]+) Passenger Cars', 1,1,'e'))
      END as fuel_type,
        total_kgco2e
    FROM {{ ref('stg_emissions_factors__mobile_combustion') }}
)

SELECT
    ee.date,
    ee.employee_id,
    ee.fuel_type,
    {{ volume_converter('litre', 'gallon', 'ee.volume') }} * mc.total_kgco2e as total_kgco2e
FROM EMPLOYEE_BUSINESS_EXPENSES ee
JOIN MOBILE_COMBUSTION mc ON lower(ee.fuel_type) = lower(mc.fuel_type)
