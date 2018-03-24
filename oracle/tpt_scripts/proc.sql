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

col proc_owner 		head OWNER for a25
col proc_object_name	head OBJECT_NAME for a30
col proc_procedure_name	head PROCEDURE_NAME for a30

select 
	owner		proc_owner
      , object_name	proc_object_name
      , procedure_name	proc_procedure_name
--      ,  subprogram_id
from 
	dba_procedures 
where 
	lower(object_name) like lower('%&1%')
and	lower(procedure_name) like lower('%&2%')
/
