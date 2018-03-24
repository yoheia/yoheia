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

set lines 300 trimspool on pages 0 head off feedback off termout off

SELECT DISTINCT name FROM (
    select lower(keyword) name from v$reserved_words union all
    select upper(table_name) from dict union all
    select upper(column_name) from dict_columns union all
    -- select object_name from dba_objects union all
    select upper(object_name||'.'||procedure_name) from dba_procedures union all
    -- select '"'||table_name||'".'||column_name from dba_tab_columns union all
    select ksppinm from x$ksppi union all
    select name from v$sql_hint
)
WHERE length(name) > 2
ORDER BY 1
.

spool wordfile_11gR2.txt
/
spool off


-- you can also add TPT scripts by running this in TPT script dir:
-- find . -type f -name "*.sql" | sed 's/^\.\///' | awk '{ print "@" $1 }' >> ~/work/oracle/wordfile_11gR2.txt
-- or you could just run rlwrap sqlplus being in the directory where the scripts are located!!
