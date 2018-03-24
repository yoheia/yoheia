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
-- File name:   hinth.sql (Hint Hierarchy)
--
-- Purpose:     Display the areas / features in Oracle kernel that a hint affects
--              (displayed as a feature/module hierarchy)
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @hinth <hint_name>
--              @hinth MERGE
--          
-- Other:       Requires Oracle 11g+
--
--------------------------------------------------------------------------------

COL sqlfh_feature HEAD SQL_FEATURE FOR A55
COL hinth_path HEAD PATH FOR A150

PROMPT Display Hint feature hierarchy for hints like &1

WITH feature_hierarchy AS (
SELECT 
    f.sql_feature
  , SYS_CONNECT_BY_PATH(REPLACE(f.sql_feature, 'QKSFM_', ''), ' -> ') path
FROM 
    v$sql_feature f
  , v$sql_feature_hierarchy fh 
WHERE 
    f.sql_feature = fh.sql_feature 
CONNECT BY fh.parent_id = PRIOR f.sql_Feature 
START WITH fh.sql_feature = 'QKSFM_ALL'
)
SELECT
    hi.name
  , REGEXP_REPLACE(fh.path, '^ -> ', '') hinth_path
FROM
    v$sql_hint hi
  , feature_hierarchy fh
WHERE
    hi.sql_feature = fh.sql_feature
--    hi.sql_feature = REGEXP_REPLACE(fh.sql_feature, '_[[:digit:]]+$')
AND UPPER(hi.name) LIKE UPPER('%&1%')
ORDER BY
    path
  --name
/

