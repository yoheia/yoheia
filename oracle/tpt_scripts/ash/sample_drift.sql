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

-- check if there's sample time drift in ASH (should be every 1 seconds)
-- it makes sense to run this only on active systems where every sample there
-- are some active sessions seen

select to_char(sample_time,'YYYYMMDD HH24:MI'), sample_time-lag(sample_time) over(order by sample_time) 
from (select distinct sample_time from v$active_session_history)
/


