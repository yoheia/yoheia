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

select
--      sql_id
--    , child_number
--    , plan_hash_value
     substr(extractvalue(value(d), '/hint'), 1, 100) as outline_hints
from
      xmltable('/*/outline_data/hint'
        passing (
           select
            xmltype(other_xml) as xmlval
           from
            v$sql_plan
           where
            sql_id = '&1'
           and  child_number like '&2' 
           and  other_xml is not null
        )
) d
/

--select regexp_substr(other_xml,'<!\[CDATA\[.*?\]\]>') from v$sql_plan where sql_id = '&1' and child_number like '&2';

-- SELECT /*+ opt_param('parallel_execution_enabled', 'false') */
--    SUBSTR(EXTRACTVALUE(VALUE(d), '/hint'), 1, 4000) hint
-- FROM
--     v$sql_plan p
--   , TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE(p.other_xml), '/*/outline_data/hint'))) d
-- where 
--     sql_id = '&1' 
-- and child_number like '&2'
-- /

