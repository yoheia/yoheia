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
-- File name:   demos/bind_peeking.sql
--
-- Purpose:     Advanced Oracle Troubleshooting Seminar demo script
--
-- Author:      Tanel Poder ( http://www.tanelpoder.com )
--
-- Copyright:   (c) 2007-2009 Tanel Poder
--
--------------------------------------------------------------------------------

set echo on

drop table t;
create table t as select * from dba_objects, (select rownum from dual connect by level <= 20);
create index i on t(object_id);

exec dbms_stats.gather_table_stats(user, 'T');

select count(*), min(object_id), max(object_id) from t;

pause

var x number

exec :x := 100000

pause

set timing on

select sum(length(object_name)) from t where object_id > :x;



select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

pause

exec :x := 1

select sum(length(object_name)) from t where object_id > :x;



select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

pause

select sum(length(object_name)) from t where object_id > :x;



select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

set echo off
