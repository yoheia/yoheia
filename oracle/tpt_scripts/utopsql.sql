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

@@saveset
set serveroutput on size 1000000

declare
    curr_sqlhash number;

    sqlhashes sys. 

begin
    for i in 1..50 loop
        select sql_hash_value into curr_sqlhash
        from v$session where sid = &1;   

        dbms_output.put_line(to_char(curr_sqlhash));

        dbms_lock.sleep(0.1);
    end loop;
end;
/

@@loadset
