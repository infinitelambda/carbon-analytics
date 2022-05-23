{% test missing_value(model, column_name, source_model, source_column_name) %}

with source_model as (

    select
        {{ source_column_name }} as source_column_name

    from {{ source_model }}

),

model as (

    select
        {{ column_name }} as column_name

    from {{ model }}

)

select distinct
    source_model.source_column_name
from source_model
left join model
    on  source_model.source_column_name = model.column_name
where model.column_name is null

{% endtest %}