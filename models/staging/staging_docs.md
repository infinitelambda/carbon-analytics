{% docs stg_additional_modelling_resources__carbon_intensity_regions_mapped_doc %}

This model maps British post codes to carbon intensity regions (Please refer to the map provided in the Regional section [here](https://carbonintensity.org.uk/)).

*** IMPORTANT: *** In due course, we will start asking practitioners to provide data on which carbon intensity region their premises are located in. Afterwards, this model and and related models will not be available.

{% enddocs %}

{% docs stg_additional_modelling_resources__hourly_usage_factors_doc %}

This model holds electricity demand factors based on [Ofgem's Electricity demand profiles](https://www.google.com/search?q=ofgem+demand+file&ei=v2h6Yp6uG9K78gKXpb_ACw&ved=0ahUKEwjeic2GhdX3AhXSnVwKHZfSD7gQ4dUDCA4&uact=5&oq=ofgem+demand+file&gs_lcp=Cgdnd3Mtd2l6EAMyBQghEKABOgcIABBHELADSgQIQRgASgQIRhgAUPMDWPMDYPsFaAJwAXgAgAFniAFnkgEDMC4xmAEAoAEByAEIwAEB&sclient=gws-wiz#:~:text=Electricity%20demand%20profiles,docs%20%E2%80%BA%202012/06). The purpose of this is to reflect that electricity demand fluctuates throughout the day.

The factors are the same across regions, and are calculated in the following way:
1. Hourly factors in the Input data sheet are grouped by premise type and day type (weekend or week day), and averaged across seasons.
2. The above averages are grouped by premise type and day type, and summed.
3. The averaged factors from step 1 are presented as proportions from the step 2 sum.

These factors may be modified in the future to reflect:
- Any significant changes in consumer demand
- Variations between regions
- Variations between premise types
- Anything else that may reasonably improve emission estimates

Data practitioners will be notified of such changes and a historic record of the factors may be created.
{% enddocs %}

{% docs stg_additional_modelling_resources__daily_usage_factors_doc %}
This model holds electricity demand factors based on [Ofgem's Electricity demand profiles](https://www.google.com/search?q=ofgem+demand+file&ei=v2h6Yp6uG9K78gKXpb_ACw&ved=0ahUKEwjeic2GhdX3AhXSnVwKHZfSD7gQ4dUDCA4&uact=5&oq=ofgem+demand+file&gs_lcp=Cgdnd3Mtd2l6EAMyBQghEKABOgcIABBHELADSgQIQRgASgQIRhgAUPMDWPMDYPsFaAJwAXgAgAFniAFnkgEDMC4xmAEAoAEByAEIwAEB&sclient=gws-wiz#:~:text=Electricity%20demand%20profiles,docs%20%E2%80%BA%202012/06). The purpose of this is to reflect that electricity usage can be different on weekends and weekdays depending on the business premise.

The factors are the same across regions and are calculated in the following way:
1. Hourly factors per premise type in the Input data sheet are averaged across seasons.
2. The above averages are summed.

These factors may be modified in the future to reflect:
- Any significant changes in consumer demand
- Variations between regions
- Variations between premise types
- Anything else that may reasonably improve emission estimates

Data practitioners will be notified of such changes and a historic record of the factors may be created.
{% enddocs %}

{% docs stg_additional_modelling_resources__machinery_consumption_doc %}
This model currently shows average machinery fuel consumption data only for diesel power generators. In the future, additional types of machinery will be added.

The sources of this data are listed bhelow:
- [Diesel power generators](https://www.generatorsource.com/Diesel_Fuel_Consumption.aspx)
- [Natural gas power generators](https://www.generatorsource.com/Natural_Gas_Fuel_Consumption.aspx)
{% enddocs %}

{% docs stg_additional_modelling_resources__us_commercial_buildings_demand_doc %}
This model holds data on typical power and heating demand per square foot per building type, as shown [here](https://ouc.bizenergyadvisor.com/categories/business-types).

*** IMPORTANT: *** These figures are for average demand in the USA. UK data will replace this in due course.
{% enddocs %}

{% docs stg_emissions_factors__mobile_combustion_doc %}

This model holds data on emissions factors for different types of fuel used in mobile combustion. Kilograms of CO2 equivalent is the factor used in all metric models, however C02, CH4, N2O and Biogenic CO2 factors are available as well.

Please refer to the SOURCE column for details on where the data comes from.

{% enddocs %}

{% docs stg_emissions_factors__purchased_electricity_country_level_doc %}

This model holds data on emissions factors for purchased electricity in different countries. Kilograms of CO2 equivalent is the factor used in all metric models, however C02, CH4, N2O and Biogenic CO2 factors are available as well.

Please refer to the SOURCE column for details on where the data comes from.

{% enddocs %}

{% docs stg_emissions_factors__purchased_electricity_regional_location_based_doc %}

This model holds data on emissions factors for purchased electricity in different eGrid regions. Kilograms of CO2 equivalent is the factor used in all metric models, however C02, CH4, N2O and Biogenic CO2 factors are available as well.

Please refer to the SOURCE column for details on where the data comes from.

{% enddocs %}


{% docs stg_emissions_factors__purchased_electricity_regional_market_based_doc %}

This model holds data on emissions factors for purchased electricity in different eGrid regions. Kilograms of CO2 equivalent is the factor used in all metric models, however C02, CH4, N2O and Biogenic CO2 factors are available as well.

Please refer to the SOURCE column for details on where the data comes from.

{% enddocs %}

{% docs stg_emissions_factors__purchased_electricity_uk_national_generation_mix_doc %}

This model holds data on the types of fuel used to generate electricity in the UK.

The data is not currently used anywhere.

{% enddocs %}

{% docs stg_emissions_factors__purchased_electricity_uk_regional_carbon_intensity_doc %}

This model holds data on the types of fuel used to generate electricity in the UK on a regional level alongside the estimated CO2 emissions for that period. Data is provided for every half hour.

{% enddocs %}

{% docs stg_emissions_factors__stationary_combustion_doc %}

This model holds data on emissions factors for different types of fuel used in stationary combustion. Kilograms of CO2 equivalent is the factor used in all metric models, however C02, CH4, N2O and Biogenic CO2 factors are available as well.

Please refer to the SOURCE column for details on where the data comes from.

{% enddocs %}

{% docs stg_emissions_factors__transport_and_travel_doc %}

This model holds data on emissions factors for different types of transportation. Kilograms of CO2 equivalent is the factor used in all metric models, however C02, CH4, N2O and Biogenic CO2 factors are available as well.

Please refer to the SOURCE column for details on where the data comes from.

{% enddocs %}

{% docs stg_operational_data__company_business_travels_doc %}
This data is artificially generated to simulate records of business travels.

It is used in the fct_business_travels_carbon_emission model. Please refer to its documentation for more details.
{% enddocs %}

{% docs stg_operational_data__company_daily_electricity_usage_doc %}
This data is artificially generated to simulate daily records of electricity usage in kWh across business premises. It contains, among other things, total power usage and usage per square foot.

This is currently not used anywhere.
{% enddocs %}

{% docs stg_operational_data__company_invoiced_electricity_usage_doc %}

This data is artificially generated to simulate invoiced records of electricity usage in kWh across business premises. Unlike other sample data, this one covers 2021 as well so that more quarters are present. The data for 2022 is based on company_daily_electricity_usage.

{% enddocs %}

{% docs stg_operational_data__company_locations_doc %}
This data is artificially generated and contains information on business premises. It is essentially a normalised version of stg_operational_data__company_daily_electricity_usage.

This is currently used in the fct_daily_electricity_usage_carbon_emission model.
{% enddocs %}

{% docs stg_operational_data__employee_business_expenses_doc %}
This data is artificially generated to simulate a list of employees' daily business expenses. Currently it only consists of two types of expenses: food and fuel. Only the latter is used for carbon emissions estimation.

This data is used in the fct_employee_business_cars_carbon_emission model. Please refer to its documentation for more details.
{% enddocs %}

{% docs stg_operational_data__employee_business_vehicles_doc %}
This data is artificially generated to simulate a list of company vehicles.

This is currently not used anywhere.
{% enddocs %}

{% docs stg_operational_data__employee_monthly_mileage_doc %}
This data is artificially generated and contains employees' monthly mileage.

This data is used in the fct_business_cars_carbon_emission model. Please refer to its documentation for more details.
{% enddocs %}

{% docs stg_operational_data__operational_vehicles_company_1_doc %}
This data is artificially generated and contains details on operational trips such as deliveries and transportation of goods. Most importantly, it contains data on vehicle weight and distance traveled.

This data is used in the fct_operational_vehicles_company_1_carbon_emission model. Please refer to its documentation for more details.
{% enddocs %}

{% docs stg_operational_data__operational_vehicles_company_2_doc %}
This data is artificially generated and contains details on operational trips such as deliveries and transportation of goods. Unlike stg_operational_data__operational_vehicles_company_1, this model focuses solely on distance traveled.

This data is used in the fct_operational_data__operational_vehicles_company_2_carbon_emission model. Please refer to its documentation for more details.
{% enddocs %}

{% docs stg_operational_data__work_from_home_electricity_usage_doc %}
This data is artificially generated and contains estimated electricity usage by employees who work from home.

This is currently used in fct_work_from_home_carbon_emission. Please refer to its documentation for more details.
{% enddocs %}

{% docs stg_operational_data__factory_machinery_usage_doc %}
This data is artificially generated and contains details on daily fuel consumption of factory machinery.

This data is used in the fct_factory_machinery_usage_carbon_emission model. Please refer to its documentation for more details.
{% enddocs %}

{% docs stg_operational_data__factory_machinery_doc %}
This data is artificially generated and contains details on machinery used by our fake company. It is essentially a normalised version of stg_operational_data__factory_machinery_usage.

This data is used in the fct_factory_machinery_carbon_emission model. Please refer to its documentation for more details.
{% enddocs %}

{% docs stg_operational_data__employee_work_from_home_days_doc %}
This data is artificially generated and contains information on how many days a week employees spend working from home.

This is currently used in fct_work_from_home_carbon_emission. Please refer to its documentation for more details.
{% enddocs %}
