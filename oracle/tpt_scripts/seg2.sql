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

col seg_owner head OWNER for a20
col seg_segment_name head SEGMENT_NAME for a30
col seg_segment_type head SEGMENT_TYPE for a20
col seg_partition_name head SEG_PART_NAME for a30

select 
	round(bytes/1048576) seg_MB,
	owner seg_owner, 
	segment_name seg_segment_name, 
	partition_name seg_partition_name,
	segment_type seg_segment_type, 
	tablespace_name seg_tablespace_name, 
  blocks,
	header_file hdrfil,
	HEADER_BLOCK hdrblk
from 
	dba_segments 
where 
	upper(segment_name) LIKE 
				upper(CASE 
					WHEN INSTR('&1','.') > 0 THEN 
					    SUBSTR('&1',INSTR('&1','.')+1)
					ELSE
					    '&1'
					END
				     )
AND	owner LIKE
		CASE WHEN INSTR('&1','.') > 0 THEN
			UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
		ELSE
			user
		END
/

