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
-- Author:	Tanel Poder
-- Copyright:	(c) http://www.tanelpoder.com
-- 
-- Notes:	This software is provided AS IS and doesn't guarantee anything
-- 		Proofread before you execute it!
--
--------------------------------------------------------------------------------

--set lines 156

column sawr_list_takenby heading "Taken By" format a20
column sawr_list_snapid heading "Snap ID" format 9999999
column sawr_list_snaptime heading "Snapshot Time" format a20
column sawr_session_count heading "Snapped|Sessions" format 9999999
column sawr_snap_mode heading "Snapshot|Mode" format a40

select
	snap.snapid	sawr_list_snapid,
	to_char(snap.snaptime, 'YYYY-MM-DD HH24:MI:SS') sawr_list_snaptime,
	snap.takenby	sawr_list_takenby,
	snap.snap_mode	sawr_snap_mode,
	count(*)	sawr_session_count
from
	sawr$snapshots	snap,
	sawr$sessions	sess
where
	snap.snapid = sess.snapid
group by
	snap.snapid,
	to_char(snap.snaptime, 'YYYY-MM-DD HH24:MI:SS'),
	snap.snap_mode,
	snap.takenby
order by
	to_char(snap.snaptime, 'YYYY-MM-DD HH24:MI:SS')
/
