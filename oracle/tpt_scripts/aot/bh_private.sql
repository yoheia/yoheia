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

col bhla_object head object for a40 truncate
col bhla_DBA head DBA for a20
col flg_lruflg head "FLAG:LRUFLAG"

select  /*+ ORDERED */
	trim(to_char(bh.flag, 'XXXXXXXX'))	||':'||
	trim(to_char(bh.lru_flag, 'XXXXXXXX')) 	flg_lruflg,
	bh.obj,
	o.object_type,
	o.owner||'.'||o.object_name		bhla_object,
	bh.tch,
	file# ||' '||dbablk			bhla_DBA,
	bh.class,
	bh.state,
	bh.mode_held,
	bh.dirty_queue				DQ
from
	x$bh		bh,
	dba_objects	o
where
	bh.obj = o.data_object_id
and	bitand(flag,8)=8
order by
	tch asc
/
