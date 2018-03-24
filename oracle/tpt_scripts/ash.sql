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

DEF from_time="TIMESTAMP'2012-05-21 07:55:00'"
DEF   to_time="TIMESTAMP'2012-05-21 08:15:00'"
--DEF from_time=sysdate-1/24/60*5
--DEF to_time=sysdate

--DEF cols=session_state,event,sql_id
DEF cols=&1

PROMPT FROM_TIME=&from_time TO_TIME=&to_time

SELECT * FROM (
  SELECT
        &cols
      , count(*)
      , lpad(round(ratio_to_report(count(*)) over () * 100)||'%',10,' ') percent
    FROM
        -- active_session_history_bak
        v$active_session_history
        -- dba_hist_active_sess_history
    WHERE
        sample_time BETWEEN &from_time AND &to_time
    AND &where_clause
    GROUP BY
        &cols
    ORDER BY
        percent DESC
)
WHERE ROWNUM <= 20
/

-- DEF cols=session_state,event,p1,p2
-- DEF cols=session_state,event,sql_id

