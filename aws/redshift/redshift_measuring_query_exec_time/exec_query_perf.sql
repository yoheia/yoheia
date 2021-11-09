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
        from STL_QUERY where query = pg_last_query_id();

\q