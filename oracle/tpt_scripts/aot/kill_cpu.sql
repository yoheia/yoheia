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

prompt
prompt Jonathan Lewis'es kill_cpu script
prompt

set termout off

--drop table kill_cpu;

create table kill_cpu (n, primary key(n)) organization index 
as 
select rownum n 
from all_objects 
where rownum <= 50
; 

set termout on echo on

alter session set "_old_connect_by_enabled"=true;

select count(*) X 
from kill_cpu 
connect by n > prior n 
start with n = 1 
; 

set echo off
