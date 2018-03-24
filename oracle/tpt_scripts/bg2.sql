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

select /*+ ordered use_hash(s) */
    b.name
  , b.description
  , s.sid
  , p.pid opid
  , p.spid
  , b.paddr
  , s.saddr
from 
    v$bgprocess b
  , v$process p
  , v$session s
where 
    b.paddr = p.addr
and b.paddr = s.paddr
and p.addr  = s.paddr
and (lower(b.name) like lower('&1') or lower(b.description) like lower('&1'))
/
