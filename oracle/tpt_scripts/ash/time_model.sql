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

SELECT * FROM (
  SELECT /*+ LEADING(a) USE_HASH(u) */
        count(*) seconds
      , LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100)||'%',5,' ') "%This"
      , &1
      , CASE WHEN IN_CONNECTION_MGMT      = 'Y' THEN 'CONNECTION_MGMT '          END ||
        CASE WHEN IN_PARSE                = 'Y' THEN 'PARSE '                    END ||
        CASE WHEN IN_HARD_PARSE           = 'Y' THEN 'HARD_PARSE '               END ||
        CASE WHEN IN_SQL_EXECUTION        = 'Y' THEN 'SQL_EXECUTION '            END ||
        CASE WHEN IN_PLSQL_EXECUTION      = 'Y' THEN 'PLSQL_EXECUTION '          END ||
        CASE WHEN IN_PLSQL_RPC            = 'Y' THEN 'PLSQL_RPC '                END ||
        CASE WHEN IN_PLSQL_COMPILATION    = 'Y' THEN 'PLSQL_COMPILATION '        END ||
        CASE WHEN IN_JAVA_EXECUTION       = 'Y' THEN 'JAVA_EXECUTION '           END ||
        CASE WHEN IN_BIND                 = 'Y' THEN 'BIND '                     END ||
        CASE WHEN IN_CURSOR_CLOSE         = 'Y' THEN 'CURSOR_CLOSE '             END ||
        CASE WHEN IN_SEQUENCE_LOAD        = 'Y' THEN 'SEQUENCE_LOAD '            END ||
--        CASE WHEN IN_INMEMORY_QUERY       = 'Y' THEN 'IN_INMEMORY_QUERY'         END ||
--        CASE WHEN IN_INMEMORY_POPULATE    = 'Y' THEN 'IN_INMEMORY_POPULATE'      END ||
--        CASE WHEN IN_INMEMORY_PREPOPULATE = 'Y' THEN 'IN_INMEMORY_PREPOPULATE'   END ||
--        CASE WHEN IN_INMEMORY_REPOPULATE  = 'Y' THEN 'IN_INMEMORY_REPOPULATE'    END ||
--        CASE WHEN IN_INMEMORY_TREPOPULATE = 'Y' THEN 'IN_INMEMORY_TREPOPULATE'   END ||
--        CASE WHEN IN_TABLESPACE_ENCRYPTION= 'Y' THEN 'IN_TABLESPACE_ENCRYPTION'  END ||
        '' phase
    FROM
        v$active_session_history a
      , dba_users u
    WHERE
        a.user_id = u.user_id(+)
    AND &2
    AND sample_time BETWEEN &3 AND &4
    --AND session_type = 'FOREGROUND'
    GROUP BY
        &1
      , CASE WHEN IN_CONNECTION_MGMT      = 'Y' THEN 'CONNECTION_MGMT '          END ||
        CASE WHEN IN_PARSE                = 'Y' THEN 'PARSE '                    END ||
        CASE WHEN IN_HARD_PARSE           = 'Y' THEN 'HARD_PARSE '               END ||
        CASE WHEN IN_SQL_EXECUTION        = 'Y' THEN 'SQL_EXECUTION '            END ||
        CASE WHEN IN_PLSQL_EXECUTION      = 'Y' THEN 'PLSQL_EXECUTION '          END ||
        CASE WHEN IN_PLSQL_RPC            = 'Y' THEN 'PLSQL_RPC '                END ||
        CASE WHEN IN_PLSQL_COMPILATION    = 'Y' THEN 'PLSQL_COMPILATION '        END ||
        CASE WHEN IN_JAVA_EXECUTION       = 'Y' THEN 'JAVA_EXECUTION '           END ||
        CASE WHEN IN_BIND                 = 'Y' THEN 'BIND '                     END ||
        CASE WHEN IN_CURSOR_CLOSE         = 'Y' THEN 'CURSOR_CLOSE '             END ||
        CASE WHEN IN_SEQUENCE_LOAD        = 'Y' THEN 'SEQUENCE_LOAD '            END ||
--        CASE WHEN IN_INMEMORY_QUERY       = 'Y' THEN 'IN_INMEMORY_QUERY'         END ||
--        CASE WHEN IN_INMEMORY_POPULATE    = 'Y' THEN 'IN_INMEMORY_POPULATE'      END ||
--        CASE WHEN IN_INMEMORY_PREPOPULATE = 'Y' THEN 'IN_INMEMORY_PREPOPULATE'   END ||
--        CASE WHEN IN_INMEMORY_REPOPULATE  = 'Y' THEN 'IN_INMEMORY_REPOPULATE'    END ||
--        CASE WHEN IN_INMEMORY_TREPOPULATE = 'Y' THEN 'IN_INMEMORY_TREPOPULATE'   END ||
--        CASE WHEN IN_INMEMORY_TREPOPULATE = 'Y' THEN 'IN_INMEMORY_TREPOPULATE'   END ||
--        CASE WHEN IN_TABLESPACE_ENCRYPTION= 'Y' THEN 'IN_TABLESPACE_ENCRYPTION'  END ||
        ''
    ORDER BY
        seconds DESC
)
WHERE ROWNUM <= 20
/

