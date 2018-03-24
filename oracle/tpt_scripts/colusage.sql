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

prompt Show column usage stats from sys.col_usage$ for table &1..&2....
prompt Did you run DBMS_STATS.FLUSH_DATABASE_MONITORING_INFO for getting latest stats?


select
    c.owner
  , c.table_name
  , c.column_name
  , u.intcol#
  , u.equality_preds       
  , u.equijoin_preds       
  , u.nonequijoin_preds    
  , u.range_preds          
  , u.like_preds           
  , u.null_preds           
  , u.timestamp           
from
    sys.col_usage$ u
  , dba_objects    o
  , dba_tab_cols   c
where
    o.object_id  = u.obj#
and c.owner      = o.owner
and c.table_name = o.object_name
and u.intcol#    = c.internal_column_id
and o.object_type = 'TABLE'
and lower(o.owner) like lower('&1')
and lower(o.object_name) like lower('&2')
order by
    owner
  , table_name
  , column_name
/
