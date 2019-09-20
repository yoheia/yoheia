set pagesize 10000
set linesize 200
col sql_id for a13
col sql_text for a60
col min_sample_time for a19
col max_sample_time for a19
col program for a40
col module for a20
col user for a10

alter session set NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT='YYYY/MM/DD HH24:MI:SS';

select a.sql_id,
    min(dbms_lob.substr(b.sql_text,60,1)) sql_text,
    round(sum(a.delta_write_io_bytes) / 1024 / 1024, 1) "WRITE_IO(MB)",
    min(a.user_id) user_id,
    min(a.program) program,
    min(a.module) module,
    min(a.sample_time) min_sample_time,
    max(a.sample_time) max_sample_time
from dba_hist_active_sess_history a,
    dba_hist_sqltext b
where a.dbid = b.dbid
    and a.sql_id = b.sql_id
    and sql_opcode in (2, 6, 7, 47)
    and a.sample_time between to_timestamp('2019-08-01 21:00:00', 'YYYY/MM/DD HH24:MI:SS')
        and to_timestamp('2019-08-02 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
    and a.delta_write_io_bytes is not null
group by a.sql_id
order by 3 desc;
