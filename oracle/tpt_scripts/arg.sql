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

-- object arguments

col proc_owner 		head OWNER for a25
col proc_object_name	head OBJECT_NAME for a30
col proc_procedure_name	head PROCEDURE_NAME for a30

select 
	  a.owner           proc_owner
  , a.object_name	    proc_object_name
  , p.procedure_name	proc_procedure_name
  , a.subprogram_id
from 
    dba_arguments a
  , dba_procedures p
where 
    a.owner = p.owner
and a.object_name = p.object_name
and a.object_id = p.object_id
and a.subprogram_id = p.subprogram_id
and lower(p.owner) like lower('%&1%')
and lower(p.object_name) like lower('%&2%')
and	lower(p.procedure_name) like lower('%&3%')
/
