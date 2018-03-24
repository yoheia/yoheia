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

col fgran_component for a20

select
    t.component fgran_component
  , g.*
from 
    x$ksmge  g
  , x$kmgsct t
where 
    g.grantype = t.grantype
and
    to_number(substr('&1', instr(lower('&1'), 'x')+1) ,lpad('X',vsize(g.addr)*2,'X')) 
    between 
        to_number(g.baseaddr,lpad('X',vsize(g.addr)*2,'X'))
    and to_number(g.baseaddr,lpad('X',vsize(g.addr)*2,'X')) + g.gransize - 1
/
