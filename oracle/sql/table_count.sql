----$Id:$
set echo off
set heading off
set pagesize 0
set linesize 10000
set trimout on
set trimspool on
set feedback off

set serveroutput on size 1000000

col spool_file_name new_value spool_file_name for a100
select lower(username)||'_table_count_'|| to_char(sysdate,'YYYYMMDDHH24MISS') || '.csv' spool_file_name from user_users;

spool &spool_file_name
declare
	cursor cu is select segment_name from user_segments where segment_type = 'TABLE' order by segment_name;
	sql_stmt varchar2(200);
	cnt number(20);
begin
	for rec in cu loop
		begin
			sql_stmt := 'select count(1) from '||rec.segment_name;
			execute immediate sql_stmt into cnt;
			dbms_output.put_line(rec.segment_name||','||cnt);
		exception when others then
			dbms_output.put_line(rec.segment_name||','||cnt||':'||sqlcode||':'||sqlerrm);
		end;
	end loop;
end;
/
spool off

exit

