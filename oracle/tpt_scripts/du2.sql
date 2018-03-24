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

col du_MB head MB FOR 99999999.9
col du_GB head GB FOR 99999999.9
col du_owner HEAD OWNER FOR A30

select
    owner              du_owner
  , sum(bytes)/1048576 du_MB
  , sum(bytes)/1048576/1024 du_GB
from
    dba_segments
where
    lower(owner) like lower('&1')
group by
    owner
order by
    du_MB desc
/
