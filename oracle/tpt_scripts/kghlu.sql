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

col kghluidx head SUB|POOL
col kghludur head SSUB|POOL
col kghlufsh head FLUSHED|CHUNKS
col kghluops head "LRU LIST|OPERATIONS"
col kghlurcr head RECURRENT|CHUNKS
col kghlutrn head TRANSIENT|CHUNKS
col kghlunfu head "FREE UNPIN|UNSUCCESS"
col kghlunfs head "LAST FRUNP|UNSUCC SIZE"
col kghlurcn head RESERVED|SCANS
col kghlurmi head RESERVED|MISSES
col kghlurmz head "RESERVED|MISS SIZE"
col kghlurmx head "RESERVED|MISS MAX SZ"


select
    kghluidx
  , kghludur
  , kghlufsh
  , kghluops
  , kghlurcr
  , kghlutrn
  , kghlunfu
  , kghlunfs
--  , kghlumxa
--  , kghlumes
--  , kghlumer
  , kghlurcn
  , kghlurmi
  , kghlurmz
  , kghlurmx
from
    x$kghlu
order by
    kghluidx
  , kghludur
/
