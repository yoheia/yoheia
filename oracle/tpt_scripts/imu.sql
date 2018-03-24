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
-- File name:   im.sql
-- Purpose:     Display In-Memory Undo (IMU) buffer usage
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @im.sql
--          
-- Other:       Does only show IMU buffers currently bound to a transaction
--              If you want to see all currently available IMU buffers,
--              remove the WHERE condition
--
--------------------------------------------------------------------------------

prompt Display private in-memory undo (IMU) buffers currently in use in the instance...

SELECT 
       KTIFPNO, 
       KTIFPSTA,
       KTIFPXCB         XCTADDR,
       KTIFPUPB         UBADDR,
       TO_NUMBER(KTIFPUPE, 'XXXXXXXXXXXXXXXX')-TO_NUMBER(KTIFPUPB, 'XXXXXXXXXXXXXXXX')      UBSIZE,
       (TO_NUMBER(KTIFPUPB, 'XXXXXXXXXXXXXXXX')-TO_NUMBER(KTIFPUPC, 'XXXXXXXXXXXXXXXX'))*-1 UBUSAGE,
       KTIFPRPB         RBADDR,
       TO_NUMBER(KTIFPRPE, 'XXXXXXXXXXXXXXXX')-TO_NUMBER(KTIFPRPB, 'XXXXXXXXXXXXXXXX')      RBSIZE,
       (TO_NUMBER(KTIFPRPB, 'XXXXXXXXXXXXXXXX')-TO_NUMBER(KTIFPRPC, 'XXXXXXXXXXXXXXXX'))*-1 RBUSAGE,
       KTIFPPSI,
       KTIFPRBS,
       KTIFPTCN
FROM X$KTIFP
WHERE KTIFPXCB != HEXTORAW('00')
/
