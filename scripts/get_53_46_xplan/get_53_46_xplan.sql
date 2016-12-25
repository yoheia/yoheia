/*
 usage: SQL> @53_46_xplan <SCHEMA_NAME> <SQL_ID>
 example: $ ls
          53_46_xplan.sql 64s15h3zs7cq8.sql
          $ sqlplus / as sysdba
          SQL> @get_53_46_xplan ESFDB a5ks9fhw2v9s1
*/

-- set arguments to substitution variables
define target_script='&1'
define target_schema='&2'
define target_sql_id ='&3'
define log_prefix ='&4'
define log_dir ='log'

-- create directory if not exsits
!mkdir -p &log_dir

set time on
set timing on
set pagesize 50000
set linesize 32767
--set termout off
set trimout on
set trimspool on

alter session set current_schema=&target_schema;
alter session set max_dump_file_size=unlimited;
alter session set statistics_level=all;

-- definitation
col cur_hash new_value cur_hash for 999999999999
col cur_addr new_value cur_addr for a100
col spool_file_name new_value spool_file_name for a100
col target_sql_id new_value target_sql_id for a100
col cur_time_stamp new_value cur_time_stamp for a100
col prefix_10053 new_value prefix_10053 for a100
col prefix_10046 new_value prefix_10046 for a100
col prefix_xplan new_value prefix_xplan for a100
col trace_dir new_value trace_dir for a1000

-- get sql_id's hash_value and address
select hash_value cur_hash, address cur_addr from v$sqlarea where sql_id = '&target_sql_id';

-- get current timestamp
select to_char(sysdate,'YYMMDDHH24MISS') cur_time_stamp from dual;

-- 10053
exec sys.dbms_shared_pool.purge('&cur_addr, &cur_hash','C');
select '&log_prefix'||'_'||'&target_sql_id'||'_53_'||'&cur_time_stamp' prefix_10053 from dual;
alter session set tracefile_identifier=&prefix_10053;
select '&log_dir'||'/'||'&prefix_10053'||'.log' spool_file_name from dual;
spool &spool_file_name
alter session set events '10053 trace name context forever,level 1';
@&target_script
alter session set events '10053 trace name context off';
spool off

-- 10046
exec sys.dbms_shared_pool.purge('&cur_addr, &cur_hash','C');
select '&log_prefix'||'_'||'&target_sql_id'||'_46_'||'&cur_time_stamp' prefix_10046 from dual;
alter session set tracefile_identifier=&prefix_10046;
select '&log_dir'||'/'||'&prefix_10046'||'.log' spool_file_name from dual;
spool &spool_file_name
alter session set events '10046 trace name context forever,level 12';
@&target_script
alter session set events '10046 trace name context off';
spool off

-- dbms_xplan.display_cursor
exec sys.dbms_shared_pool.purge('&cur_addr, &cur_hash','C');
select '&log_prefix'||'_'||'&target_sql_id'||'_xp_'||'&cur_time_stamp' prefix_xplan from dual;
select '&log_dir'||'/'||'&prefix_xplan'||'.log' spool_file_name from dual;
spool &spool_file_name
@&target_script
select * from table(dbms_xplan.display_cursor(null,null,'allstats last'));
spool off

select value trace_dir from V$DIAG_INFO where name = 'Diag Trace';

/* collect trace and tkprof */
-- collect trace file
!find &trace_dir -maxdepth 1 -type f -iregex '.*\(&prefix_10046\|&prefix_10053\).*\.trc$' -print0|xargs -0 -I{} cp {} ./&log_dir/
-- tkprof 10046 trace
!find ./&log_dir -maxdepth 1 -type f -iregex '.*&prefix_10046.*\.trc$' -print0|xargs -0 -I{} -n1 tkprof {} {}.tkprof sort=exeela
!find ./&log_dir -maxdepth 1 -type f -iregex '.*\(&prefix_10046\|&prefix_10053\).*\.trc$' -print0|xargs -0 -n1 gzip -f
