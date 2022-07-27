{% macro area_checker_macro() %}

{#-- macro that returns list of booleans describing where the company has locations [region_uk, region_other, country] #}
{#-- region_uk - at least one business location in the UK;  #}
{#-- region_other - at least one business location in Australia, China, Canada and/or the US #}
{#-- country - at least one business location in any other country #}

{% if execute %}
{%- set sql -%}
SELECT DISTINCT s.AREA_TYPE
{# -- FROM {{ ref('stg_operational_data__company_locations') }} #} b -- to replace bellow FROM stmn when stg model available
FROM "SUSAN_DEV_SHARED_DB"."ZZ_DIMITUR_SEEDS"."BSD_COMPANY_LOCATIONS" b
{# -- INNER JOIN {{ ref('stg_additional_modelling_resources__carbon_intensity_areas') }} s -- to replace bellow FROM stmn when stg model available
INNER JOIN "SUSAN_DEV_SHARED_DB"."ZZ_DIMITUR_SEEDS"."SEED_CARBON_INTENSITY_AREAS" s
ON b.CARBON_INTENSITY_AREA=s.CARBON_INTENSITY_AREA
{%- endset -%}

{%- set results = run_query(sql) -%}
{% set results_tuple = results.columns[0].values() %}


{% set region_uk = output_checker('Region - UK', results_tuple) %}
{% set region_other = output_checker('Region - Other', results_tuple) %}
{% set country = output_checker('Country', results_tuple) %}

{{ return([region_uk, region_other, country]) }}
{% endif %}
{% endmacro %}

{% macro output_checker(value, output) %}
{#-- macro that checks if a value is in the output of run_query(sql) #}

{% if value in output %}
  {{ return(True) }}
{% else %}
{{ return(False) }}
{% endif %}

{% endmacro %}
