{% docs fct_estimated_electricity_usage_carbon_emission_doc %}

This model estimates business premises' daily carbon emissions based on premise type (office, warehouse, store, etc.) and area.

Using [carbon intensity](https://carbonintensity.org.uk/) and average energy usage data, the model produces daily estimates of a business premise's carbon emissions. Averages are based on annual energy consumption in kWh per square foot. The emissions are expressed in kilograms of CO2 equivalent.

This model requires columns with the below names and containing the data described:
 - LOCATION_ID - A unique identifier of the premise.
 - LOCATION - Premise type as defined [here](link-to-docs-site).
 - LOCATION_SIZE_SQ_FT - Premise area expressed in square feet.
 - ABBREVIATED_POST_CODE - The letters in the first half of a UK post code for the premise.
 - LOCATION_LATITUDE - Geographic latitude of the premise. *** NOTE *** that this is not used in any calculations or joins, therefore null values are accepted.
 - LOCATION_LONGITUDE - Geographic longitude of the premise. *** NOTE *** that this is not used in any calculations or joins, therefore null values are accepted.

The data must be normalised, i.e. each premise must not appear more than once.

{% enddocs %}

{% docs fct_invoiced_electricity_usage_carbon_emission_doc %}

This model estimates business premises' daily carbon emissions based on premise type (office, warehouse, store, etc.) and invoiced electricity usage. The invoiced usage can be of any frequency - weekly, monthly, invoiced, etc.

Estimations utilise demand factors based on [Ofgem's Electricity demand profiles](https://www.google.com/search?q=ofgem+demand+file&ei=v2h6Yp6uG9K78gKXpb_ACw&ved=0ahUKEwjeic2GhdX3AhXSnVwKHZfSD7gQ4dUDCA4&uact=5&oq=ofgem+demand+file&gs_lcp=Cgdnd3Mtd2l6EAMyBQghEKABOgcIABBHELADSgQIQRgASgQIRhgAUPMDWPMDYPsFaAJwAXgAgAFniAFnkgEDMC4xmAEAoAEByAEIwAEB&sclient=gws-wiz#:~:text=Electricity%20demand%20profiles,docs%20%E2%80%BA%202012/06). The purpose of this is to reflect that electricity usage can be different on weekends and weekdays depending on the business premise.

The model counts the number of weekend and week days within each period. Using the daily demand factors, it calculates each day's percentage of the period's total electricity usage. In the model's SQL query these percentages are referred to as WEEKDAY_FACTOR_ADJUSTED and WEEKEND_FACTOR_ADJUSTED.

This model requires columns with the below names and containing the data described:
 - LOCATION_ID - A unique identifier of the premise
 - LOCATION - Premise type as defined [here](link-to-docs-site)
 - LOCATION_LATITUDE - Geographic latitude of the premise. *** NOTE *** that this is not used in any calculations or joins, therefore null values are accepted.
 - LOCATION_LONGITUDE - Geographic longitude of the premise. *** NOTE *** that this is not used in any calculations or joins, therefore null values are accepted.
 - ABBREVIATED_POST_CODE - The letters in the first half of a UK post code for the premise
 - PERIOD - A column specifying what period each row covers. This is only used for grouping purposes during calculations so any wording is accepted. However, one period cannot have more than one name (e.g. avoid having both 'Q1-2020' and 'Q1 2020').
 - PERIOD_START - The first date included in the period, Ideally in the YYYY-MM-DD format.
 - PERIOD_END - The last date included in the period, Ideally in the YYYY-MM-DD format.

 *** IMPORTANT: *** The model makes a number of assumptions on electricity usage:
 - Usage is the same across week and weekend days within the same period.
 - There are no days where usage is zero.
 - Electricity demand factors do not vary across seasons.
 - The model does not consider public holidays. Those falling on weekdays are treated as regular weekdays.

{% enddocs %}

{% docs fct_business_cars_carbon_emission_doc %}
This model estimates business cars' monthly carbon emissions based on monthly mileage and fuel type.

Using the average miles a gallon of fuel can last, monthly mileage for each vehicle is converted to estimated emissions. The emissions are expressed in kilograms of CO2 equivalent.

This model requires columns with the below names and containing the data described:
 - CAR_ID - A unique identifier of the vehicle
 - FUEL_TYPE - Fuel type as defined [here](link-to-docs-site)
 - MILEAGE - Monthly mileage
 - YEAR - The year in which the monthly mileage falls
 - MONTH - The month for the mileage

{% enddocs %}

{% docs fct_business_travels_carbon_emission_doc %}
This model estimates business travels' carbon emissions based on mileage and passenger transport type.

Using the the transport type and the average kilograms of CO2 equivalent produced per mile, transportation mileage is converted to estimated emissions. The emissions are also expressed in kilograms of CO2 equivalent.

This model requires columns with the below names and containing the data described:
 - TRANSPORT_TYPE - Transportation type as defined [here](link-to-docs-site)
 - TOTAL_MILES - Total travel mileage
 - DATE - Date of the travel

{% enddocs %}

{% docs fct_operational_vehicles_distance_and_weight_based_carbon_emission_doc %}

This model estimates operational vehicles' carbon emissions based on vehicle type, distance travelled in miles, and weight in tonnes.

Using the vehicle type and the average kilograms of CO2 equivalent produced per tonne-mile, vehicle mileage and weight are converted to estimated emissions. The emissions are also expressed in kilograms of CO2 equivalent.

This model requires columns with the below names and containing the data described:
 - DATE - Date of the trip
 - VEHICLE_ID - A unique identifier of the vehicle
 - VEHICLE_TYPE - Vehicle type as defined [here](link-to-docs-site)
 - DISTANCE_MILES - Total trip mileage
 - WEIGHT_TONNE  - Vehicle weight in tonnes
 - COMPANY_NAME - Name of the company

{% enddocs %}

{% docs fct_operational_vehicles_distance_based_carbon_emission_doc %}

This model estimates operational vehicles' carbon emissions based on vehicle type and distance travelled.

Using the the vehicle type and the average kilograms of CO2 equivalent produced per mile, vehicle mileage and weight are converted to estimated emissions. The emissions are also expressed in kilograms of CO2 equivalent.

This model requires columns with the below names and containing the data described:
 - DATE - Date of the trip
 - VEHICLE_ID - A unique identifier of the vehicle
 - VEHICLE_TYPE - Vehicle type as defined [here](link-to-docs-site)
 - VEHICLE_CATEGORY - Vehicle category (e.g. 'light-duty', 'heavy-duty'). *** NOTE *** that this is not used in any calculations or joins, therefore null values are accepted.
 - DISTANCE_MILES - Total trip mileage
 - COMPANY_NAME - Name of the company

{% enddocs %}

{% docs fct_employee_business_cars_carbon_emission_doc %}

This model takes business expenses data and estimates business vehicles' carbon emissions based on fuel type and amount.

Using the vehicle type and the average kilograms of CO2 equivalent produced per mile, vehicle mileage and weight are converted to estimated emissions. The emissions are also expressed in kilograms of CO2 equivalent.

This model requires columns with the below names and containing the data described:
 - DATE - Date of the fuel being used
 - FUEL_TYPE - Fuel type as defined [here](link-to-docs-site)
 - VOLUME - Fuel volume
 - EMPLOYEE_ID - Unique identifier of the employee
 - EXPENSE_TYPE - Type of expense. This must always have the value 'Fuel' in order to be included in the model.

{% enddocs %}

{% docs fct_work_from_home_carbon_emission_doc %}

This model estimates weekly carbon emissions as a result of working from home.

Using average kWh demand for lighting and computers, and country-level emissions factors for purchased electricity, the model can estimate emissions expressed in kilograms of CO2 equivalent.

This model requires columns with the below names and containing the data described:
 - DATE - Date of week commencing
 - COMPANY_NAME - Company name
 - EMPLOYEE_ID - Unique employee id
 - COUNTRY - The country where an employee works
 - WFH_DAYS_PER_WEEK - Data indicating how many days per week are worked from home
 - CONTRACT_TYPE - Indicates whether the employee works full- or part-time. Only 'part-time' is used as a value, anything else is assumed to be full-time.

{% enddocs %}

{% docs fct_factory_machinery_usage_carbon_emission_doc %}

This model takes spent fuel volume and estimates daily carbon emissions produced by machinery that involves stationary combustion.

Using data on heat and emissions produced by various types of fuel during stationary combustion, this model converts fuel volume to emissions expressed in kilograms of CO2 equivalent.

This model requires columns with the below names and containing the data described:
 - DATE - Date of the machinery operating
 - FUEL_TYPE - Type of fuel utilised by the machinery, as defined [here](link-to-docs-site)
 - FUEL_VOLUME_USED - The volume of fuel used in litres

{% enddocs %}

{% docs fct_factory_machinery_carbon_emission_doc %}

This model estimates daily carbon emissions produced by machinery that involves stationary combustion. It does not require data on spent fuel as it makes a number of assumptions.

Currently, the model assumes each machine runs for 12 hours each day at 50% capacity. Using average fuel requirements data, the model estimates emissions expressed in kilograms of CO2 equivalent.

This model requires columns with the below names and containing the data described:
 - SK_FACTORY_MACHINERY - a unique identifier for each machine.
 - SIZE_KW - machine size expressed in kW.
 - MACHINE_TYPE - Type of the machinery, as defined [here](link-to-docs-site).
 - FUEL_TYPE - Type of fuel utilised by the machinery, as defined [here](link-to-docs-site).

 {% enddocs %}


{% docs fct_estimated_heating_usage_carbon_emission_doc %}

This model estimates daily carbon emissions as a result of heating business premises.

Using average heating demand per square foot per premise type and the carbon emissions of natural gas, the model can estimate emissions expressed in kilograms of CO2 equivalent. This model makes two key assumptions:
1. Heating demand is constant throughout the year - this is subject to change
2. Heating is generated via natural gas

This model requires columns with the below names and containing the data described:
- LOCATION_ID - A unique identifier of the premise
- LOCATION - Premise type as defined [here](link-to-docs-site)
- LOCATION_SIZE_SQ_FT - Premise area expressed in square feet
- LOCATION_LATITUDE - Geographic latitude of the premise. *** NOTE *** that this is not used in any calculations or joins, therefore null values are accepted.
- LOCATION_LONGITUDE - Geographic longitude of the premise. *** NOTE *** that this is not used in any calculations or joins, therefore null values are accepted.

 *** IMPORTANT: *** This model requires the user to specify a date from which the emissions are calculated, therefore the emissions_start_date variable in dbt_project.yml may need to be adjusted. Calculations will be made from the date specified until the day the model is executed.  


{% enddocs %}
