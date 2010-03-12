define user_name = &user_name

set heading off
set pagesize 0
set linesize 10000
set trimout on
set trimspool on
set feedback off

set serveroutput on size 1000000

declare
	cursor cu is select sid, serial#, username, machine, osuser, program, status from v$session where username = upper('&&user_name');
	sql_stmt varchar2(200);
begin
	for rec in cu loop
		begin
			sql_stmt := 'alter system kill session '''||rec.sid||','||rec.serial#||'''';
			dbms_output.put_line(rec.sid||', '||rec.serial#||', '||rec.username||', '||rec.machine||', '||rec.osuser||', '||rec.program||', '||rec.status);
			execute immediate sql_stmt;
		exception when others then
			dbms_output.put_line(rec.sid||','||rec.serial#||':'||sqlcode||':'||sqlerrm);
		end;
	end loop;
end;
/

exit