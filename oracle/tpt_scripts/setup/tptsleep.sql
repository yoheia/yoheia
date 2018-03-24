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
-- File name:   tptsleep

-- Purpose:     Create tpt$sleep function which allows sleeping during SQL 
--              execution
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       select a,b,c,tpt$sleep(10) from t

--
-- Other:       Used for high frequency V$/X$ sampling via plain SQL
--
--------------------------------------------------------------------------------

create or replace function tptsleep (sec in number default 1) return number as
--------------------------------------------------------------------------------
-- tpt$sleep by Tanel Poder ( http://www.tanelpoder.com )
--------------------------------------------------------------------------------
begin
     dbms_lock.sleep(sec);
     return 1;
end;
/

grant execute on tptsleep to public;

begin
    execute immediate 'drop public synonym tptsleep';
exception
    when others then null;
end;
/

create public synonym tptsleep for tptsleep;
