-- Combine and transform models here. This is a toy example
with special as (
    select 
        special_id,
        thing_id,
        some_date
    from {{ ref('source_table') }}
),

another as (
    select
        id,
        another_thing
    from {{ ref('another_source_table') }}
)

select
    special_id,
    thing_id,
    another_thing,
    some_date
from special
join another 
    on special.thing_id = another.id
