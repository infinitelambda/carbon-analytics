[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
#  SusAn

SusAn is a sustainability analytics tool that works with a [free emissions dataset](insert-Snowflake-data-marketplace-link) to estimate your organisation's greenhouse gas emissions from various common business activities such as office use and transportation.

## Models
These are the final models the package produces. There are also some staging and intermediate models not listed here.

| **model**                                            |  **description**                                         |
| ---------------------------------------------------- | -------------------------------------------------------- |
| fct_business_cars_carbon_emission                    | Estimated emissions per vehicle, daily                   |
| fct_business_travels_carbon_emission                 | Estimated emissions per business travel type, daily               |
| fct_daily_electricity_usage_carbon_emission          | Estimated emissions from electricity per location, daily                  |
| fct_invoiced_electricity_usage_carbon_emission          | Estimated emissions from invoiced electricity per location                  |
| ft_daily_heating_carbon_emission                     | Estimated emissions from heating per location, daily
| fct_employee_business_cars_carbon_emission           | Estimated emissions per employee car, by date of expense |
| fct_factory_machinery_carbon_emission                | Estimated emissions from machinery based on capacity     |
| fct_factory_machinery_usage_carbon_emission          | Estimated emissions from machinery based on fuel usage   |
| fct_operational_vehicles_distance_and_weight_based_carbon_emission   | Estimated emissions from operational vehicles' travelled distance and weight, daily                                             |
| fct_operational_vehicles_distance_based_carbon_emission | Estimated emissions from operational vehicles' travelled distance, daily |
| fct_work_from_home_carbon_emission                   | Estimated emissions from WFH electricity usage, weekly   |

## Getting started
To access the emissions dataset, go to Susan's Snowflake [data marketplace listing](insert-marketplace-link) and click 'Get Data'. A set of sample operational data is included, which will allow you to build sample metrics with this package if you're not yet ready to use your own data.

Once the shared database is available in your account, please ensure that the Snowflake role you are using to run dbt has access to read from that database.

If you have any issues accessing the data, please contact us on Slack

### Source data location
By default, this package will use the sample data provided in the shared dataset in Snowflake. To use your own operational data, please change the value of the following variable in the package's dbt_project.yml from `sample` to `customer`:

```yml
vars:
    operational_data_source: sample
```
changes to

```yml
vars:
    operational_data_source: customer
```

Then, fill out the variables in the dbt_project.yml to point to your source data in the format `<database>.<schema>.<table_or_view_name>`. If you don't want to use all the models, you can set `enabled=false` in the corresponding model configs to disable the models you want to skip.

#### Required Values
The data modelling process involves a number of assumptions on the structure and content of typical operational data. Before using your own data, please ensure it contains the fields marked in each model's dbt documentation.

Some of the data used in our models comes with particular values which are used in some JOIN and WHERE statements. For these models to work, you need to make sure your own data is transformed to meet the requirements outlined in [Appendix A1](#a1---required-values). Please bear in mind that currently our joins are case sensitive. We will notify you of any changes to this or to any of the accepted values.

### Database Support
This package is currently only compatible with Snowflake. We hope to roll out wider compatibility soon.

## Contributions
Contributions to this package are welcome! Please create issues or open PRs against the `main` branch.

## Resources:
- Join our [Slack community](https://join.slack.com/t/sus-an/shared_invite/zt-19higwvs2-8PqLnejTAHY8Gf0GQmVpww) for support, feedback, feature requests and discussions
- Get emissions factors data from our [Snowflake Data Marketplace listing](insert-marketplace-link)
- Check out the [Infinite Lambda website](https://infinitelambda.com/)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Join the [dbt Slack](http://slack.getdbt.com/)

## Appendix
### A1 - Required values
#### fct_daily_electricity_usage_carbon_emission

Your LOCATION column must classify your premises in one of the following values:
- Airport
- Hotel
- Office
- Restaurant
- Store
- Warehouse
#### fct_business_cars_carbon_emission

Your FUEL_TYPE column must classify the type of fuel used by your vehicles in one of the following values:
- biodiesel
- diesel
- hybrid (gasoline)
- petrol
- electric
#### fct_business_travels_carbon_emission

Your TRANSPORT_TYPE column must classify your business travels in one of the following values. Return flights are marked with the *_RF* suffix.
- Air Travel - Domestic, to/from UK - Average passenger
- Air Travel - Domestic, to/from UK - Average passenger_RF
- Air Travel - International, to/from non-UK - Average passenger
- Air Travel - International, to/from non-UK - Average passenger_RF
- Air Travel - International, to/from non-UK - Business class
- Air Travel - International, to/from non-UK - Business class_RF
- Air Travel - International, to/from non-UK - Economy class
- Air Travel - International, to/from non-UK - Economy class_RF
- Air Travel - International, to/from non-UK - First class
- Air Travel - International, to/from non-UK - First class_RF
- Air Travel - International, to/from non-UK - Premium economy class
- Air Travel - International, to/from non-UK - Premium economy class_RF
- Air Travel - Long Haul (>= 2300 miles)
- Air Travel - Long-haul, to/from UK - Average passenger
- Air Travel - Long-haul, to/from UK - Average passenger_RF
- Air Travel - Long-haul, to/from UK - Business class
- Air Travel - Long-haul, to/from UK - Business class_RF
- Air Travel - Long-haul, to/from UK - Economy class
- Air Travel - Long-haul, to/from UK - Economy class_RF
- Air Travel - Long-haul, to/from UK - First class
- Air Travel - Long-haul, to/from UK - First class_RF
- Air Travel - Long-haul, to/from UK - Premium economy class
- Air Travel - Long-haul, to/from UK - Premium economy class_RF
- Air Travel - Medium Haul (>= 300 miles, < 2300 miles)
- Air Travel - Short Haul (< 300 miles)
- Air Travel - Short-haul, to/from UK - Average passenger
- Air Travel - Short-haul, to/from UK - Average passenger_RF
- Air Travel - Short-haul, to/from UK - Business class
- Air Travel - Short-haul, to/from UK - Business class_RF
- Air Travel - Short-haul, to/from UK - Economy class
- Air Travel - Short-haul, to/from UK - Economy class_RF
- Bus
- Commuter Rail D
- Ferry - Average (all passenger)
- Intercity Rail (i.e. Amtrak) C
- International rail
- Light rail and tram
- Local Bus
- National rail
- Taxi - regular
- Transit Rail (i.e. Subway, Tram) E

#### fct_operational_vehicles_distance_and_weight_based_carbon_emission

Your VEHICLE_TYPE column must classify your operational vehicles in one of the following values:
- Aircraft
- Cargo Ship - Bulk Carrier - Average
- Cargo Ship - Container Ship - Average
- Cargo Ship - General Cargo - Average
- Cargo Ship - Large RoPax Ferry - Average
- Cargo Ship - Refrigerated Cargo -  All dwt
- Cargo Ship - RoRo-Ferry - Average
- Cargo Ship - Vehicle Transport - Average
- Freight flights - Domestic, to/from UK
- Freight flights - Domestic, to/from UK_RF
- Freight flights - International, to/from non-UK
- Freight flights - International, to/from non-UK_RF
- Freight flights - Long-haul, to/from UK
- Freight flights - Long-haul, to/from UK_RF
- Freight flights - Short-haul, to/from UK
- Freight flights - Short-haul, to/from UK_RF
- HGV (all diesel)
- HGV refrigerated (all diesel)
- Rail
- Rail - Freight train
- Sea Tanker - Chemical Tanker - Average
- Sea Tanker - Crude Tanker - Average
- Sea Tanker - LNG Tanker - Average
- Sea Tanker - LPG Tanker - Average
- Sea Tanker - Products Tanker - Average
- Waterborne Craft

#### fct_operational_vehicles_distance_based_carbon_emission

Your VEHICLE_TYPE column must classify your operational vehicles in one of the following values:
- Average Car - Battery Electric Vehicle
- Average Car - CNG
- Average Car - Diesel
- Average Car - Hybrid
- Average Car - LPG
- Average Car - Petrol
- Average Car - Plug-in Hybrid Electric Vehicle
- Average Car - Unknown
- HGV (all diesel)
- HGV refrigerated (all diesel)
- Light-Duty Truck B
- Medium- and Heavy-Duty Truck
- Motorbike
- Motorcycle
- Passenger Car A
- Vans - Average (up to 3.5 tonnes) - Battery Electric Vehicle
- Vans - Average (up to 3.5 tonnes) - CNG
- Vans - Average (up to 3.5 tonnes) - Diesel
- Vans - Average (up to 3.5 tonnes) - LPG
- Vans - Average (up to 3.5 tonnes) - Petrol
- Vans - Average (up to 3.5 tonnes) - Unknown

#### fct_employee_business_cars_carbon_emission

Your FUEL_TYPE column must classify the type of fuel used by your business vehicles in one of the following values:
- biodiesel
- diesel
- hybrid (gasoline)
- petrol
- electric

Your EXPENSE_TYPE column must always have the value 'Fuel'.

#### fct_factory_machinery_usage_carbon_emission

Your FUEL_TYPE column must classify the type of fuel used by your machinery in one of the following values:

- Agricultural Byproducts
- Anthracite Coal
- Asphalt and Road Oil
- Aviation Gasoline
- Bagasse
- Bamboo
- Biodiesel (100%)
- Bituminous Coal
- Blast Furnace Gas
- Butane
- Butylene
- Coal Coke
- Coke Oven Gas
- Crude Oil
- Distillate Fuel Oil No. 1
- Distillate Fuel Oil No. 2
- Distillate Fuel Oil No. 4
- Ethane
- Ethanol (100%)
- Ethylene
- Fuel Gas
- Heavy Gas Oils
- Isobutane
- Isobutylene
- Kerosene
- Kerosene-Type Jet Fuel
- Landfill Gas
- Lignite Coal
- Liquefied Petroleum Gases (LPG)
- Lubricants
- Mixed (Commercial Sector)
- Mixed (Electric Power Sector)
- Mixed (Industrial Coking)
- Mixed (Industrial Sector)
- Motor Gasoline
- Municipal Solid Waste
- Naphtha (<401 deg F)
- Natural Gas
- Natural Gasoline
- North American Hardwood
- North American Softwood
- Other Biomass Gases
- Other Oil (>401 deg F)
- Peat
- Pentanes Plus
- Petrochemical Feedstocks
- Petroleum Coke
- Petroleum Coke (Solid)
- Plastics
- Propane
- Propane Gas
- Propylene
- Rendered Animal Fat
- Residual Fuel Oil No. 5
- Residual Fuel Oil No. 6
- Solid Byproducts
- Special Naphtha
- Straw
- Sub-bituminous Coal
- Tires
- Unfinished Oils
- Used Oil
- Vegetable Oil
- Wood and Wood Residuals

#### fct_factory_machinery_carbon_emission

Your MACHINE_TYPE column must classify your machinery in one of the following values:

- Power Generator

Your FUEL_TYPE column must classify the type of fuel used by your machinery in one of the following values:

- Agricultural Byproducts
- Anthracite Coal
- Asphalt and Road Oil
- Aviation Gasoline
- Bagasse
- Bamboo
- Biodiesel (100%)
- Bituminous Coal
- Blast Furnace Gas
- Butane
- Butylene
- Coal Coke
- Coke Oven Gas
- Crude Oil
- Distillate Fuel Oil No. 1
- Distillate Fuel Oil No. 2
- Distillate Fuel Oil No. 4
- Ethane
- Ethanol (100%)
- Ethylene
- Fuel Gas
- Heavy Gas Oils
- Isobutane
- Isobutylene
- Kerosene
- Kerosene-Type Jet Fuel
- Landfill Gas
- Lignite Coal
- Liquefied Petroleum Gases (LPG)
- Lubricants
- Mixed (Commercial Sector)
- Mixed (Electric Power Sector)
- Mixed (Industrial Coking)
- Mixed (Industrial Sector)
- Motor Gasoline
- Municipal Solid Waste
- Naphtha (<401 deg F)
- Natural Gas
- Natural Gasoline
- North American Hardwood
- North American Softwood
- Other Biomass Gases
- Other Oil (>401 deg F)
- Peat
- Pentanes Plus
- Petrochemical Feedstocks
- Petroleum Coke
- Petroleum Coke (Solid)
- Plastics
- Propane
- Propane Gas
- Propylene
- Rendered Animal Fat
- Residual Fuel Oil No. 5
- Residual Fuel Oil No. 6
- Solid Byproducts
- Special Naphtha
- Straw
- Sub-bituminous Coal
- Tires
- Unfinished Oils
- Used Oil
- Vegetable Oil
- Wood and Wood Residuals

#### fct_daily_heating_carbon_emission

Your LOCATION column must classify your business premises in one of the following values:
- Airport
- Hotel
- Office
- Restaurant
- Store
- Warehouse
