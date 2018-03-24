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

SELECT 
    s1.event
  , s1.blocking_session
  , s1.blocking_session_Status
  , s1.final_blocking_session
  , s1.final_blocking_session_status
  , s2.state
  , s2.event 
FROM 
    v$session s1
  , v$session s2 
WHERE 
    s1.state = 'WAITING' 
AND s1.event = 'enq: HV - contention'
AND s1.final_blocking_session = s2.sid
/

