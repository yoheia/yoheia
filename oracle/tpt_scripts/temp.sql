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

COL temp_username FOR A20 HEAD USERNAME
COL temp_tablespace FOR A20 HEAD TABLESPACE

SELECT 
    u.inst_id
  , u.username   temp_username
  , s.sid
  , u.session_num serial#
  , u.sql_id
  , u.tablespace temp_tablespace
  , u.contents
  , u.segtype
  , ROUND( u.blocks * t.block_size / (1024*1024) ) MB
  , u.extents
  , u.blocks
FROM 
    gv$tempseg_usage u
  , gv$session s
  , dba_tablespaces t
WHERE
    u.session_addr = s.saddr
AND u.inst_id = s.inst_id
AND t.tablespace_name = u.tablespace
ORDER BY
    mb DESC
/

