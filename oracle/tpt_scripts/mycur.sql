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

COL mycur_bind_mem_loc HEAD BIND_MEM FOR A8

SELECT
    curno
  , '0x'||TRIM(TO_CHAR(flag, '0XXXXXXX')) flag
  , status
  , parent_handle            par_hd
  , parent_lock              par_lock
  , child_handle             ch_hd
  , child_lock               ch_lock
  , child_pin                ch_pin
  , pers_heap_mem
  , work_heap_mem
  , bind_vars
  , define_vars
  , bind_mem_loc              mycur_bind_mem_loc
--  , inst_flag
--  , inst_flag2
FROM
    v$sql_cursor
WHERE
    status != 'CURNULL'
/
