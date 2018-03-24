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

col syn_db_link head DB_LINK for a30
col syn_owner head OWNER for a30
col syn_synonym_name head SYNONYM_NAME for a30
col syn_table_owner head TABLE_OWNER for a30
col syn_table_name head TABLE_NAME for a30

select
	owner syn_owner,
	synonym_name syn_synonym_name,
	table_owner syn_table_owner,
	table_name syn_table_name,
	db_link syn_db_link
from
  dba_synonyms 
where
  upper(synonym_name) LIKE 
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
