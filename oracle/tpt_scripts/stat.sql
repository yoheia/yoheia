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
-- File name:   stat.sql
-- Purpose:     Execute SQL statement in script argument and report basic
--              execution statistics
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @stat "<SQL>"
-- 	        @stat "select * from dual"
--              @stat "create table t as select * from all_objects"
--	        
--------------------------------------------------------------------------------


set termout off
exec dbms_Session.set_identifier(user||':'||sys_context('userenv', 'sessionid'));
exec dbms_monitor.client_id_stat_enable(user||':'||sys_context('userenv', 'sessionid'));
set termout on

clear buffer
1 &2
/

select 
   stat_name
 , CASE stat_name
   WHEN 'user calls'                THEN value - 2    -- substract @stat scripts overhead
   WHEN 'execute count'             THEN value - 1
   WHEN 'parse count (total)'       THEN value - 1
   WHEN 'opened cursors cumulative' THEN value - 1
   ELSE value
   END value
from v$client_stats 
where client_identifier = user||':'||sys_context('userenv', 'sessionid') 
and lower(stat_name) like '%&1%';

set termout off
exec dbms_monitor.client_id_stat_disable(user||':'||sys_context('userenv', 'sessionid'));
exec dbms_Session.clear_identifier;
set termout on
