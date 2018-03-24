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

DEF filter=&1

PROMPT What's going on? Showing top timed events of last minute from ASH...
@ashtop session_state,event &filter sysdate-1/24/60 sysdate

PROMPT Showing top SQL and wait classes of last minute from ASH...
@ashtop sql_id,session_state,wait_class &filter sysdate-1/24/60 sysdate

