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

col u_username for a20
col u_sid for a12 
col u_osuser for a12
col u_machine for a18
col u_program for a20

select s.username u_username, ' ''' || s.sid || ',' || s.serial# || '''' u_sid, 
       s.osuser u_osuser, substr(s.machine,instr(s.machine,'\')) u_machine, 
       substr(s.program,1,20) u_program,
       p.spid, s.sql_address, s.sql_hash_value, s.last_call_et lastcall, s.status
from 
    v$session s,
    v$process p
where
    s.paddr=p.addr
and s.type!='BACKGROUND'
and s.username is not null
--and s.status='ACTIVE'
/

exit
