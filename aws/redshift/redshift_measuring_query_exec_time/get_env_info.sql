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

-- show sort keys
set search_path to '$user', public;
select * from pg_table_def
where sortkey <> 0
and schemaname  not in ('pg_catalog')
order by schemaname, tablename, sortkey;

\q
