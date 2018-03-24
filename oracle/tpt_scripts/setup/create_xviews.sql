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
-- Name:        create_xviews.sql
-- Purpose:     Create views, grants and synonyms for X$ fixed tables 
--              to be accessible for all users
-- Usage:       Run from sqlplus as SYS: @create_xviews.sql
-- 
--
-- Author:      (c) Tanel Poder http://www.tanelpoder.com
-- 
-- Other:       WARNING!!! You probably don't want to create X$ views for all
--              X$ tables in prodution environments!
--              Some X$ tables may be dangerous for your databases performance
--              and stability.
--
--              Also you may have issues with dropping those views after a database
--              upgrade (ORA-600s when dropping them etc)
--              So if you have such views, you should drop them before upgrade
--              and recreate afterwards.
--              
--              This script will not overwrite any existing X_$% SYS objects as
--              those may be required by other performance tools
--
--------------------------------------------------------------------------------

@saveset

set pagesize 0
set linesize 500
set trimspool on
set feedback off
set termout off 
set echo off 


PROMPT Have you read the WARNING section in this scripts header?!
PROMPT Press enter to create views for X$ tables or CTRL+C to cancel...

spool create_xviews.tmp

select 'create view '||replace(name,'X$','X_$')||' as select * from '||name||';' 
from (
    select name from v$fixed_table where name like 'X$%'
    minus
    select replace(object_name,'X_$','X$') from dba_objects where owner = 'SYS' and object_name like 'X\_$%' escape '\' 
);


select 'grant select on SYS.'||replace(name,'X$','X_$')||' to public;'
from (
    select name from v$fixed_table where name like 'X$%'
    minus
    select replace(object_name,'X_$','X$') from dba_objects where owner = 'SYS' and object_name like 'X\_$%' escape '\' 
);

select 'create public synonym '||name||' for SYS.'||replace(name,'X$','X_$')||';' 
from (
    select name from v$fixed_table where name like 'X$%'
    minus
    select replace(object_name,'X_$','X$') from dba_objects where owner = 'SYS' and object_name like 'X\_$%' escape '\' 
);

spool create_xviews.lst

set termout on echo on feedback on

@create_xviews.tmp

host rm create_xviews.tmp
host del create_xviews.tmp

@loadset

prompt Done.
