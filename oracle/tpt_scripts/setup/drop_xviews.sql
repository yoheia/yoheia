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

--------------------------------------------------------------------------------
--
-- Name:        drop_xviews.sql
-- Purpose:     Drop custom views, grants and synonyms for X$ fixed tables 
-- Usage:       Run from sqlplus as SYS: @drop_xviews.sql
-- 
--
-- Author:      (c) Tanel Poder http://www.tanelpoder.com
-- 
-- Other:       Note that this script only generatesd drop commands for manual 
--		execution. Make sure that you don't drop any X$ tables required 
--		by other software like StatsPack and monitoring tools
--
--------------------------------------------------------------------------------

@saveset

set pagesize 0
set linesize 200
set trimspool on
set feedback off

Prompt Generating drop script...

spool drop_xviews.tmp

set termout off

select 'drop view '||object_name||';' 
from (
    select object_name 
    from dba_objects 
    where owner = 'SYS' 
    and object_name like 'X\_$%' escape '\' 
);

select 'drop public synonym '||synonym_name||';' 
from (
    select synonym_name 
    from dba_synonyms 
    where owner = 'PUBLIC' 
    and synonym_name like 'X$%' 
);

spool off

set termout on

Prompt Done generating drop script.
Prompt Now review and manually execute the file drop_xviews.tmp using @drop_xviews.tmp
Prompt

@loadset
