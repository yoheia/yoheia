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

--------------------------------------------------------------------------------
--
-- File name:   nonsharedsum_html.sql   
-- Purpose:     Print reasons for non-shared child cursors from v$sql_shared_cursor
--              in a readable format
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @nonsharedsum_html <threshold_cursor_count>
--              @nonsharedsum_html 100
--          
--------------------------------------------------------------------------------


DEF _CURSOR_COUNT=&1

SET MARKUP HTML ON

SPOOL nonshared_cursors.html

SELECT
    sql_id                                    
  -- , address                                  
  --, child_address                            
  --, child_number  
  , COUNT(*)  
  , COUNT(DISTINCT ADDRESS) num_parents                     
  , SUM(CASE WHEN UNBOUND_CURSOR = 'Y' THEN 1 ELSE 0 END) UNBOUND_CURSOR
  , SUM(CASE WHEN SQL_TYPE_MISMATCH = 'Y' THEN 1 ELSE 0 END) SQL_TYPE_MISMATCH                        
  , SUM(CASE WHEN OPTIMIZER_MISMATCH = 'Y' THEN 1 ELSE 0 END) OPTIMIZER_MISMATCH                       
  , SUM(CASE WHEN OUTLINE_MISMATCH = 'Y' THEN 1 ELSE 0 END) OUTLINE_MISMATCH                         
  , SUM(CASE WHEN STATS_ROW_MISMATCH = 'Y' THEN 1 ELSE 0 END) STATS_ROW_MISMATCH                       
  , SUM(CASE WHEN LITERAL_MISMATCH = 'Y' THEN 1 ELSE 0 END) LITERAL_MISMATCH                         
  , SUM(CASE WHEN FORCE_HARD_PARSE = 'Y' THEN 1 ELSE 0 END) FORCE_HARD_PARSE                         
  , SUM(CASE WHEN EXPLAIN_PLAN_CURSOR = 'Y' THEN 1 ELSE 0 END) EXPLAIN_PLAN_CURSOR                      
  , SUM(CASE WHEN BUFFERED_DML_MISMATCH = 'Y' THEN 1 ELSE 0 END) BUFFERED_DML_MISMATCH                    
  , SUM(CASE WHEN PDML_ENV_MISMATCH = 'Y' THEN 1 ELSE 0 END) PDML_ENV_MISMATCH                        
  , SUM(CASE WHEN INST_DRTLD_MISMATCH = 'Y' THEN 1 ELSE 0 END) INST_DRTLD_MISMATCH                      
  , SUM(CASE WHEN SLAVE_QC_MISMATCH = 'Y' THEN 1 ELSE 0 END) SLAVE_QC_MISMATCH                        
  , SUM(CASE WHEN TYPECHECK_MISMATCH = 'Y' THEN 1 ELSE 0 END) TYPECHECK_MISMATCH                       
  , SUM(CASE WHEN AUTH_CHECK_MISMATCH = 'Y' THEN 1 ELSE 0 END) AUTH_CHECK_MISMATCH                      
  , SUM(CASE WHEN BIND_MISMATCH = 'Y' THEN 1 ELSE 0 END) BIND_MISMATCH                            
  , SUM(CASE WHEN DESCRIBE_MISMATCH = 'Y' THEN 1 ELSE 0 END) DESCRIBE_MISMATCH                        
  , SUM(CASE WHEN LANGUAGE_MISMATCH = 'Y' THEN 1 ELSE 0 END) LANGUAGE_MISMATCH                        
  , SUM(CASE WHEN TRANSLATION_MISMATCH = 'Y' THEN 1 ELSE 0 END) TRANSLATION_MISMATCH                     
  , SUM(CASE WHEN BIND_EQUIV_FAILURE = 'Y' THEN 1 ELSE 0 END) BIND_EQUIV_FAILURE                       
  , SUM(CASE WHEN INSUFF_PRIVS = 'Y' THEN 1 ELSE 0 END) INSUFF_PRIVS                             
  , SUM(CASE WHEN INSUFF_PRIVS_REM = 'Y' THEN 1 ELSE 0 END) INSUFF_PRIVS_REM                         
  , SUM(CASE WHEN REMOTE_TRANS_MISMATCH = 'Y' THEN 1 ELSE 0 END) REMOTE_TRANS_MISMATCH                    
  , SUM(CASE WHEN LOGMINER_SESSION_MISMATCH = 'Y' THEN 1 ELSE 0 END) LOGMINER_SESSION_MISMATCH                
  , SUM(CASE WHEN INCOMP_LTRL_MISMATCH = 'Y' THEN 1 ELSE 0 END) INCOMP_LTRL_MISMATCH                     
  , SUM(CASE WHEN OVERLAP_TIME_MISMATCH = 'Y' THEN 1 ELSE 0 END) OVERLAP_TIME_MISMATCH                    
  , SUM(CASE WHEN EDITION_MISMATCH = 'Y' THEN 1 ELSE 0 END) EDITION_MISMATCH                         
  , SUM(CASE WHEN MV_QUERY_GEN_MISMATCH = 'Y' THEN 1 ELSE 0 END) MV_QUERY_GEN_MISMATCH                    
  , SUM(CASE WHEN USER_BIND_PEEK_MISMATCH = 'Y' THEN 1 ELSE 0 END) USER_BIND_PEEK_MISMATCH                  
  , SUM(CASE WHEN TYPCHK_DEP_MISMATCH = 'Y' THEN 1 ELSE 0 END) TYPCHK_DEP_MISMATCH                      
  , SUM(CASE WHEN NO_TRIGGER_MISMATCH = 'Y' THEN 1 ELSE 0 END) NO_TRIGGER_MISMATCH                      
  , SUM(CASE WHEN FLASHBACK_CURSOR = 'Y' THEN 1 ELSE 0 END) FLASHBACK_CURSOR                         
  , SUM(CASE WHEN ANYDATA_TRANSFORMATION = 'Y' THEN 1 ELSE 0 END) ANYDATA_TRANSFORMATION                   
  , SUM(CASE WHEN PDDL_ENV_MISMATCH = 'Y' THEN 1 ELSE 0 END) PDDL_ENV_MISMATCH                        
  , SUM(CASE WHEN TOP_LEVEL_RPI_CURSOR = 'Y' THEN 1 ELSE 0 END) TOP_LEVEL_RPI_CURSOR                     
  , SUM(CASE WHEN DIFFERENT_LONG_LENGTH = 'Y' THEN 1 ELSE 0 END) DIFFERENT_LONG_LENGTH                    
  , SUM(CASE WHEN LOGICAL_STANDBY_APPLY = 'Y' THEN 1 ELSE 0 END) LOGICAL_STANDBY_APPLY                    
  , SUM(CASE WHEN DIFF_CALL_DURN = 'Y' THEN 1 ELSE 0 END) DIFF_CALL_DURN                           
  , SUM(CASE WHEN BIND_UACS_DIFF = 'Y' THEN 1 ELSE 0 END) BIND_UACS_DIFF                           
  , SUM(CASE WHEN PLSQL_CMP_SWITCHS_DIFF = 'Y' THEN 1 ELSE 0 END) PLSQL_CMP_SWITCHS_DIFF                   
  , SUM(CASE WHEN CURSOR_PARTS_MISMATCH = 'Y' THEN 1 ELSE 0 END) CURSOR_PARTS_MISMATCH                    
  , SUM(CASE WHEN STB_OBJECT_MISMATCH = 'Y' THEN 1 ELSE 0 END) STB_OBJECT_MISMATCH                      
  , SUM(CASE WHEN CROSSEDITION_TRIGGER_MISMATCH = 'Y' THEN 1 ELSE 0 END) CROSSEDITION_TRIGGER_MISMATCH            
  , SUM(CASE WHEN PQ_SLAVE_MISMATCH = 'Y' THEN 1 ELSE 0 END) PQ_SLAVE_MISMATCH                        
  , SUM(CASE WHEN TOP_LEVEL_DDL_MISMATCH = 'Y' THEN 1 ELSE 0 END) TOP_LEVEL_DDL_MISMATCH                   
  , SUM(CASE WHEN MULTI_PX_MISMATCH = 'Y' THEN 1 ELSE 0 END) MULTI_PX_MISMATCH                        
  , SUM(CASE WHEN BIND_PEEKED_PQ_MISMATCH = 'Y' THEN 1 ELSE 0 END) BIND_PEEKED_PQ_MISMATCH                  
  , SUM(CASE WHEN MV_REWRITE_MISMATCH = 'Y' THEN 1 ELSE 0 END) MV_REWRITE_MISMATCH                      
  , SUM(CASE WHEN ROLL_INVALID_MISMATCH = 'Y' THEN 1 ELSE 0 END) ROLL_INVALID_MISMATCH                    
  , SUM(CASE WHEN OPTIMIZER_MODE_MISMATCH = 'Y' THEN 1 ELSE 0 END) OPTIMIZER_MODE_MISMATCH                  
  , SUM(CASE WHEN PX_MISMATCH = 'Y' THEN 1 ELSE 0 END) PX_MISMATCH                              
  , SUM(CASE WHEN MV_STALEOBJ_MISMATCH = 'Y' THEN 1 ELSE 0 END) MV_STALEOBJ_MISMATCH                     
  , SUM(CASE WHEN FLASHBACK_TABLE_MISMATCH = 'Y' THEN 1 ELSE 0 END) FLASHBACK_TABLE_MISMATCH                 
  , SUM(CASE WHEN LITREP_COMP_MISMATCH = 'Y' THEN 1 ELSE 0 END) LITREP_COMP_MISMATCH                     
  , SUM(CASE WHEN PLSQL_DEBUG = 'Y' THEN 1 ELSE 0 END) PLSQL_DEBUG                              
  , SUM(CASE WHEN LOAD_OPTIMIZER_STATS = 'Y' THEN 1 ELSE 0 END) LOAD_OPTIMIZER_STATS                     
  , SUM(CASE WHEN ACL_MISMATCH = 'Y' THEN 1 ELSE 0 END) ACL_MISMATCH                             
  , SUM(CASE WHEN FLASHBACK_ARCHIVE_MISMATCH = 'Y' THEN 1 ELSE 0 END) FLASHBACK_ARCHIVE_MISMATCH               
  , SUM(CASE WHEN LOCK_USER_SCHEMA_FAILED = 'Y' THEN 1 ELSE 0 END) LOCK_USER_SCHEMA_FAILED                  
  , SUM(CASE WHEN REMOTE_MAPPING_MISMATCH = 'Y' THEN 1 ELSE 0 END) REMOTE_MAPPING_MISMATCH                  
  , SUM(CASE WHEN LOAD_RUNTIME_HEAP_FAILED = 'Y' THEN 1 ELSE 0 END) LOAD_RUNTIME_HEAP_FAILED                 
  , SUM(CASE WHEN HASH_MATCH_FAILED = 'Y' THEN 1 ELSE 0 END) HASH_MATCH_FAILED                        
--  , SUM(CASE WHEN PURGED_CURSOR = 'Y' THEN 1 ELSE 0 END) PURGED_CURSOR                            
--  , SUM(CASE WHEN BIND_LENGTH_UPGRADEABLE = 'Y' THEN 1 ELSE 0 END) BIND_LENGTH_UPGRADEABLE                  
--  , SUM(CASE WHEN USE_FEEDBACK_STATS = 'Y' THEN 1 ELSE 0 END) USE_FEEDBACK_STATS                      
FROM
    v$sql_shared_cursor
GROUP BY
    sql_id
  --, address 
HAVING 
    COUNT(*) >= &_CURSOR_COUNT
ORDER BY
    COUNT(*) DESC
/

SPOOL OFF
SET MARKUP HTML OFF

