{% macro volume_converter(from_metric, to_metric, field_name_source, scale) %}
{%- set scale = scale|default(2) %}
{%- set from_metric -%}
{{metric_identifier(from_metric)}}
{%- endset -%}
{%- set to_metric -%}
{{metric_identifier(to_metric)}}
{%- endset -%}
{%- if from_metric == 'LITRE' and to_metric == 'GALLON' %}
{{litre_and_gallon(from_metric, field_name_source, scale)}}
{%- elif from_metric == 'GALLON' and to_metric == 'LITRE' %}
{{litre_and_gallon(from_metric, field_name_source, scale)}}
{%- else %}
{{ abort("The metrics specified are not supported. Exception raised by volume_converter macro.") }}
{%- endif -%}
{% endmacro %}


{% macro litre_and_gallon(from_metric, field_name_source, scale) %}
{%- if from_metric == 'LITRE' %}
ROUND({{ field_name_source }}*0.219969 , {{ scale }})
{%- elif from_metric == 'GALLON' %}
ROUND({{ field_name_source }}*4.54609 , {{ scale }})
{%- else %}
{{ abort("The metrics specified are not supported. Exception raised by litre_and_gallon macro.") }}
{%- endif -%}
{% endmacro %}
