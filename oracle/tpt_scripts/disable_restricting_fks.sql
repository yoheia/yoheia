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

SELECT 'ALTER TABLE '||c.owner||'.'||c.table_name||' DISABLE CONSTRAINT '||c.constraint_name||';'
FROM dba_constraints c
WHERE (c.owner, c.constraint_name) IN (select a.owner, a.constraint_name 
                          FROM dba_constraints a, dba_constraints b
                          WHERE 
                              a.r_owner           = b.owner
                          AND a.r_constraint_name = b.constraint_name
                          AND a.constraint_type = 'R'
													AND UPPER(b.table_name) LIKE 
																	UPPER(CASE 
																		WHEN INSTR('&1','.') > 0 THEN 
																				SUBSTR('&1',INSTR('&1','.')+1)
																		ELSE
																				'&1'
																		END
																			 ) ESCAPE '\'
													AND UPPER(b.owner) LIKE
															CASE WHEN INSTR('&1','.') > 0 THEN
																UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
															ELSE
																user
                              END ESCAPE '\'
													)
/
