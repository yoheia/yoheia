set echo off
set heading off
set pagesize 0
set linesize 10000
set trimout on
set trimspool on
set feedback off

set serveroutput on size 1000000

col spool_file_name new_value spool_file_name for a100
select 'log/outline2spm_'|| to_char(sysdate,'YYYYMMDD-HH24MISS') || '.log' spool_file_name from dual;
spool &spool_file_name

declare
	cursor cu is select sql_id, plan_hash_value, sql_text 
					from v$sql 
						where last_active_time between (sysdate - (5/24/60)) and sysdate;
	cnt number(20);
	num_of_plans number(20);
begin
	cnt := 0;
	for rec in cu loop
		begin
			num_of_plans := dbms_spm.load_plans_from_cursor_cache (
				sql_id => rec.sql_id, 
				plan_hash_value => rec.plan_hash_value
			);
			dbms_output.put_line(
				'plans are loaded ( sql_id:'||rec.sql_id||
				', plan_hash_value:'||rec.plan_hash_value||
				', number of plans loaded:'||num_of_plans||
				', sql_text:'||substr(rec.sql_text,1,30)||
				')'
			);
			if ( num_of_plans > 0 ) then
				cnt := cnt + num_of_plans;
			end if;
		exception when others then
			dbms_output.put_line(
				'failed ( sql_id:'||rec.sql_id||
				', plan_hash_value:'||rec.plan_hash_value||
				', number of plans loaded:'||num_of_plans||
				', sqlcode:'||sqlcode||
				' ,sqlerrm'||sqlerrm||')'
			);
		end;
	end loop;
	dbms_output.put_line(cnt||' plans have been loaded.');
end;
/

/*
select count(sql_handle) from dba_sql_plan_baselines;
*/

spool off

