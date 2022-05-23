{{
config(
  materialized='table'
  )
}}

with EMPLOYEE_WORK_FROM_HOME_DAYS as (
    SELECT
        date,
        employee_id,
        company_name,
        contract_type,
        country,
        CASE
            WHEN contract_type = 'part-time' THEN wfh_days_per_week/2
            ELSE wfh_days_per_week
        END as wfh_days_per_week
    FROM {{ ref('stg_operational_data__employee_work_from_home_days') }}
)

, WORK_FROM_HOME_ELECTRICITY_USAGE as (
    SELECT
        measure_type,
        sum(amount) as amount
    FROM {{ ref('stg_operational_data__work_from_home_electricity_usage') }}
    WHERE
        date_interval_type = 'day'
    GROUP BY 1
)

, PURCHASED_ELECTRICITY_COUNTRY_LEVEL as (
    SELECT
        total_kgco2e,
        country,
        lower(unit) as unit
    FROM {{ ref('stg_emissions_factors__purchased_electricity_country_level') }}
)

SELECT
    date as date_week,
    company_name,
    sum(amount*total_kgco2e) as total_kgco2e
FROM EMPLOYEE_WORK_FROM_HOME_DAYS ed
CROSS JOIN WORK_FROM_HOME_ELECTRICITY_USAGE eu
JOIN PURCHASED_ELECTRICITY_COUNTRY_LEVEL pe
    ON eu.measure_type = pe.unit AND pe.country=ed.country
GROUP BY 1,2
