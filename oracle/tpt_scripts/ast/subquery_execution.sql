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

-- starting from 10g, the push_subq hint must be specified in the subquery block
-- you wish to push earlier (or with the @subq hint addressing)

select
   e.*
 , d.dname
from
   scott.emp   e
 , scott.dept  d
where
    e.deptno = d.deptno
and exists (
        select /*+ no_unnest push_subq */
            1
        from 
            scott.bonus b
        where
            b.ename = e.ename
        and b.job   = e.job
)
/

