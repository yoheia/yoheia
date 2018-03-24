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
    addr
  , set_id
  , dbwr_num       dbwr#
  , flag
  , blk_size
  , proc_group
  , CNUM_SET
  , CNUM_REPL
  , ANUM_REPL
  , CKPT_LATCH
  , CKPT_LATCH1
  , SET_LATCH
  , COLD_HD
  , HBMAX
  , HBUFS 
from 
    X$KCBWDS
WHERE 
    CNUM_SET != 0
/


