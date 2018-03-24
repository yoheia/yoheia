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

column segeof_segment_name heading SEGMENT_NAME format a30
column segeof_owner        heading OWNER        format a25

--select tablespace_name, file_id, owner segeof_owner, segment_name segeof_segment_name, segment_Type 
--from dba_extents 
--where (file_id, block_id) in (select file_id, max(block_id) 
--                              from dba_extents 
--                              where upper(tablespace_name) like upper('%&1%')
--                              group by file_id)
--order by tablespace_name, file_id
--/

with d as (select /*+ NO_MERGE MATERIALIZE */ * from dba_extents where upper(tablespace_name) like upper('%&1%'))
select 
	distinct 'alter '||
	case 
		when segment_type = 'TABLE PARTITION' then 'TABLE'
		when segment_type = 'INDEX PARTITION' then 'INDEX'
	else
		segment_type
	end	
	||' '||owner||'.'||segment_name||' '||
	case
		when segment_type = 'INDEX' then 'REBUILD'
		when segment_type = 'TABLE' then 'MOVE'
		when segment_type like 'INDEX%PARTITION' then 'REBUILD PARTITION '||partition_name
		when segment_type like 'TABLE%PARTITION' then 'MOVE PARTITION '||partition_name
	end
	||' --[file='||file_id||', block='||block_id||', mb='||ROUND(block_id*8/1024)||'];' cmd
-- tablespace_name, file_id, owner segeof_owner, segment_name segeof_segment_name, segment_Type 
from d 
where (file_id, block_id) in (select file_id, max(block_id) 
                              from dba_extents 
                              where upper(tablespace_name) like upper('%&1%')
                              group by file_id)
order by cmd
/
