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

COL owner FOR A15
COL object_name FOR A30

SELECT
    o.owner
  , o.object_name
  , o.object_type
  , ROUND(ih.rowcnt / NULLIF(ih.leafcnt,0)) avg_rows_per_block
  , ih.rowcnt
  , ih.leafcnt
  , ih.lblkkey
  , ih.dblkkey
  , ih.blevel
FROM
    dba_objects o
  , sys.wri$_optstat_ind_history ih
WHERE
    o.object_id = ih.obj#
AND o.object_type LIKE 'INDEX%'
AND o.object_name LIKE '&1'
ORDER BY
    ih.savtime
/ 
