------------------------------------------------------------------------------
--
-- Copyright 2017 Tanel Poder ( tanel@tanelpoder.com | http://tanelpoder.com )
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
------------------------------------------------------------------------------

prompt dbms_sqltune.create_tuning_task(task_name=>'SQLTT_&1', sql_id=>'&1', time_limit=>&2)

var c_tt refcursor

DECLARE
    r CLOB;
    --r varchar2(32767);
    t varchar2(30) := 'SQLTT_&1';
BEGIN

    begin
        dbms_sqltune.drop_tuning_task(t);
    exception
        when others then null;
    end;
    
    r := dbms_sqltune.create_tuning_task(task_name=>t, sql_id=>'&1', time_limit=>&2);
    dbms_output.put_line('r='||r);
    
    dbms_sqltune.execute_tuning_task(t);

    open :c_tt for
        select dbms_sqltune.report_tuning_task(t) recommendations from dual;

END;
/

spool &_tpt_tempdir/sqltune_ctt_&_tpt_tempfile..sql
print :c_tt
spool off
prompt Output file: &_tpt_tempdir/sqltune_ctt_&_tpt_tempfile..sql
host &_start &_tpt_tempdir/sqltune_ctt_&_tpt_tempfile..sql

