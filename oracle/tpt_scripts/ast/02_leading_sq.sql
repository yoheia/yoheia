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

select 
/*+
  no_unnest(@my_sub)
  leading  (@my_sub emp_inner@my_sub)
  use_merge (@my_sub dept_inner@my_sub)
*/
   *
from 
   scott.emp emp_outer
where 
   emp_outer.deptno in (
       select /*+ qb_name(my_sub) */
           dept_inner.deptno
       from 
           scott.dept dept_inner
         , scott.emp  emp_inner
       where 
           dept_inner.dname like 'S%'
       and emp_inner.ename   = dept_inner.dname
       and dept_inner.deptno = emp_outer.deptno
   )
/
