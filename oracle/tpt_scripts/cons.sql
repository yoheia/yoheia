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

column cons_constraint_name heading CONSTRAINT_NAME format a30
column cons_column_name heading COLUMN_NAME format a30
column cons_owner heading OWNER format A30
column cons_table_name heading TABLE_NAME format A30
column constraint_name for a30
column r_constraint_name for a30

prompt Show constraints on table &1....

select
     co.owner cons_owner,
     co.table_name           cons_table_name,
     co.constraint_name      cons_constraint_name,
     co.constraint_type,
     co.r_constraint_name,
     cc.column_name          cons_column_name,
     cc.position,
     co.status,
     co.validated
from
     dba_constraints co,
     dba_cons_columns cc
where
    co.owner              = cc.owner
and co.table_name         = cc.table_name
and co.constraint_name    = cc.constraint_name
and upper(co.table_name) LIKE 
                upper(CASE 
                    WHEN INSTR('&1','.') > 0 THEN 
                        SUBSTR('&1',INSTR('&1','.')+1)
                    ELSE
                        '&1'
                    END
                     )
AND co.owner LIKE
        CASE WHEN INSTR('&1','.') > 0 THEN
            UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
        ELSE
            user
        END
order by
     cons_owner,
     cons_table_name,
     constraint_type,
     cons_constraint_name,
     position,
     column_name
/

