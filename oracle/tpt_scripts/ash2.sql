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

SET LINES 999 PAGES 5000 TRIMSPOOL ON TRIMOUT ON VERIFY OFF

--DEF from_time="2010-10-30 18:12:00"
--DEF to_time="2010-10-30 18:14:00"

DEF from_time="&1"
DEF to_time="&2"

DEF cols=session_type,top_level_call_name,program,top_level_sql_opcode,top_level_sql_id,sql_opcode,sql_id

PROMPT FROM_TIME=&from_time TO_TIME=&to_time

SELECT * FROM (
  SELECT
        count(*) 
      , lpad(round(ratio_to_report(count(*)) over () * 100)||'%',10,' ') percent
      , &cols
      , CASE WHEN IN_CONNECTION_MGMT='Y' THEN 'CONNECTION_MGMT' 
        WHEN IN_PARSE               ='Y' THEN 'PARSE'                      
        WHEN IN_HARD_PARSE          ='Y' THEN 'HARD_PARSE'                 
        WHEN IN_SQL_EXECUTION       ='Y' THEN 'SQL_EXECUTION'              
        WHEN IN_PLSQL_EXECUTION     ='Y' THEN 'PLSQL_EXECUTION'            
        WHEN IN_PLSQL_RPC           ='Y' THEN 'PLSQL_RPC'                  
        WHEN IN_PLSQL_COMPILATION   ='Y' THEN 'PLSQL_COMPILATION'          
        WHEN IN_JAVA_EXECUTION      ='Y' THEN 'JAVA_EXECUTION'             
        WHEN IN_BIND                ='Y' THEN 'BIND'                       
        WHEN IN_CURSOR_CLOSE        ='Y' THEN 'CURSOR_CLOSE'               
        WHEN IN_SEQUENCE_LOAD       ='Y' THEN 'SEQUENCE_LOAD'
        END stage
    FROM
        v$active_session_history
    WHERE
        sample_time BETWEEN TIMESTAMP'&from_time' AND TIMESTAMP'&to_time'
    AND session_state = 'ON CPU'
    AND event IS NULL
    AND sql_id IS NULL
    AND session_type = 'FOREGROUND'
    GROUP BY
        &cols
      , CASE WHEN IN_CONNECTION_MGMT='Y' THEN 'CONNECTION_MGMT' 
        WHEN IN_PARSE               ='Y' THEN 'PARSE'                      
        WHEN IN_HARD_PARSE          ='Y' THEN 'HARD_PARSE'                 
        WHEN IN_SQL_EXECUTION       ='Y' THEN 'SQL_EXECUTION'              
        WHEN IN_PLSQL_EXECUTION     ='Y' THEN 'PLSQL_EXECUTION'            
        WHEN IN_PLSQL_RPC           ='Y' THEN 'PLSQL_RPC'                  
        WHEN IN_PLSQL_COMPILATION   ='Y' THEN 'PLSQL_COMPILATION'          
        WHEN IN_JAVA_EXECUTION      ='Y' THEN 'JAVA_EXECUTION'             
        WHEN IN_BIND                ='Y' THEN 'BIND'                       
        WHEN IN_CURSOR_CLOSE        ='Y' THEN 'CURSOR_CLOSE'               
        WHEN IN_SEQUENCE_LOAD       ='Y' THEN 'SEQUENCE_LOAD'
        END 
    ORDER BY
        percent DESC
)
WHERE ROWNUM <= 30
/

DEF cols=session_type,program,top_level_sql_opcode,sql_id
/
-- 
-- DEF cols=session_type,program,top_level_sql_opcode,sql_id,event
-- /
-- 
-- DEF cols=session_type,program,top_level_sql_opcode,sql_id,event,p1
-- /
-- 
-- DEF cols=session_type,program,top_level_sql_opcode,sql_id,event,p1,p2
-- /
-- 
-- DEF cols=session_type,program,top_level_sql_opcode,top_level_sql_id
-- /
-- 
-- DEF cols=session_type,program,plsql_object_id,plsql_subprogram_id
-- /
-- 
