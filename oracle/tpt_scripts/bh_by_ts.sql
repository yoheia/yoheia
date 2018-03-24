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

SELECT t.tablespace_name, b.ts#, t.block_size, b.status, COUNT(*) num_bufs, ROUND(COUNT(*) * t.block_size / 1048576) pool_mb FROM v$bh b, dba_tablespaces t, v$tablespace vt WHERE b.ts# = vt.ts# AND vt.name = t.tablespace_name GROUP BY t.tablespace_name, b.ts#, t.block_size, b.status ORDER BY COUNT(*) DESC;


