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
-- File name:   kill.sql
-- Purpose:     Generates commands for killing selected sessions
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @kill <filter expression> (example: @kill username='SYSTEM')
-- 	        @kill sid=150
--	        @kill username='SYSTEM'
--              @kill "username='APP' and program like 'sqlplus%'"
--
-- Other:       This script doesnt actually kill any sessions       
--              it just generates the ALTER SYSTEM KILL SESSION
--              commands, the user can select and paste in the selected
--              commands manually
--
--------------------------------------------------------------------------------

select 'alter system kill session '''||sid||','||serial#||''' -- '
       ||username||'@'||machine||' ('||program||');' commands_to_verify_and_run
from v$session
where &1
and sid != (select sid from v$mystat where rownum = 1)
/ 
