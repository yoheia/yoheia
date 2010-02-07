--$Id:$
define owner_name = &owner_name
set pagesize 10000
set linesize 200
set echo off
set termout off
set trimout on
set trimspool on
set feedback off
set serveroutput on size 1000000

col spool_file_name new_value spool_file_name format a100
select 'move_table_and_rebuild_index_'||to_char(sysdate,'YYYYMMDDHH24MISS')||'.log' spool_file_name from dual;
spool &spool_file_name

declare
    cursor cu is select owner, table_name from dba_tables where owner = upper('&&owner_name');
		sql_stmt varchar2(500);
begin
    for rec in cu loop
	      begin
	          sql_stmt := 'alter table "'|| rec.owner ||'"."'||rec.table_name ||'" enable row movement';
            dbms_output.put_line(sql_stmt);
            execute immediate sql_stmt;
        exception when others then
                dbms_output.put_line(rec.owner||'.'||rec.table_name||':[ '|| sqlcode||'] '||sqlerrm);
        end;
	      begin
	          sql_stmt := 'alter table "'|| rec.owner ||'"."'||rec.table_name ||'" move';
            dbms_output.put_line(sql_stmt);
            execute immediate sql_stmt;
        exception when others then
                dbms_output.put_line(rec.owner||'.'||rec.table_name||':[ '|| sqlcode||'] '||sqlerrm);
        end;
				declare
				    cursor cu_indx is select owner, index_name from dba_indexes where table_owner = rec.owner and table_name = rec.table_name;
				begin
				    for rec_indx in cu_indx loop
						   begin
							     sql_stmt := 'alter index "'||rec_indx.owner||'"."'||rec_indx.index_name||'" rebuild compress online';
									 dbms_output.put_line(sql_stmt);
									 execute immediate sql_stmt;
							 exception when others then
							     dbms_output.put_line(rec_indx.owner||'.'||rec_indx.index_name||':[ '|| sqlcode||'] '||sqlerrm);
							 end;
				    end loop;
				end;
    end loop;
end;
/

exit
