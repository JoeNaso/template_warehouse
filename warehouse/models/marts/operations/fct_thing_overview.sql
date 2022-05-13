/*
    These are business-friendly tables 
    They might include aggregates or timeseries data
    They often can be pretty complex
    Since this level will often have many dependencies, your goal should be to maintain a relatively flat structure, meaning a rebuild of a table at this level does not require many levels of aggregates below it
    If you have a large number of complex transformation powering this level in the hierarchy, you will wind up with long build times. 
    Ping me if you want concrete examples or if you're interested in understanding how this might apply to your data structure.   
*/

with agg as (
    select
        special_id,
        some_date,
        count(distinct another_thing) as number_of_things
    from {{ ref('source_table_xf') }}
    group by 1, 2
)

select
    special_id,
    some_date,
    number_of_things
from agg