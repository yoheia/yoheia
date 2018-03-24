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

COL sqlopt_hash_value HEAD HASH_VALUE
COL sqlopt_sqlid HEAD SQL_ID
COL sqlopt_child# HEAD CHILD#

BREAK ON sqlopt_hash_value SKIP 1 ON sqlopt_sqlid SKIP 1 ON sqlopt_child# SKIP 1

PROMPT Show compilation environment stored inside cursors for SQLID &1 child# &2 parameter &3

SELECT 
--    inst_id
--  , kqlfsqce_phad
    kqlfsqce_hash           sqlopt_hash_value
  , kqlfsqce_sqlid          sqlopt_sqlid
  , kqlfsqce_chno           sqlopt_child#
--  , kqlfsqce_hadd
--  , kqlfsqce_pnum
  , kqlfsqce_pname          parameter
  , UPPER(kqlfsqce_pvalue)  value                                         
  , DECODE(BITAND(kqlfsqce_flags, 2), 0, 'NO', 'YES') "DFLT"
FROM -- v$sql_optimizer_env
    x$kqlfsqce 
WHERE 
    kqlfsqce_sqlid LIKE '&1'
AND kqlfsqce_chno  LIKE ('&2')
AND LOWER(kqlfsqce_pname) LIKE LOWER('%&3%')
ORDER BY
    kqlfsqce_hash
  , kqlfsqce_sqlid
  , kqlfsqce_chno
  , kqlfsqce_pname
/
