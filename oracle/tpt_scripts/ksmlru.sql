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

col ksmlridx head IDX for 99
col ksmlrdur head DUR for 99
col ksmlrshrpool head SP for a2

select
    KSMLRIDX        
  , KSMLRDUR        
  , KSMLRNUM          flushed
--  , decode(KSMLRSHRPOOL,1,'Y','N') ksmlrshrpool
  , KSMLRCOM          alloc_comment
  , KSMLRSIZ          alloc_size
  , KSMLRHON          object_name
  , KSMLROHV          hash_value
  , KSMLRSES          ses_addr
--  , KSMLRADU
--  , KSMLRNID
--  , KSMLRNSD
--  , KSMLRNCD
--  , KSMLRNED
from
    x$ksmlru
where
    ksmlrnum > 0
order by
    ksmlrnum desc
/
