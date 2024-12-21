set search_path to '$user', public;
select * from pg_table_def
where schemaname not in ('pg_catalog')
order by schemaname, tablename, sortkey;
