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
-- File name:   ses.sql (SEssion Statistics)
-- Purpose:     Display Session statistics for given sessions, filter by
--              statistic name
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @ses <sid> <statname>
--              @ses 10 %
--              @ses 10 parse
--              @ses 10,11,12 redo
--              @ses "select sid from v$session where username = 'APPS'" parse
--          
--------------------------------------------------------------------------------

select 
    ses.sid,
    sn.name, 
    ses.value
from
    v$sesstat ses,
    v$statname sn
where
    sn.statistic# = ses.statistic#
and ses.sid in (&1)
and lower(sn.name) like lower('%&2%')
/
