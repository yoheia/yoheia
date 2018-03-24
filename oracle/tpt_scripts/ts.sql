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

select  
	c.ts#
  , t.tablespace_name
  , t.block_size blksz
  , status
  , t.bigfile
  , contents
  , logging
  , force_logging forcelog 
  , extent_management
  , allocation_type
  , segment_space_management ASSM
  , min_extlen EXTSZ
  , compress_for
  , predicate_evaluation
from 
	v$tablespace c, 
	dba_tablespaces t
where c.name = t.tablespace_name
and   upper(tablespace_name) like upper('%&1%');




