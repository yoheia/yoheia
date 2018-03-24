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

col partkeys_column_name head COLUMN_NAME for a30
col partkeys_object_type HEAD OBJECT_TYPE FOR A11
col partkeys_owner HEAD OWNER FOR A30
col partkeys_name HEAD NAME FOR A30
col partkeys_level HEAD LEVEL FOR A6

with sq as (select '1_TOP' lvl, c.* from dba_part_key_columns c union all select '2_SUB', c.* from dba_subpart_key_columns c)
select
    object_type     partkeys_object_type
  , owner           partkeys_owner
  , name            partkeys_name
  , lvl             partkeys_level
  , column_name     partkeys_column_name
  , column_position 
from
    sq --dba_part_key_columns
where
    upper(name) LIKE 
                upper(CASE 
                    WHEN INSTR('&1','.') > 0 THEN 
                        SUBSTR('&1',INSTR('&1','.')+1)
                    ELSE
                        '&1'
                    END
                     )
AND owner LIKE
        CASE WHEN INSTR('&1','.') > 0 THEN
            UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
        ELSE
            user
        END
ORDER BY
    object_type
  , owner
  , name
  , lvl
  , column_position
/

