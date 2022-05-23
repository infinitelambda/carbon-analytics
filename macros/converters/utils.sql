{% macro abort(error) %}
    {{ None['[ERROR] ' ~ error][0] }}
{% endmacro %}

{% macro metric_identifier(metric) %}
{%- set mile = ['MILE', 'M', 'MI', 'MILES'] -%}
{%- set kilometre = ['KILOMETRE', 'KM', 'KILOMETRES', 'KMETRE', 'KMETRES'] -%}
{%- set litre = ['LITRE', 'LITRES', 'L', 'L.'] -%}
{%- set gallon = ['GALLON', 'GAL', 'GL', 'GAL.', 'GL.'] -%}
{%- set tonne = ['TONNE', 'T', 'T.'] -%}
{%- set kilogram = ['KILOGRAM', 'KILOGRAMS', 'KG', 'KGS', 'KG.'] -%}
{%- set pound = ['POUND', 'POUNDS', 'LB', 'LB.', 'LBS', 'LBS'] -%}
{%- set celcius = ['CELCIUS', 'C', 'C.'] -%}
{%- set fahrenheit = ['FAHRENHEIT', 'F', 'F.'] -%}
{%- set metric_sets = [mile, kilometre, litre, gallon, tonne, kilogram, pound, celcius, fahrenheit] -%}
--strip metric off spaces and symbols
{%- set metric = metric.strip()|upper -%}
{%- set metric_identified = namespace(name=0) -%}
{%- for metric_set in metric_sets -%}
{%- for item in metric_set -%}
  {%- if(item == metric) -%}
    {%- set metric_identified.name = metric_set[0] -%}
  {%- endif -%}
{%- endfor -%}
{%- endfor -%}
{{return(metric_identified.name)}}
{% endmacro %}
