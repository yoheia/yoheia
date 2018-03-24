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
-- File name:   la.sql ( Latch Address )
-- Purpose:     Show which latch occupies a given memory address and its stats
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @la <address_in_hex>
--              @la 50BE2178
--
--------------------------------------------------------------------------------
column la_name heading NAME format a45
column la_chld heading CHLD format 99999

select 
    addr, latch#, 0 la_chld, name la_name, gets, immediate_gets igets, 
    misses, immediate_misses imisses, spin_gets spingets, sleeps, wait_time
from v$latch_parent
where addr = hextoraw(lpad('&1', (select vsize(addr)*2 from v$latch_parent where rownum = 1) ,0))
union all
select 
    addr, latch#, child#, name la_name, gets, immediate_gets igets, 
    misses, immediate_misses imisses, spin_gets spingets, sleeps, wait_time 
from v$latch_children
where addr = hextoraw(lpad('&1', (select vsize(addr)*2 from v$latch_children where rownum = 1) ,0))
/
