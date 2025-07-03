{#

{% set my_cool_string = 'wow, cool' %}. -- This is a string

{{ my_cool_string }}

#}

{#

{% set my_animals = ['dog', 'cat', 'bunny']%} -- This is a list

{{ my_animals}}
{{ my_animals[1]}}

{% for animal in my_animals %}

    my fav animal is {{animal}}

{% endfor%}

#}

{#
{% for i in range(10)  %}

    select {{ i }} as number {% if not loop.last %} union all {% endif %}

{% endfor %}
#}
{#
{% set temp = 45 %}

{% if temp < 65%}
    Time for a coffee!
{% else %}
    Time for a cold brew!
{% endif %}
#}
{#
{%- set foods = ['carrot', 'hotdog', 'cucumber', 'bellpepper'] -%}
{% for food in foods %}

    {%- if food == 'hotdog '-%}
        {%- set food_type = 'snack'-%}
    {%- else -%}
        {%- set food_type = 'veggie'-%}
    {%- endif -%}

    The humble {{ food }} is my fav {{ food_type }}

{% endfor%}
#}

{% set websters_dict = {
    'word': 'data',
    'speech_part': 'noun',
    'definition': 'if you know , you know'
} -%} -- this is a dictionary

{{ websters_dict}}
{{ websters_dict['word']}} ({{websters_dict['speech_part']}}) : defined as - {{ websters_dict['definition']}}





