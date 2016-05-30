set time on
set timing on
set pagesize 50000
set linesize 250
--set termout off
set trimout on
set trimspool on

alter session set current_schema=SYS;
alter session set max_dump_file_size=unlimited;
alter session set timed_statistics=true;
alter session set statistics_level=all;

-- definitation
col cur_hash new_value cur_hash for a100
col cur_addr new_value cur_addr for a100
col spool_file_name new_value spool_file_name for a100
col diag_trace_dir new_value diag_trace_dir for a500

-- get sql_id's hash_value and address
select hash_value cur_hash, address cur_addr from v$sqlarea where sql_id = 'a5ks9fhw2v9s1';

-- 10053
exec sys.dbms_shared_pool.purge('&cur_addr, &cur_hash','C');
alter session set tracefile_identifier='TARGET_10053';
select 'TARGET_10053_'||to_char(sysdate,'YYYY-MM-DD-HH24MISS')||'.log' spool_file_name from dual;
spool &spool_file_name
alter session set events '10053 trace name context forever,level 1';
@EXEC_SQL.sql
alter session set events '10053 trace name context off';
spool off

-- 10046
exec sys.dbms_shared_pool.purge('&cur_addr, &cur_hash','C');
alter session set tracefile_identifier='TARGET_10046';
select 'TARGET_10046_'||to_char(sysdate,'YYYY-MM-DD-HH24MISS')||'.log' spool_file_name from dual;
spool &spool_file_name
alter session set events '10046 trace name context forever,level 12';
@EXEC_SQL.sql
alter session set events '10046 trace name context off';
spool off

-- dbms_xplan.display_cursor
exec sys.dbms_shared_pool.purge('&cur_addr, &cur_hash','C');
set lines 1000
select 'TARGET_xplan_'||to_char(sysdate,'YYYY-MM-DD-HH24MISS')||'.log' spool_file_name from dual;
spool &spool_file_name
@EXEC_SQL.sql
select * from table(dbms_xplan.display_cursor(null,null,'allstats last'));
spool off


/* collect trace and tkprof */
-- collect trace file
!find /u01/app/oracle/diag/rdbms/orcl/orcl1/trace -maxdepth 1 -type f -name '*TARGET_*.trc' -mmin -30 -print0|xargs -0 -I{} cp {} ./
-- tkprof 10046 trace
!find . -maxdepth 1 -type f -name '*TARGET_10046*.trc' -mmin -5 -print0|xargs -0 -I{} -n1 tkprof {} {}.tkprof sort=exeela
!find . -maxdepth 1 -type f -name '*TARGET_*.trc' -print0|xargs -0 -n1 gzip -f