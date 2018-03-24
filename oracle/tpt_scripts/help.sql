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

--
-- Tanel Poder's Troubleshooting scripts for Oracle v2.0.1
--
-- Copyright: (c) 2004-2009 http://www.tanelpoder.com
-- 
-- None of the TPT scripts change or alter the database by design,
-- nevertheless use those scripts at your own risk. Always make 
-- sure you know what the script is doing by reviewing its contents 
-- before running it!
--
--
-- Get more information on Oracle internals, tuning and troubleshooting 
-- from [ http://www.tanelpoder.com ]

COL help_content      HEAD DESCRIPTION FOR A100
COL help_script_name  HEAD NAME        FOR A12

WITH sq AS (
SELECT 1 id, 'i'        topic, '' parameters, 'Session info'    title, '"who am i" script for Oracle. Also sets Window title' content FROM dual UNION ALL
SELECT 1 id, 'ii'       topic, 'More session info' parameters, ''  title, 'Lists some session info in decimal and hex' content FROM dual UNION ALL
SELECT 1 id, 'source'   topic, '<owner> <object> <text>' parameters, 'List PL/SQL source'  title, 'Lists PL/SQL source code from DBA_SOURCE' content FROM dual UNION ALL
SELECT 1 id, 'ash' topic, 'ASH query' parameters, '@ash event,p1 "event like ''latch%''" -5m now'  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
--SELECT 1 id, '' topic, '' parameters, ''  title, '' content FROM dual UNION ALL
SELECT 1 id, 'dummy'    topic, '' parameters, ''               title, '' content FROM dual 
)
SELECT
    topic       help_script_name
  , parameters  parameters
  , title       script_title
  , content     help_content
FROM
    sq
WHERE
    LOWER(topic) LIKE LOWER('&1')
OR  LOWER(title) LIKE LOWER('&1')
OR  LOWER('&1') = 'index'
/
