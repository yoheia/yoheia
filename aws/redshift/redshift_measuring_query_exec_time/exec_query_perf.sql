--current timestamp (UTC)
select getdate();

--timing on
\timing on

--pager off
\pset pager

-- result cache off
set enable_result_cache_for_session=off;

-- execute target query
\i lineorder_count.sql

-- query id
select pg_last_query_id();
\gset

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
        from STL_QUERY where query = :pg_last_query_id;

-- show execution plan
select query,
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
where query = :pg_last_query_id
order by stm, seg, step;

-- STL_EXPLAIN
select query,
        nodeid,
        parentid,
        plannode,
        info
from stl_explain
where query = :pg_last_query_id
order by 1,2;

-- STL_WLM_QUERY
select * from STL_WLM_QUERY
where query = :pg_last_query_id
order by service_class;

-- SVL_QUERY_REPORT
select * from SVL_QUERY_REPORT
where query = :pg_last_query_id
order by segment, step, slice;

\q
