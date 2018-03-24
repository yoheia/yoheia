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

col se_time_waited head TIME_WAITED for 99999999.90
col se_sid head SID for 999999
col se_event head EVENT for a40 truncate

break on se_sid skip 1

select * from (
    select sid se_sid, event se_event, time_waited/100 se_time_waited, total_waits, total_timeouts, average_wait/100 average_wait, max_wait/100 max_wait
    from v$session_event 
    where sid in (&1)
    union all
    select sid, 'CPU Time', value/100, cast(null as number), cast(null as number), cast(null as number), cast(null as number)
    from v$sesstat
    where sid in (&1)
    and statistic# = (select statistic# from v$statname where name =('CPU used by this session'))
)
order by se_sid, se_time_waited desc, total_waits desc;
