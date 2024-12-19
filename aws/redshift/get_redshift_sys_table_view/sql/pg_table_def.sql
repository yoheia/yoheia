set search_path to '$user', public, shp_wk, shp, sys_calendar, vshp, xse, trv, works, stable, ywh, vdb, dev_shp, members_mstr, settlement, settle_db, dwhlib;
select * from pg_table_def
where schemaname not in ('pg_catalog')
order by schemaname, tablename, sortkey;
