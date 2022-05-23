{% macro length_converter(from_metric, to_metric, field_name_source, scale) %}
{%- set scale = scale|default(2) -%}
{%- set from_metric -%}
{{metric_identifier(from_metric)}}
{%- endset -%}
{%- set to_metric -%}
{{metric_identifier(to_metric)}}
{%- endset -%}
{%- if from_metric == 'KILOMETRE' %}
   {%- if to_metric == 'MILE' %}
   {{kilometre_and_mile(from_metric, field_name_source, scale)}}
   {%- elif to_metric == 'METRE' %}
   {{kilometre_and_metre(from_metric, field_name_source, scale)}}
   {%- endif -%}
{%- elif from_metric == 'MILE' %}
   {%- if to_metric == 'KILOMETRE' %}
   {{kilometre_and_mile(from_metric, field_name_source, scale)}}
   {%- endif -%}
{%- elif from_metric == 'METRE' %}
{%- if to_metric == 'KILOMETRE' %}
{{kilometre_and_metre(from_metric, field_name_source, scale)}}
{%- endif -%}
{%- else %}
{{ abort("The metrics specified are not supported. Exception raised by length_converter macro.") }}
{%- endif -%}
{% endmacro %}


{% macro kilometre_and_mile(from_metric, field_name_source, scale) %}
{%- if from_metric == 'KILOMETRE' %}
ROUND({{ field_name_source }}*0.621371 , {{ scale }})
{%- elif from_metric == 'MILE' %}
ROUND({{ field_name_source }}*1.60934 , {{ scale }})
{%- else %}
{{ abort("The metrics specified are not supported. Exception raised by kilometre_and_mile macro.") }}
{%- endif -%}
{% endmacro %}

{% macro kilometre_and_metre(from_metric, field_name_source, scale) %}
{%- if from_metric == 'KILOMETRE' %}
ROUND({{ field_name_source }}*0.001 , {{ scale }})
{%- elif from_metric == 'METRE' %}
ROUND({{ field_name_source }}*1000 , {{ scale }})
{%- else %}
{{ abort("The metrics specified are not supported. Exception raised by kilometre_and_metre macro.") }}
{%- endif -%}
{% endmacro %}
