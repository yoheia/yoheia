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
-- Author:	Tanel Poder
-- Copyright:	(c) http://www.tanelpoder.com
-- 
-- Notes:	This software is provided AS IS and doesn't guarantee anything
-- 		Proofread before you execute it!
--
--------------------------------------------------------------------------------

prompt 
prompt Dropping roles...
prompt

drop role sesspack_admin_role;
drop role sesspack_user_role;

prompt
prompt Ready to revoke SAWR privileges from user &spuser
prompt The following commands will be run:
prompt 

prompt revoke select on sys.v_$session from &spuser;
prompt revoke select on sys.v_$session_wait from &spuser;
prompt revoke select on sys.v_$session_event from &spuser;
prompt revoke select on sys.v_$sess_time_model from &spuser;
prompt revoke select on sys.v_$sesstat from &spuser;
prompt revoke select on sys.v_$event_name from &spuser;
prompt revoke select on sys.v_$statname from &spuser;

prompt
pause Press CTRL-C if you don't want to run those commands, otherwise press ENTER...
prompt

revoke select on sys.v_$session from &spuser;
revoke select on sys.v_$session_wait from &spuser;
revoke select on sys.v_$session_event from &spuser;
revoke select on sys.v_$sess_time_model from &spuser;
revoke select on sys.v_$sesstat from &spuser;
revoke select on sys.v_$event_name from &spuser;
revoke select on sys.v_$statname from &spuser;

whenever sqlerror continue
