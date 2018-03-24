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

-- Author:  Tanel Poder (http://tanelpoder.com | @tanelpoder )
-- Purpose: Get previously executed SQL ID, child number and other details into sqlplus variables for further use

COL GETLAST_PREV_SQL_ADDR      HEAD SQL_ADDR     NEW_VALUE prev_sql_addr
COL GETLAST_PREV_HASH_VALUE    HEAD HASH_VALUE   NEW_VALUE prev_hash_value
COL GETLAST_PREV_SQL_ID        HEAD SQL_ID       NEW_VALUE prev_sql_id
COL GETLAST_PREV_CHILD_NUMBER  HEAD CHILD_NUMBER NEW_VALUE prev_child_number
COL GETLAST_PREV_EXEC_START    HEAD EXEC_START   NEW_VALUE prev_exec_start
COL GETLAST_PREV_EXEC_ID       HEAD EXEC_ID      NEW_VALUE prev_exec_id

SELECT
    sysdate
  , sid
  , serial#
  , prev_sql_addr     getlast_prev_sql_addr    
  , prev_hash_value   getlast_prev_hash_value  
  , prev_sql_id       getlast_prev_sql_id      
  , prev_child_number getlast_prev_child_number
  , prev_exec_start   getlast_prev_exec_start  
  , prev_exec_id      getlast_prev_exec_id     
FROM
    v$session
WHERE
    sid = SYS_CONTEXT('USERENV', 'SID')
/

