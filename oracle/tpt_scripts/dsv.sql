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

.
@@saveset
-- set underline off if dont want dashes to appear between column headers and data
set termout off feedback off colsep &1 lines 32767 trimspool on trimout on tab off newpage none underline off 
spool &_TPT_TEMPDIR/output_&_i_inst..&2
/
spool off

@@loadset

host &_START &_TPT_TEMPDIR/output_&_i_inst..&2