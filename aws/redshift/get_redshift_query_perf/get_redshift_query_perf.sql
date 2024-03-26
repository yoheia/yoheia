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

-- execution time
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
select * from SVL_QUERY_METRICS where query = :query_id order by query;

-- STL_WLM_QUERY
select * from STL_WLM_QUERY where query = :query_id order by service_class;

-- SVL_QUERY_METRICS_SUMMARY
select * from SVL_QUERY_METRICS_SUMMARY where query = :query_id;

-- SVL_QUERY_METRICS
select * from SVL_QUERY_METRICS where query = :query_id;

-- SVL_QUERY_SUMMARY
select * from SVL_QUERY_SUMMARY where query = :query_id;

-- SVL_QUERY_REPORT
select * from SVL_QUERY_REPORT where query = :query_id;

-- SYS_QUERY_HISTORY
select * from SYS_QUERY_HISTORY where query_id = :query_id;

-- SVL_QUERY_REPORT
select * from SVL_QUERY_REPORT where query = :query_id order by segment, step, slice;

\q
