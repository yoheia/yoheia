.
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

set termout off

def _x9_temp_env=&_tpt_tempdir/env_&_tpt_tempfile..sql
def _x9_temp_sql=&_tpt_tempdir/sql_&_tpt_tempfile..sql

store set &_x9_temp_env replace
save      &_x9_temp_sql replace

0 explain plan for
run

set termout on

select * from table(dbms_xplan.display());

set termout off
@/&_x9_temp_env
get &_x9_temp_sql
set termout on
