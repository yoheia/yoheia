--timing on
\timing on

--pager off
\pset pager

-- result cache off
set enable_result_cache_for_session=off;

-- show Redshift version
select version();

-- set transaction_id to variable
select xid from stl_query where query = :query_id;
\gset

-- execution time
\o csv/:query_id/STL_QUERY.csv
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
	from STL_QUERY where query = :query_id;

-- show execution plan
\o csv/:query_id/SVL_QUERY_SUMMARY.csv
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
		where query = :query_id
		order by stm, seg, step;

-- SVL_QUERY_METRICS
\o csv/:query_id/SVL_QUERY_METRICS.csv
select * from SVL_QUERY_METRICS where query = :query_id order by query;

-- STL_WLM_QUERY
\o csv/:query_id/STL_WLM_QUERY.csv
select * from STL_WLM_QUERY where query = :query_id order by service_class;

-- SVL_QUERY_METRICS_SUMMARY
\o csv/:query_id/SVL_QUERY_METRICS_SUMMARY.csv
select * from SVL_QUERY_METRICS_SUMMARY where query = :query_id;

-- SVL_QUERY_METRICS
\o csv/:query_id/SVL_QUERY_METRICS.csv
select * from SVL_QUERY_METRICS where query = :query_id
order by userid, query, dimension;

-- SVL_QUERY_SUMMARY
\o csv/:query_id/SVL_QUERY_SUMMARY.csv
select * from SVL_QUERY_SUMMARY where query = :query_id;

-- SYS_QUERY_HISTORY
\o csv/:query_id/SYS_QUERY_HISTORY.csv
select * from SYS_QUERY_HISTORY where transaction_id = :xid;

-- SYS_QUERY_DETAIL, SYS_QUERY_EXPLAIN
\o csv/:query_id/SYS_QUERY_DETAIL_SYS_QUERY_EXPLAIN.csv
select a.*, b.* from sys_query_detail a, sys_query_explain b, sys_query_history c
	where  a.query_id = b.query_id
		and b.plan_node_id = a.plan_node_id
		and a.query_id = c.query_id
		and c.transaction_id = :xid;
order by a.query_id, a.stream_id, a.segment_id, a.step_id;

-- SVV_TABLE_INFO
\o csv/:query_id/SVV_TABLE_INFO.csv
select * from svv_table_info order by "schema", "table";

-- PG_TABLE_DEF
\o csv/:query_id/PG_TABLE_DEF.csv
set search_path to '$user', public;
select * from pg_table_def
where schemaname not in ('pg_catalog')
order by schemaname, tablename, sortkey;

-- SVL_QUERY_REPORT
\o csv/:query_id/SVL_QUERY_REPORT.csv
select * from SVL_QUERY_REPORT where query = :query_id order by segment, step, slice;

\q
