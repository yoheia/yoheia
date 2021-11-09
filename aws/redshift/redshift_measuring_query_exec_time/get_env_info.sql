--timing on
\timing on

--pager off
\pset pager

-- result cache off
set enable_result_cache_for_session=off;

-- show Redshift version
select version();

-- show table stats
select * from svv_table_info;

\q