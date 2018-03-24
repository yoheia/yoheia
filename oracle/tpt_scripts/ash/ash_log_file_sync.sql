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
    POWER(2, TRUNC(LOG(2,NULLIF(time_waited,0)))) up_to_microsec
  , COUNT(*)
  , SUM(time_waited)
  , MAX(time_waited)
FROM
    v$active_session_history a
WHERE
    a.event = 'log file sync'
GROUP BY
    POWER(2, TRUNC(LOG(2,NULLIF(time_waited,0)))) 
ORDER BY
    up_to_microsec
/

