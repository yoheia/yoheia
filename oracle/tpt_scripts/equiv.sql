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

-- DBA_REWRITE_EQUIVALENCES
-- Name                            Null?    Type
-- ------------------------------- -------- ----------------------------
-- OWNER                           NOT NULL VARCHAR2(128)
-- NAME                            NOT NULL VARCHAR2(128)
-- SOURCE_STMT                              CLOB
-- DESTINATION_STMT                         CLOB
-- REWRITE_MODE                             VARCHAR2(10)

COL equiv_owner      FOR A20 WRAP
COL equiv_name       FOR A30 WRAP
COL source_stmt      FOR A50 WORD_WRAP
COL destination_stmt FOR A50 WORD_WRAP

SELECT
   owner equiv_owner
 , name  equiv_name
 , rewrite_mode
-- , source_stmt
-- , destination_stmt
FROM
   dba_rewrite_equivalences
WHERE
  UPPER(name) LIKE 
        upper(CASE 
          WHEN INSTR('&1','.') > 0 THEN 
              SUBSTR('&1',INSTR('&1','.')+1)
          ELSE
              '&1'
          END
             ) ESCAPE '\'
AND owner LIKE
    CASE WHEN INSTR('&1','.') > 0 THEN
      UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
    ELSE
      user
    END ESCAPE '\'
/

