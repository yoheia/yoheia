set pagesize 50000
set linesize 200

select min(object_owner), object_name, object_type, hash_value
from v$sql_plan
where object_owner = upper('&object_owner') and object_type like 'INDEX%'
group by object_name, object_type, hash_value
order by 1,2;
