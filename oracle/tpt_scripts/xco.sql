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

column xco_kqfcoidx heading IX format 99
column xco_name heading TABLE_NAME format a30 wrap
column xco_kqfconam heading COLUMN_NAME format a30 wrap

break on xco_name

select 
    t.name xco_name, c.kqfconam xco_kqfconam, c.kqfcodty, c.kqfcosiz, c.kqfcooff, 
    to_number(decode(c.kqfcoidx,0,null,c.kqfcoidx)) xco_kqfcoidx
from v$fixed_table t, x$kqfco c 
where t.object_id = c.kqfcotob 
and upper(c.kqfconam) like upper('%&1%')
/
