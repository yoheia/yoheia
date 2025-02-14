
--timing on
\timing on

--pager off
\pset pager

-- result cache off
set enable_result_cache_for_session=off;

-- show Redshift version
\o csv/all/:current_date/VERSION.csv
select version();

\o csv/all/:current_date/STV_WLM_SERVICE_CLASS_CONFIG.csv
select * from STV_WLM_SERVICE_CLASS_CONFIG;

\o csv/all/:current_date/PG_USER.csv
select * from PG_USER;

\o csv/all/:current_date/PG_GROUP.csv
select * from PG_GROUP;

-- execution time
\o csv/all/:current_date/STL_QUERY.csv
select userid,
		trim(database) "database",
		trim(label) as label,
		query,
		xid,
		pid,
		datediff(milliseconds, starttime, endtime) as "exec_time(ms)",
		starttime,
		endtime,
		aborted,
		insert_pristine,
		concurrency_scaling_status,
		trim(querytxt) as query_text
	from STL_QUERY
	order by query;

-- show execution plan
\o csv/all/:current_date/SVL_QUERY_SUMMARY.csv
select query,
		stm, 
		seg, 
		step,
		maxtime,
		avgtime,
		rows,
		bytes,
		lpad(' ',stm+seg+step) || label as label,
		is_diskbased,
		workmem,
		is_rrscan,
		is_delayed_scan,
		rows_pre_filter
	from svl_query_summary
	order by query, stm, seg, step;

-- SVL_QUERY_METRICS
\o csv/all/:current_date/SVL_QUERY_METRICS.csv
select * from SVL_QUERY_METRICS order by query, dimension, segment, step;

-- STL_WLM_QUERY
\o csv/all/:current_date/STL_WLM_QUERY.csv
select * from STL_WLM_QUERY order by service_class, query;

-- SVL_QUERY_METRICS_SUMMARY
\o csv/all/:current_date/SVL_QUERY_METRICS_SUMMARY.csv
select * from SVL_QUERY_METRICS_SUMMARY order by query;

-- SVL_QUERY_SUMMARY
\o csv/all/:current_date/SVL_QUERY_SUMMARY.csv
select * from SVL_QUERY_SUMMARY order by query, stm, seg, step;

-- SYS_QUERY_HISTORY
\o csv/all/:current_date/SYS_QUERY_HISTORY.csv
select * from SYS_QUERY_HISTORY order by query_id;

-- SYS_QUERY_DETAIL, SYS_QUERY_EXPLAIN
\o csv/all/:current_date/SYS_QUERY_DETAIL_SYS_QUERY_EXPLAIN.csv
select a.*, b.* from sys_query_detail a, sys_query_explain b, sys_query_history c
	where  a.query_id = b.query_id
		and b.plan_node_id = a.plan_node_id
		and a.query_id = c.query_id
order by a.query_id, a.stream_id, a.segment_id, a.step_id;

-- SVV_TABLE_INFO
\o csv/all/:current_date/SVV_TABLE_INFO.csv
select * from svv_table_info order by "schema", "table";

-- PG_TABLE_DEF
\o csv/all/:current_date/PG_TABLE_DEF.csv
set search_path to '$user', public;
select * from pg_table_def
where schemaname not in ('pg_catalog')
order by schemaname, tablename, sortkey;

-- SYS_QUERY_DETAIL
\o csv/all/:current_date/SYS_QUERY_DETAIL.csv
select * from SYS_QUERY_DETAIL order by query_id, child_query_sequence, stream_id, segment_id, step_id;

-- SVL_QUERY_REPORT
\o csv/all/:current_date/SVL_QUERY_REPORT.csv
select * from SVL_QUERY_REPORT order by query, segment, step, slice;

\q
