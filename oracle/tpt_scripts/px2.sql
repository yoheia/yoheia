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

COL px_qcsid HEAD QC_SID FOR A13

PROMPT Show current Parallel Execution sessions in RAC cluster...

WITH sq AS (
    SELECT 
        pxs.qcsid||','||pxs.qcserial# px_qcsid
      , pxs.qcinst_id
      , ses.username
      , ses.sql_id
      , pxs.degree
      , pxs.req_degree
      , COUNT(*) slaves
      , COUNT(DISTINCT pxs.inst_id) inst_cnt
      , CASE WHEN pxs.inst_id =  1 THEN 1 ELSE NULL END i01
      , CASE WHEN pxs.inst_id =  2 THEN 1 ELSE NULL END i02
      , CASE WHEN pxs.inst_id =  3 THEN 1 ELSE NULL END i03
      , CASE WHEN pxs.inst_id =  4 THEN 1 ELSE NULL END i04
      , CASE WHEN pxs.inst_id =  5 THEN 1 ELSE NULL END i05
      , CASE WHEN pxs.inst_id =  6 THEN 1 ELSE NULL END i06
      , CASE WHEN pxs.inst_id =  7 THEN 1 ELSE NULL END i07
      , CASE WHEN pxs.inst_id =  8 THEN 1 ELSE NULL END i08
      , CASE WHEN pxs.inst_id =  9 THEN 1 ELSE NULL END i09
      , CASE WHEN pxs.inst_id = 10 THEN 1 ELSE NULL END i10
      , CASE WHEN pxs.inst_id = 11 THEN 1 ELSE NULL END i11
      , CASE WHEN pxs.inst_id = 12 THEN 1 ELSE NULL END i12
      , CASE WHEN pxs.inst_id = 13 THEN 1 ELSE NULL END i13
      , CASE WHEN pxs.inst_id = 14 THEN 1 ELSE NULL END i14
      , CASE WHEN pxs.inst_id = 15 THEN 1 ELSE NULL END i15
      , CASE WHEN pxs.inst_id = 16 THEN 1 ELSE NULL END i16 
    --  , LISTAGG ( TO_CHAR(pxs.inst_id) , ' ' ) WITHIN GROUP (ORDER BY pxs.inst_id) instances
    FROM 
        gv$px_session pxs
      , gv$session    ses
      , gv$px_process p
    WHERE
        ses.sid     = pxs.sid
    AND ses.serial# = pxs.serial#
    AND p.sid     = pxs.sid
    AND pxs.inst_id = ses.inst_id
    AND ses.inst_id = p.inst_id
    --
    AND pxs.req_degree IS NOT NULL -- qc
    GROUP BY
        pxs.qcsid||','||pxs.qcserial#
      , pxs.qcinst_id
      , ses.username
      , ses.sql_id
      --, pxs.inst_id 
      , pxs.degree
      , pxs.req_degree
      , CASE WHEN pxs.inst_id =  1 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id =  2 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id =  3 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id =  4 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id =  5 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id =  6 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id =  7 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id =  8 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id =  9 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id = 10 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id = 11 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id = 12 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id = 13 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id = 14 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id = 15 THEN 1 ELSE NULL END 
      , CASE WHEN pxs.inst_id = 16 THEN 1 ELSE NULL END  
)
/

