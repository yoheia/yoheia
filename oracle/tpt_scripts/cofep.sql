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

-- Compare Optimizer Features Enable Parameter values
-- By Tanel Poder ( http://www.tanelpoder.com )
--   Requires opt_param_matrix table to be created (using tools/optimizer/optimizer_features_matrix.sql)
--   Requires Oracle 11g due PIVOT clause (but you can rewrite this SQL in earlier versions)`

col pd_name head NAME for a50
col pd_value head VALUE for a30
column pd_descr heading DESCRIPTION format a70 word_wrap


prompt Compare Optimizer_Features_Enable Parameter differences
prompt for values &1 and &2

select m.*, n.ksppdesc pd_descr
from (
    select * 
    from opt_param_matrix 
    pivot( 
        max(substr(value,1,20)) 
        for opt_features_enabled in ('&1','&2')
    ) 
    where "'&1'" != "'&2'"
) m
, sys.x$ksppi n
, sys.x$ksppcv c
where
    n.indx=c.indx
and n.ksppinm = m.parameter
/
 
