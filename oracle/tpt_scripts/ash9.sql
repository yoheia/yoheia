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

SELECT * FROM (
  SELECT 
        a.session_state
      , a.event
      , count(*)
      , lpad(round(ratio_to_report(count(*)) over () * 100)||'%',10,' ') percent
      , MIN(a.sample_time)
      , MAX(a.sample_time)
    FROM
        v$active_session_history a
    WHERE
        a.sample_time BETWEEN TIMESTAMP'2011-01-10 18:00:00' AND TIMESTAMP'2011-01-10 19:00:00'
    GROUP BY
        a.session_state
      , a.event
    ORDER BY
        percent DESC
)
WHERE ROWNUM <= 30
/

SELECT * FROM (
  SELECT 
        a.program
      , a.sql_id
      , a.session_state
      , a.event
      , count(*)
      , lpad(round(ratio_to_report(count(*)) over () * 100)||'%',10,' ') percent
      , MIN(a.sample_time)
      , MAX(a.sample_time)
    FROM
        v$active_session_history a
    WHERE
        a.sample_time BETWEEN TIMESTAMP'2011-01-10 18:00:00' AND TIMESTAMP'2011-01-10 19:00:00'
    GROUP BY
        a.program
      , a.sql_id
      , a.session_state
      , a.event
    ORDER BY
        percent DESC
)
WHERE ROWNUM <= 30
/

SELECT * FROM (
  SELECT
        a.program
      , a.sql_id
      , a.session_state
      , a.event
      , a.p1
      , a.p2
      , count(*)
      , lpad(round(ratio_to_report(count(*)) over () * 100)||'%',10,' ') percent
      , MIN(a.sample_time)
      , MAX(a.sample_time)
    FROM
        v$active_session_history a
    WHERE
        a.sample_time BETWEEN TIMESTAMP'2011-01-10 18:00:00' AND TIMESTAMP'2011-01-10 19:00:00'
    GROUP BY
        a.program
      , a.sql_id
      , a.session_state
      , a.event
      , a.p1
      , a.p2
    ORDER BY
        percent DESC
)
WHERE ROWNUM <= 300
/

