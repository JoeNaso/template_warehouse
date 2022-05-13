-- A super simple modeling pattern. The only stuff you do here is rename and cast types

select
    id as special_id,
    thing,
    some_datetime::DATE AS some_date
from {{ source('source', 'table_name') }}
