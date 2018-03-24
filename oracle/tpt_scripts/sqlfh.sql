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
-- File name:   sqlfh.sql (SQL Feature Hieararchy)
--
-- Purpose:     Display the full SQL Feature Hieararchy from v$sql_feature
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @sqlfh
--          
-- Other:       Requires Oracle 11g+
--
--------------------------------------------------------------------------------

COL sqlfh_feature HEAD SQL_FEATURE FOR A55

PROMPT Display full SQL Feature Hierarchy from v$sql_feature ...
SELECT 
    LPAD(' ', (level-1)*2) || REPLACE(f.sql_feature, 'QKSFM_','') sqlfh_feature
  , f.description 
FROM 
    v$sql_feature f
  , v$sql_feature_hierarchy fh 
WHERE 
    f.sql_feature = fh.sql_feature 
CONNECT BY fh.parent_id = PRIOR f.sql_Feature 
START WITH fh.sql_feature = 'QKSFM_ALL'
/

