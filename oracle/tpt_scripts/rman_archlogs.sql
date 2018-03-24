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

select al.thread#, al.sequence#, al.first_change#, al.blocks * al.block_size "Size kB", bp.handle backup_piece
from 
    v$backup_redolog al, 
    v$backup_set bs, 
    v$backup_piece bp
where
    al.recid = bs.recid
and bs.recid = bp.recid
and al.stamp = bs.stamp
and bs.stamp = bp.stamp
and al.sequence# between 8000 and 8600;