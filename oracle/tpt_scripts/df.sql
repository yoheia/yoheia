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

-------------------------------------------------------------------------------------------
-- SCRIPT:  DF.SQL
-- PURPOSE: Show Oracle tablespace free space in Unix df style
-- AUTHOR:  Tanel Poder [ http://www.tanelpoder.com ]
-- DATE:    2003-05-01
-------------------------------------------------------------------------------------------

col "% Used" for a6
col "Used" for a22

select t.tablespace_name, t.gb "TotalGB", t.gb - nvl(f.gb,0) "UsedGB", nvl(f.gb,0) "FreeGB"
       ,lpad(ceil((1-nvl(f.gb,0)/decode(t.gb,0,1,t.gb))*100)||'%', 6) "% Used", t.ext "Ext", 
       '|'||rpad(lpad('#',ceil((1-nvl(f.gb,0)/decode(t.gb,0,1,t.gb))*20),'#'),20,' ')||'|' "Used"
from (
  select tablespace_name, trunc(sum(bytes)/(1024*1024*1024)) gb
  from dba_free_space
  group by tablespace_name
 union all
  select tablespace_name, trunc(sum(bytes_free)/(1024*1024*1024)) gb
  from v$temp_space_header
  group by tablespace_name
) f, (
  select tablespace_name, trunc(sum(bytes)/(1024*1024*1024)) gb, max(autoextensible) ext
  from dba_data_files
  group by tablespace_name
 union all
  select tablespace_name, trunc(sum(bytes)/(1024*1024*1024)) gb, max(autoextensible) ext
  from dba_temp_files
  group by tablespace_name
) t
where t.tablespace_name = f.tablespace_name (+)
order by t.tablespace_name;

