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

SELECT
     hladdr
--  , blsiz
--  , nxt_hash
--  , prv_hash
--  , nxt_repl
--  , prv_repl
  , flag
  , rflag
  , sflag
  , lru_flag
  , ts#
  , file#
--  , dbarfil
  , dbablk
  , class
  , state
  , mode_held
  , changes
  , cstate
  , le_addr
  , dirty_queue
  , set_ds
  , obj
  , ba
  , cr_scn_bas
  , cr_scn_wrp
  , cr_xid_usn
  , cr_xid_slt
  , cr_xid_sqn
  , cr_uba_fil
  , cr_uba_blk
  , cr_uba_seq
  , cr_uba_rec
  , cr_sfl
  , cr_cls_bas
  , cr_cls_wrp
  , lrba_seq
  , lrba_bno
  , hscn_bas
  , hscn_wrp
  , hsub_scn
  , us_nxt
  , us_prv
  , wa_nxt
  , wa_prv
  , obj_flag
  , tch
  , tim
FROM
    x$bh
WHERE
    obj IN (&1)
/

