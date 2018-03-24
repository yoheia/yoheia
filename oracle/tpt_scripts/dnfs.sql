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

COL svrname FOR A20
COL dirname FOR A20
COL filename FOR A60
COL path    FOR A20
COL local   FOR A20

--SELECT 'MY_STATS' my_stats, s.* FROM v$dnfs_stats s WHERE pnum = (SELECT pid FROM v$process WHERE addr = (SELECT paddr FROM v$session WHERE sid = SYS_CONTEXT('USERENV', 'SID')));
SELECT 'STATS   ' my_stats, s.* FROM v$dnfs_stats s WHERE pnum IN (SELECT pnum FROM v$dnfs_channels) ORDER BY pnum;
SELECT 'SERVERS ' servers, s.* FROM v$dnfs_servers s;
SELECT 'CHANNELS' channels, c.* FROM v$dnfs_channels c;
SELECT 'FILES   ' files, f.* FROM v$dnfs_files f;

