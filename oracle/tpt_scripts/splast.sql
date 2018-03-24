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

col end_snap new_value   end_snap
col begin_snap new_value begin_snap

with s as (
    select max(snap_id) end_snap from stats$snapshot
)
select end_snap, (select max(snap_id) begin_snap from stats$snapshot where snap_id < s.end_snap) begin_snap 
from s;

def report_name=splast.txt

-- @?/rdbms/admin/spreport
@$HOME/work/oracle/statspack/11.2/spreport

undef end_snap
undef begin_snap

set termout on

host open splast.txt
