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

-- script	: trim_database.sql
-- purpose	: print alter database commands for trimming database files
-- author	: tanel poder 2006
-- issues	: doesnt resize tablespaces with no extents in them at all

with query as (
    select /*+ NO_MERGE MATERIALIZE */ 
        file_id, 
        tablespace_name,
        max(block_id + blocks) highblock
    from 
        dba_extents
    group by 
        file_id, tablespace_name
)
select 
    'alter database datafile '|| q.file_id || ' resize ' || ceil ((q.highblock * t.block_size + t.block_size)/1024)  || 'K;' cmd
from 
    query q,
    dba_tablespaces t
where
    q.tablespace_name = t.tablespace_name;



