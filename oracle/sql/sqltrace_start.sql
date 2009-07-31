/*
$Id:$
usage: sqlplus "/ as sysdba" @sqltrace_start.sql
*/

set pagesize 10000
set linesize 10000
set trimout on
set trimspool on

set serveroutput on size 1000000

declare
	cursor cu is select sid, serial# from v$session where username is not null;
begin
	for rec in cu loop
		begin
			dbms_system.set_sql_trace_in_session(rec.sid,rec.serial#,true);
			dbms_system.set_ev(rec.sid,rec.serial#,10046,12,'');
		exception
			when others then
			dbms_output.put_line('sid:'||rec.sid||' serial#:'||rec.serial#||' sqlcode:'|| sqlcode||' sqlerrm:'||sqlerrm);
		end;
	end loop;
end;
/
exit
