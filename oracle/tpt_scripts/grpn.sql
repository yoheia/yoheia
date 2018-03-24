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
-- File name:   grpn.sql
-- Purpose:     Quick group by query for aggregating Numeric columns
--              Calculate sum,min,max,avg,count for simple expressions
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @grpn <agg_col> <from_table> <filter_cond> <group_by_cols>
--              @grpn bytes dba_segments tablespace_name='SYSTEM' owner,segment_type
-- 	        
--	        
--------------------------------------------------------------------------------


select 
    &4,
    count(&1),
    count(distinct &1) DISTCNT,
    sum(&1),
    avg(&1),
    min(&1),
    max(&1)
from
    &2
where
    &3
group by --rollup
    ( &4 )
/

