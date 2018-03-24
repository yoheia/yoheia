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

-- KTU Xact Entry table

SELECT
    ktuxeusn            usn#     -- 65535 = no-undo transaction
  , ktuxeslt            slot#    -- 65535 = invalid slot#
  , ktuxesqn            seq#
  , ktuxesta            status
  , ktuxecfl            flags
  , ktuxesiz            undo_blks
  , ktuxerdbf           curfile 
  , ktuxerdbb           curblock
  , ktuxescnw * power(2, 32) + ktuxescnb cscn -- commit/prepare commit SCN
  , ktuxeuel            
  -- distributed xacts
  --, ktuxeddbf           r_rfile
  --, ktuxeddbb           r_rblock
  --, ktuxepusn           r_usn#
  --, ktuxepslt           r_slot#
  --, ktuxepsqn           r_seq#
FROM
    x$ktuxe
WHERE ktuxesta != 'INACTIVE'
ORDER BY
    ktuxeusn
  , ktuxeslt
/
