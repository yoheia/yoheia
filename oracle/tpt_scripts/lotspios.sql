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
-- File name:   lotspios.sql
-- Purpose:     Generate Lots of Physical IOs for testing purposes
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @lotspios <number>
--              @lotspios 100
--              @lotspios 1000000
--          
-- Other:       This script just does a full table scan on all tables it can
--              see, thus it generates mainly scattered or direct path reads
--              
--------------------------------------------------------------------------------

prompt Generate lots of physical IOs by full scanning through all available tables...

declare
   str varchar2(1000);
   x number;
begin

   for i in 1..&1 loop
       for t in (select owner, table_name from all_tables where (owner,table_name) not in (select owner,table_name from all_external_tables)) loop
               begin
                       execute immediate 'select /*+ FULL(t) */ count(*) from '||t.owner||'.'||t.table_name||' t' into x;
               exception
                       when others then null;
               end;
       end loop; -- t
    end loop; -- i
end;
/
