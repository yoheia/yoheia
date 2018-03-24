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

--------------------------------------------------------------------------------
--
-- File name:   prefetch.sql   
-- Purpose:     Show KCB layer prefetch 
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       
-- 	        
--	        
-- Other:       
--              
--              
--
--------------------------------------------------------------------------------
col "BLOCKS/OP" for 999.9

select
    p.id
  , p.name
  , p.block_size
  , pf.timestamp
  , pf.prefetch_ops ops
  , pf.prefetch_blocks blocks
  , pf.prefetch_blocks / pf.prefetch_ops "BLOCKS/OP"
from
    X$KCBKPFS pf
  , v$buffer_pool p
where
    pf.BUFFER_POOL_ID = p.id
and pf.prefetch_ops > 0
order by
    pf.timestamp
/
