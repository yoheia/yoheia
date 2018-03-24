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

prompt
prompt Generating the compile commands into compileall_out.sql...

set head off pages 0 lines 200 feed off trimspool on termout off

spool compileall_out.sql

select 
    'alter '||decode(object_type, 'PACKAGE BODY', 'PACKAGE', object_type)||' '
    ||owner||'.'||object_name||' compile'||
    decode(object_type, 'PACKAGE BODY', ' BODY;', ';') 
from 
    dba_objects 
where 
    object_type in ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TRIGGER');

spool off

set termout on

prompt Done.
prompt Now review the compileall_out.sql and execute it as SYS.
prompt Press enter to continue...
pause
