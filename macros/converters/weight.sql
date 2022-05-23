{% macro weight_converter(from_metric, to_metric, field_name_source, field_name, scale) %}
{%- set scale = scale|default(2) %}
{%- set from_metric -%}
{{metric_identifier(from_metric)}}
{%- endset -%}
{%- set to_metric -%}
{{metric_identifier(to_metric)}}
{%- endset -%}
{%- if from_metric == 'KILOGRAM'%}
   {%- if to_metric == 'TONNE' %}
   {{kilogram_and_tonne(from_metric, field_name_source, scale)}}
   {%- elif to_metric == 'POUND' %}
   {{kilogram_and_pound(from_metric, field_name_source, scale)}}
   {%- endif -%}
{%- elif from_metric == 'TONNE' %}
   {%- if to_metric == 'KILOGRAM' %}
   {{kilogram_and_tonne(from_metric, field_name_source, scale)}}
   {%- endif -%}
{%- elif from_metric == 'POUND' %}
   {%- if to_metric == 'KILOGRAM' %}
   {{kilogram_and_pound(from_metric, field_name_source, scale)}}
   {%- endif -%}
{{kilogram_and_pound(from_metric, field_name_source, scale)}}
{%- else %}
{{ abort("The metrics specified are not supported. Exception raised by weight_converter macro.") }}
{%- endif -%}
{% endmacro %}


{% macro kilogram_and_tonne(from_metric, field_name_source, scale) %}
{%- if from_metric == 'KILOGRAM' %}
ROUND({{ field_name_source }}*0.001 , {{ scale }})
{%- elif from_metric == 'TONNE' %}
ROUND({{ field_name_source }}*1000 , {{ scale }})
{%- else %}
{{ abort("The metrics specified are not supported. Exception raised by kilogram_and_tonne macro.") }}
{%- endif -%}
{% endmacro %}

{% macro kilogram_and_pound(from_metric, field_name_source, scale) %}
{%- if from_metric == 'KILOGRAM' %}
ROUND({{ field_name_source }}*2.20462 , {{ scale }})
{%- elif from_metric == 'POUND' %}
ROUND({{ field_name_source }}*0.453592 , {{ scale }})
{%- else %}
{{ abort("The metrics specified are not supported. Exception raised by kilogram_and_pound macro.") }}
{%- endif -%}
{% endmacro %}
