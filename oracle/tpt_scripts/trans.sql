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

col 0xFLAG just right


select
    s.sid
  , s.serial#
  , s.username
  , t.addr taddr
  , s.saddr ses_addr
  , t.used_ublk
  , t.used_urec
--  , t.start_time
  , to_char(t.flag, 'XXXXXXXX') "0xFLAG"
  , t.status||CASE WHEN BITAND(t.flag,128) = 128 THEN ' ROLLING BACK' END status
  , t.start_date
  , XIDUSN 
  , XIDSLOT
  , XIDSQN
  , t.xid
  , t.prv_xid
  , t.ptx_xid
from
    v$session s
  , v$transaction t
where
    s.saddr = t.ses_addr
/


