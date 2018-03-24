#!/bin/bash
# 
#  Copyright 2017 Tanel Poder ( tanel@tanelpoder.com | http://tanelpoder.com )
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# 

# note that "*" doesn't go well together with unix shell, so don't use it in your queries
HEADERQUERY="SELECT 
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') sample_time
  , sid
  , serial#
  , username
  , CASE WHEN state != 'WAITING' THEN 'ON CPU' ELSE 'WAITING'        END AS state
  , CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue' ELSE event END AS event
  , seq#
  , seconds_in_wait
  , blocking_session_status
  , blocking_session
  , blocking_instance
  , program
  , command
  , osuser
  , process
  , machine
  , terminal
  , module
  , action
  , client_identifier
  , client_info
  , type
  , sql_id
  , sql_child_number
  , TO_CHAR(sql_exec_start, 'YYYY-MM-DD HH24:MI:SS') sql_exec_start
  , sql_exec_id
  , p1text
  , p1raw
  , p2text
  , p2raw
  , p3text
  , p3raw
FROM
    v\$session s
WHERE
    sid = SYS_CONTEXT('USERENV', 'SID')
"

ASHQUERY="SELECT 
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') sample_time
  , sid
  , serial#
  , username
  , CASE WHEN state != 'WAITING' THEN 'ON CPU' ELSE 'WAITING'        END AS state
  , CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue' ELSE event END AS event
  , seq#
  , seconds_in_wait
  , blocking_session_status
  , blocking_session
  , blocking_instance
  , program
  , command
  , osuser
  , process
  , machine
  , terminal
  , module
  , action
  , client_identifier
  , client_info
  , type
  , sql_id
  , sql_child_number
  , TO_CHAR(sql_exec_start, 'YYYY-MM-DD HH24:MI:SS') sql_exec_start
  , sql_exec_id
  , p1text
  , p1raw
  , p2text
  , p2raw
  , p3text
  , p3raw
FROM
    v\$session s
WHERE
   (s.status = 'ACTIVE' and s.state != 'WAITING' and s.sid != SYS_CONTEXT('USERENV','SID'))
OR
   (    s.status = 'ACTIVE' 
    AND s.state = 'WAITING' 
    AND s.wait_class != 'Idle' 
    AND s.sid != SYS_CONTEXT('USERENV','SID')
   )
"

echo SET PAGESIZE 50000 LINESIZE 5000 TRIMSPOOL ON TRIMOUT ON TAB OFF FEEDBACK OFF VERIFY OFF COLSEP \",\" SQLPROMPT \"\" SQLNUMBER OFF HEADING ON
echo "PROMPT Running... (ignore the first row, it's for printing the column headers...)"
echo "$HEADERQUERY"
echo "/"

echo SET HEADING OFF
echo "$ASHQUERY"

# LOOP FOREVER
while true
do

sleep 1
echo "/"

done 

