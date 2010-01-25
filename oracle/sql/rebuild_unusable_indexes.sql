----$Id:$
define owner_name = &owner_name

set echo off
set heading off
set pagesize 0
set linesize 10000
set trimout on
set trimspool on
set feedback off

set serveroutput on size 1000000

col spool_file_name new_value spool_file_name for a100
select 'rebuild_unusable_indexes_'||lower('&&owner_name')||'_'||to_char(sysdate,'YYYYMMDDHH24MISS')||'.log' spool_file_name from dual;

spool &spool_file_name
declare
	cursor cu is select owner, index_name from dba_indexes where owner = upper('&&owner_name');
	sql_stmt varchar2(200);
begin
	for rec in cu loop
		begin
				sql_stmt := 'alter index "'||rec.owner||'.'||rec.index_name||'" rebuild online';
					      dbms_output.put_line(rec.owner||'.'||rec.index_name||':'||sqlcode||':'||sqlerrm);
				execute immediate sql_stmt;
		exception when others then
	      dbms_output.put_line(rec.owner||'.'||rec.index_name||':'||sqlcode||':'||sqlerrm);
		end;
	end loop;
end;
/
spool off

exit

