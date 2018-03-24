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
-- File name:   kglbroken.sql
-- Purpose:     
-- Purpose:     Report broken kgl locks for an object this can be used for 
--              identifying which sessions would get ORA-04068 "existing state 
--              of packages has been discarded" errors due a change
--              in some object definition (such pl/sql package recompilation)
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @kglbroken <owner> <object>
--
--
--------------------------------------------------------------------------------


select decode(substr(banner, instr(banner, 'Release ')+8,1), '1', 256,  1) kglbroken_flg 
from v$version 
where rownum = 1

select 
   sid,serial#,username,program 
from 
   v$session 
where 
   saddr in (select /*+ no_unnest */ kgllkuse 
             from x$kgllk 
             where 
                 kglnahsh in (select /*+ no_unnest */ kglnahsh 
                              from x$kglob 
                              where 
                                   upper(kglnaown) like upper('&1') 
                              and  upper(kglnaobj) like upper('&2')
                             ) 
             and bitand(kgllkflg,256)=256
   )
/
