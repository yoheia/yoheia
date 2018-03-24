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

col u_username head USERNAME for a23
col u_sid head SID for a14 
col u_audsid head AUDSID for 9999999999
col u_osuser head OSUSER for a16
col u_machine head MACHINE for a25 truncate
col u_program head PROGRAM for a20

select s.username u_username, ' ''' || s.sid || ',' || s.serial# || '''' u_sid, 
       s.audsid u_audsid,
       s.osuser u_osuser, 
       substr(s.machine,instr(s.machine,'\')) u_machine, 
       substr(s.program,instr(s.program,'(')) u_program, 
       p.spid, 
       -- s.sql_address, 
       s.sql_id, --s.sql_hash_value, 
       s.last_call_et lastcall, 
       s.status 
       --, s.logon_time
from 
    v$session s,
    v$process p
where
    s.paddr=p.addr
--and s.type!='BACKGROUND'
and lower(s.username) like lower('&1')
--and s.status='ACTIVE'
/

