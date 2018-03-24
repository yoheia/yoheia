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

prompt Show file, block, row numbers from rowid &1....

def rowid=&1

select
    dbms_rowid.ROWID_RELATIVE_FNO('&rowid') rfile#
  , dbms_rowid.ROWID_BLOCK_NUMBER('&rowid') block#
  , dbms_rowid.ROWID_ROW_NUMBER('&rowid')   row#
  , lpad('0x'||trim(to_char(dbms_utility.MAKE_DATA_BLOCK_ADDRESS(dbms_rowid.ROWID_RELATIVE_FNO('&rowid')
  , dbms_rowid.ROWID_BLOCK_NUMBER('&rowid')), 'XXXXXXXX')), 10) rowid_dba
  , 'alter system dump datafile '||dbms_rowid.ROWID_RELATIVE_FNO('&rowid')||' block '||
                                   dbms_rowid.ROWID_BLOCK_NUMBER('&rowid')||'; -- @dump '||
                                   dbms_rowid.ROWID_RELATIVE_FNO('&rowid')||' '||
                                   dbms_rowid.ROWID_BLOCK_NUMBER('&rowid')||' .' dump_command
from
    dual
/
