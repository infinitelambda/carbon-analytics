{{
config(
  materialized='table'
  )
}}

with EMPLOYEE_MONTHLY_MILEAGE as (
    SELECT
        car_id,
        fuel_type,
        year,
        month,
        mileage
    FROM {{ ref('stg_operational_data__employee_monthly_mileage') }}
)

, MOBILE_COMBUSTION as (
    SELECT
      CASE
        WHEN fuel_type = 'Electricity - Mobile - Electric Vehicle' THEN 'electric'
        WHEN lower(regexp_substr(fuel_type, ' ([^-]+) Passenger Cars', 1,1,'e')) = 'gasoline' THEN 'petrol'
        ELSE lower(regexp_substr(fuel_type, ' ([^-]+) Passenger Cars', 1,1,'e'))
      END as fuel_type,
      total_kgco2e,
      default_avg_fuel_efficiency_miles_per_unit
    FROM {{ ref('stg_emissions_factors__mobile_combustion') }}
    WHERE
        lower(fuel_type) LIKE '%passenger_cars%'
)

SELECT
    date_from_parts(em.YEAR,em.MONTH,1)::DATE as date,
    em.car_id as vehicle_id,
    em.fuel_type,
    (em.mileage/mc.default_avg_fuel_efficiency_miles_per_unit)*mc.total_kgco2e as total_kgco2e
FROM EMPLOYEE_MONTHLY_MILEAGE em
JOIN MOBILE_COMBUSTION mc ON lower(em.fuel_type) = lower(mc.fuel_type)
