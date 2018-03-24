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


-- grants for procs & types
grant execute on sesspack to sesspack_user_role;
grant execute on sawr$sidlist to sesspack_user_role;

-- grants for sequences
grant select on sawr$snapid_seq to sesspack_user_role;

-- grants for tables
grant select, insert on sawr$snapshots 		to sesspack_user_role;
grant select, insert on sawr$sessions 		to sesspack_user_role;
grant select, insert on sawr$session_events 	to sesspack_user_role;
grant select, insert on sawr$session_stats 	to sesspack_user_role;
grant select         on sawr$session_stat_mode 	to sesspack_user_role;

-- grants for views
grant select on sawr$sess_event to sesspack_user_role;
--grant select on sawr$sess_event_delta to sesspack_user_role;
grant select on sawr$sess_stat to sesspack_user_role;

-- synonyms for procs & types
create public synonym sesspack for sesspack;
create public synonym sawr$sidlist for sawr$sidlist;

-- synonyms for sequences
create public synonym sawr$snapid_seq for sawr$snapid_seq;

-- synonyms for tables
create public synonym sawr$snapshots for sawr$snapshots;
create public synonym sawr$sessions for sawr$sessions;
create public synonym sawr$session_events for sawr$session_events;
create public synonym sawr$session_stats for sawr$session_stats;
create public synonym sawr$session_stat_mode for sawr$session_stat_mode;

-- synonyms for views
create public synonym sawr$sess_event for sawr$sess_event;
--create public synonym sawr$sess_event_delta for sawr$sess_event_delta;
create public synonym sawr$sess_stat for sawr$sess_stat;

