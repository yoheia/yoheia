--$Id:$
set pagesize 10000
set linesize 200
set echo off
set termout off
set trimout on
set trimspool on
set feedback off

col segment_name for a50
col MB for 99999999
col extents for 99999999
col spool_file_name new_value spool_file_name format a100

set serveroutput on size 1000000

select username || to_char(sysdate,'_YYYYMMDDHH24MISS') || '.log' spool_file_name from user_users;
spool &spool_file_name

--Deallocate unused space of current user's segments.
declare
        cursor cu is select
                segment_name, segment_type from user_segments
                        where (segment_type = 'TABLE' or segment_type = 'INDEX' or segment_type = 'CLUSTER') 
                        and bytes > 65536;
        sql_stmt varchar2(500);
begin
  for rec in cu loop
                declare
                begin
                        sql_stmt := 'alter '|| rec.segment_type ||' "'||rec.segment_name ||'" deallocate unused keep 1';
--                      dbms_output.put_line(sql_stmt);
                        execute immediate sql_stmt;
                exception
                        when others then
                         dbms_output.put_line(rec.segment_name||'('||rec.segment_type||'):[ '|| sqlcode||']'||sqlerrm);
                end;
  end loop;
end;
/

--Display current user's segment list.

select segment_name, bytes/1024/1024 MB, extents
        from user_segments
        order by bytes desc;
spool off

exit
