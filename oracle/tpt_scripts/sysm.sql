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

COL sysm_group_name HEAD METRICGROUP FOR A30

prompt Display SYSTEM metrics from V$METRIC

select
   mg.name sysm_group_name
 , ROUND(mg.interval_size/100) seconds
 , m.metric_name
 , ROUND(m.value,2) value
 , m.metric_unit
from
   v$metric m
 , v$metricgroup mg
where
   1=1
and m.group_id = mg.group_id
and mg.name like 'System Metrics % Duration'
and lower(m.metric_name) like lower('%&1%')
/

