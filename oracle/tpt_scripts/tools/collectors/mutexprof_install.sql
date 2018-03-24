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

drop table mutexprof_history;

create table mutexprof_history
    tablespace users
as
select 
    *
from
    x$mutex_sleep_history
where
    1=0
/

create or replace package mutexprof as
    procedure snap_mutex_sleeps(p_sleep in number default 1);
end mutexprof;
/
show err

create or replace package body mutexprof as

    procedure snap_mutex_sleeps(p_sleep in number default 1) as
        lv_max_sleep_timestamp timestamp := systimestamp;
        type typ is table of x$mutex_sleep_history%rowtype;
        t typ;
    begin

        while true loop

          select * bulk collect into t
          from x$mutex_sleep_history
          where sleep_timestamp > lv_max_sleep_timestamp;
          
          -- get max timestamp so next time we can ignore these rows
          for r in 1 .. t.count loop
              if t(r).sleep_timestamp > lv_max_sleep_timestamp then
                  lv_max_sleep_timestamp := t(r).sleep_timestamp;
              end if;
          end loop;  

          -- insert
          forall r in 1 .. t.count 
             insert into mutexprof_history values t(r);

          commit;
          dbms_lock.sleep(p_sleep);

      end loop; -- while true

  end snap_mutex_sleeps;

end mutexprof;
/
show err

