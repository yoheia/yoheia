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

SELECT
    SAMPLE_ID
  , CAST(SAMPLE_TIME AS DATE) sample_time
  , SESSION_ID
  , SESSION_SERIAL#
  , SESSION_TYPE
  , USER_ID
  , SQL_ID
  , SQL_CHILD_NUMBER
  , SQL_OPCODE
  , FORCE_MATCHING_SIGNATURE
  , TOP_LEVEL_SQL_ID
  , TOP_LEVEL_SQL_OPCODE
  , SQL_PLAN_HASH_VALUE
  , SQL_PLAN_LINE_ID
  , SQL_PLAN_OPERATION
  , SQL_PLAN_OPTIONS
  , SQL_EXEC_ID
  , SQL_EXEC_START
  , PLSQL_ENTRY_OBJECT_ID
  , PLSQL_ENTRY_SUBPROGRAM_ID
  , PLSQL_OBJECT_ID
  , PLSQL_SUBPROGRAM_ID
  , QC_INSTANCE_ID
  , QC_SESSION_ID
  , QC_SESSION_SERIAL#
  , EVENT
  , EVENT_ID
  , EVENT#
  , SEQ#
  , P1TEXT
  , P1
  , P2TEXT
  , P2
  , P3TEXT
  , P3
  , WAIT_CLASS
  , WAIT_CLASS_ID
  , WAIT_TIME
  , SESSION_STATE
  , BLOCKING_SESSION_STATUS
  , BLOCKING_SESSION
  , BLOCKING_SESSION_SERIAL#
  , CURRENT_OBJ#
  , CURRENT_FILE#
  , CURRENT_BLOCK#
  , CURRENT_ROW#
  , CONSUMER_GROUP_ID
  , XID
  , REMOTE_INSTANCE#
  , IN_CONNECTION_MGMT
  , IN_PARSE
  , IN_HARD_PARSE
  , IN_SQL_EXECUTION
  , IN_PLSQL_EXECUTION
  , IN_PLSQL_RPC
  , IN_PLSQL_COMPILATION
  , IN_JAVA_EXECUTION
  , IN_BIND
  , IN_CURSOR_CLOSE
  , SERVICE_HASH
  , PROGRAM
  , MODULE
  , ACTION
  , CLIENT_ID
FROM
    v$active_session_history
WHERE
    sample_time BETWEEN %FROM_DATE% AND %TO_DATE%
AND %FILTER%

