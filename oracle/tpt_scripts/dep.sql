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

col dep_owner 			head OWNER		for a16
col dep_name			head DEPENDENT_NAME	for a30
col dep_type			head DEPENDENT_TYPE	for a12
col dep_referenced_owner	head REF_OWNER		for a16
col dep_referenced_name		head REF_NAME		for a30
col dep_referenced_type		head REF_TYPE		for a12
col dep_depency_type		head HARDSOFT		for a8

select 
	owner			dep_owner, 
	name			dep_name,
	type			dep_type,
	referenced_owner	dep_referenced_owner,
	referenced_name		dep_referenced_name,
	referenced_type		dep_referenced_type,
	dependency_type		dep_dependency_type
--
--from dba_dependencies where owner like '&1' and referenced_owner like '&2'
--from dba_dependencies where owner like '&1' and name like '&2'
--
from 
	dba_dependencies 
where 
	lower(owner) like lower('&1') 
and	lower(name) like lower('&2')
and	lower(referenced_owner) like lower('&3') 
and	lower(referenced_name) like lower('&4')
/


