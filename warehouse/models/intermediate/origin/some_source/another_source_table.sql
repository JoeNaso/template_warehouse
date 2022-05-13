
select
    id,
    another_thing
from {{ source('source', 'another_source_table') }}
