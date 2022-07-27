{{
config(
  materialized='table'
  )
}}

-- call to a macro that determines where a the client has locations
/* it checks if locations are in any of three categories:

* UK-level - this is only for the UK since we take into consideration hourly electricity demand only in that country
* Region-level - these are the US, China, Canada, Australia, i.e. countries for which we have some region-level data but nothing about hourly demand
* Country-level - these are any other countries that do not fall in the above 2 categories. We only have country-level data for those.

It checks this by using distinct region values from client data and stg_additional_modelling_resources__carbon_intensity_regions_mapped (see lines 82-88 for mapping change)
The macro will set variables based on which the below jinja will decide which SQL to include. The vars can be something like
uk_locations: BOOL
region_data_locations: BOOL
country_data_locations: BOOL
*/
{% set regions_list = area_checker_macro() %}
{% set region_uk = regions_list[0] %}
{% set region_other = regions_list[1] %}
{% set country = regions_list[2] %}

with
{% if region_uk %}
average_hourly_intensity AS ( --UK-only
SELECT
  to_date(FROM_DATE) AS INTENSITY_DATE,
  EXTRACT(HOUR FROM FROM_DATE) AS INTENSITY_HOUR,
  REGION_ID,
  REGION_SHORT_NAME AS REGION_NAME,
  AVG(KGCO2) AS HOURLY_KGCO2
FROM {{ ref('stg_emissions_factors__purchased_electricity_uk_regional_carbon_intensity') }}
GROUP BY 1,2,3,4
),
weighted_daily_intensity AS ( --UK-only
SELECT
  ahi.INTENSITY_DATE,
  ahi.REGION_NAME,
  huf.PREMISE_TYPE,
  SUM(ahi.HOURLY_KGCO2*huf.FACTOR) AS "WEIGHTED_DAILY_KGCO2"
FROM average_hourly_intensity ahi
LEFT JOIN {{ ref('stg_additional_modelling_resources__hourly_usage_factors') }} huf ON huf.HOUR=ahi.INTENSITY_HOUR
AND (
  CASE
    WHEN dayname(ahi.INTENSITY_DATE) IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri') THEN TRUE
    WHEN dayname(ahi.INTENSITY_DATE) IN ('Sat', 'Sun') THEN FALSE
  ELSE NULL END
) = huf.IS_WEEKDAY
GROUP BY 1,2,3
),
factored_locations as ( --UK only
SELECT DISTINCT PREMISE_TYPE
FROM {{ ref('stg_additional_modelling_resources__hourly_usage_factors') }}
),
company_locations as (  --can be general but we need to remove factored_locations, may revisit later
  SELECT
  cd.LOCATION_SIZE_SQ_FT,
  cd.LOCATION_ID,
  cd.LOCATION,
  cd.LOCATION_LATITUDE,
  cd.LOCATION_LONGITUDE,
  -- cd.REGION,  --this replaces ABBREVIATED_POST_CODE
  CASE
    WHEN fl.PREMISE_TYPE IS NULL THEN 'Office'
    ELSE fl.PREMISE_TYPE
  END AS PREMISE_TYPE_FOR_JOINING --when the client has location types for which we do not have factors, we just use the Office factors
  FROM {{ ref('stg_operational_data__company_locations') }} CD
  LEFT JOIN factored_locations FL on FL.PREMISE_TYPE=cd.LOCATION
),
uk_level_emissions as (
SELECT  --UK-only
  ac.INTENSITY_DATE as DATE,
  cd.LOCATION_SIZE_SQ_FT,
  cd.LOCATION_ID,
  cd.LOCATION_LATITUDE,
  cd.LOCATION_LONGITUDE,
  CD.LOCATION_COUNTRY, --this was not present originally but will be included
  ac.REGION_NAME as CARBON_INTENSITY_REGION_NAME,
  dem.TYPE AS LOCATION_CATEGORY,
  ROUND(cd.LOCATION_SIZE_SQ_FT*(dem.ANNUAL_KWH_DEMAND/365), 2) as ESTIMATED_KWH_USAGE,
  ROUND(cd.LOCATION_SIZE_SQ_FT*(dem.ANNUAL_KWH_DEMAND/365)*"WEIGHTED_DAILY_KGCO2",3) AS TOTAL_KGCO2E
FROM company_locations CD
LEFT JOIN {{ ref('stg_additional_modelling_resources__us_commercial_buildings_demand') }} dem ON upper(dem.TYPE)=upper(cd.LOCATION)
LEFT JOIN {{ ref('stg_additional_modelling_resources__carbon_intensity_regions_mapped') }} r ON r.REGION_NAME=cd.REGION
LEFT JOIN weighted_daily_intensity ac on ac.REGION_NAME=r.REGION_NAME and cd.PREMISE_TYPE_FOR_JOINING = ac.PREMISE_TYPE
WHERE CD.LOCATION_COUNTRY = 'United Kingdom' --this is added so we don't factor in non-UK locations
)
{% endif %}

{% if region_uk and country %}
,
{% endif %}

{% if region_uk or country %}
date_spine AS (
  {{dbt_utils.date_spine("day", "to_date('1970-01-01')", "current_date()")}}
),
date_spine_filtered as (
  SELECT
  DATE_DAY AS DATE
FROM date_spine
WHERE date_day >= '{{ var('start_date') }}' --we can provide this variable so that users without invoiced data operating in locations with no carbon intensity daily data can specify a time range
)
{% endif %}

{% if country %}
,country_level_emissions as (
SELECT
DSF.DATE as DATE,
CD.LOCATION_SIZE_SQ_FT,
CD.LOCATION_ID,
CD.LOCATION_LATITUDE,
CD.LOCATION_LONGITUDE,
CD.LOCATION_COUNTRY, --include this in other models
NULL as CARBON_INTENSITY_REGION_NAME, --we could potentially just put the country name here again
DEM.TYPE AS LOCATION_CATEGORY,
ROUND(CD.LOCATION_SIZE_SQ_FT*(DEM.ANNUAL_KWH_DEMAND/365), 2) AS ESTIMATED_KWH_USAGE,
ROUND(CD.LOCATION_SIZE_SQ_FT*(DEM.ANNUAL_KWH_DEMAND/365)*PUR.TOTAL_KGCO2E,3) AS TOTAL_KGCO2E
FROM {{ ref('stg_operational_data__company_locations') }} CD
CROSS JOIN date_spine_filtered DSF
LEFT JOIN {{ ref('stg_additional_modelling_resources__us_commercial_buildings_demand') }} DEM ON UPPER(DEM.TYPE)=UPPER(CD.LOCATION)
LEFT JOIN {{ ref('stg_emissions_factors__purchased_electricity_country_level') }} PUR ON UPPER(PUR.COUNTRY)=UPPER(CD.LOCATION_COUNTRY) --causes double join
WHERE CD.LOCATION_COUNTRY NOT IN ('United Kingdom', 'US', 'China', 'Canada', 'Australia') --removes countries for which we have region-level data
AND PUR.SCOPE_2_METHODOLOGY = 'LOCATION_BASED'  --this model will only consider LOCATION_BASED emissions for now. I will need to find additional data for other countries and include it in the seed
)
{% endif %}

{% if (region_uk or country) and region_other %}
,
{% endif %}

{% if region_other %}
-- region_level_emissions as (
--[sql query to be added, will be very similar to the one in country_level_emissions CTE]
-- )
{% endif %}

{% if region_uk %}
SELECT * FROM uk_level_emissions
{% endif %}

{% if region_uk and (region_other or country) %}
UNION
{% endif %}

{% if country %}
SELECT * FROM country_level_emissions
{% endif %}

{% if region_uk and region_other and country %}
--UNION --commented out until query added
{% endif %}

{% if region_other %}
--SELECT * FROM region_level_emissions  --commented out until query added
{% endif %}
