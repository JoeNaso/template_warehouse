select
    special_id,
    thing,
    some_date
from {{ ref('source_table_src') }}