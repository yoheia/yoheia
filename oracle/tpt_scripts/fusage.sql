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


PROMPT Did you flush feature usage information to the repository?
PROMPT >>> EXEC dbms_feature_usage_internal.exec_db_usage_sampling(SYSDATE)

SELECT ul.name, ul.detected_usages
FROM dba_feature_usage_statistics ul
WHERE ul.version = (SELECT MAX(u2.version) 
                    FROM dba_feature_usage_statistics u2
                    WHERE ul.name = u2.name
                    AND UPPER(ul.name) LIKE UPPER('&1')
                    AND UPPER(u2.name) LIKE UPPER('&1')
                   )
/

