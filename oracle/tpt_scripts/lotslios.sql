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
-- File name:   lotslios.sql
-- Purpose:     Generate Lots of Logical IOs for testing purposes
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--
-- Usage:       @lotslios <number>
--              @lotslios 100
--              @lotslios 1000000
--
-- Other:       As the script self-joins SYS.OBJ$ to itself the maximum number
--              of rows processed (and LIOs generated) depends on the number
--              of rows in SYS.OBJ$
--
--------------------------------------------------------------------------------

prompt generate lots of LIOs by repeatedly full scanning through a small table...

select
    /*+ monitor
        ordered 
        use_nl(b) use_nl(c) use_nl(d) 
        full(a) full(b) full(c) full(d) */
    count(*)
from
    sys.obj$ a,
    sys.obj$ b,
    sys.obj$ c,
    sys.obj$ d
where
    a.owner# = b.owner#
and b.owner# = c.owner#
and c.owner# = d.owner#
and rownum <= &1
/
