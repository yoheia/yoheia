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
-- File name:   demos/cse.sql
--
-- Purpose:     Advanced Oracle Troubleshooting Seminar demo script
--
--              Demonstrating common subexpression elimination transformation
--
-- Author:      Tanel Poder ( http://www.tanelpoder.com )
--
-- Copyright:   (c) 2007-2009 Tanel Poder
--
--------------------------------------------------------------------------------

set serverout on size 1000000

create or replace function imhere( par in varchar2 )
    return varchar2
as
begin
    dbms_output.put_line('i''m here!: '||par);
    return par;
end;
/


@pd eliminate_common_subexpr

set echo on

select /*+ ORDERED_PREDICATES tanel1 */ * 
from dual 
where 
   (imhere(dummy) = 'X' and length(dummy) = 10) 
or (imhere(dummy) = 'X' and length(dummy) = 11)
/

alter session set "_eliminate_common_subexpr"=false;

select /*+ ORDERED_PREDICATES tanel2 */ * 
from dual 
where 
   (imhere(dummy) = 'X' and length(dummy) = 10) 
or (imhere(dummy) = 'X' and length(dummy) = 11)
/

set echo off

select /*+ tanel3 */ * 
from dual 
where 
   (imhere(dummy) = 'X' and length(dummy) = 10) 
or (imhere(dummy) = 'X' and length(dummy) = 11)
/
