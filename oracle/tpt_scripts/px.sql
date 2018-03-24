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
-- File name:   px.sql
-- Purpose:     Report Pararallel Execution SQL globally in a RAC instance
--              
-- Author:      Tanel Poder
-- Copyright:   (c) http://blog.tanelpoder.com
--              
-- Usage:       @px.sql
--              
--------------------------------------------------------------------------------

SET LINES 999 PAGES 50000 TRIMSPOOL ON TRIMOUT ON TAB OFF 

COL px_qcsid HEAD QC_SID FOR A13
COL px_instances FOR A100

PROMPT Show current Parallel Execution sessions in RAC cluster...

SELECT 
    pxs.qcsid||','||pxs.qcserial# px_qcsid
  , pxs.qcinst_id
  , ses.username
  , ses.sql_id
  , pxs.degree
  , pxs.req_degree
  , COUNT(*) slaves
  , COUNT(DISTINCT pxs.inst_id) inst_cnt
  , MIN(pxs.inst_id) min_inst
  , MAX(pxs.inst_id) max_inst 
  --, LISTAGG ( TO_CHAR(pxs.inst_id) , ' ' ) WITHIN GROUP (ORDER BY pxs.inst_id) px_instances
FROM 
    gv$px_session pxs
  , gv$session    ses
  , gv$px_process p
WHERE
    ses.sid     = pxs.sid
AND ses.serial# = pxs.serial#
AND p.sid       = pxs.sid
AND pxs.inst_id = ses.inst_id
AND ses.inst_id = p.inst_id
--
AND pxs.req_degree IS NOT NULL -- qc
GROUP BY
    pxs.qcsid||','||pxs.qcserial#
  , pxs.qcinst_id
  , ses.username
  , ses.sql_id
  , pxs.degree
  , pxs.req_degree
ORDER BY
    pxs.qcinst_id
  , slaves DESC
/

