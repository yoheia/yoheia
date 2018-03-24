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

-- create tablespace assm
-- extent management local uniform size 1m
-- segment space management auto
-- datafile
-- '/abc/db01/oracle/ABC1P/oradata/assm_01.dbf' size 1000m;

create table test_assm
(
 n1 number,
 v1 varchar2(50),
 v2 varchar2(50),
 v3 varchar2(50),
 v4 varchar2(50),
 v5 varchar2(50),
 v6 varchar2(50),
 v7 varchar2(50),
 v8 varchar2(50),
 v9 varchar2(50),
v10 varchar2(50)
)
tablespace USERS;


begin
for i in 1..1000000 loop
insert into test_assm values
(i,
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567');
end loop;
end;
/

COMMIT;

ALTER SESSION SET plsql_optimize_level = 0;

begin
for i in 1..1000 loop
insert into test_assm values
(i,
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567',
'123456789*123456789*123456789*123456789*1234567');
end loop;
end;
/

PROMPT Deleting all rows from the table, do not commit...

DELETE test_assm;

PROMPT Re-execute script that inserts 1000 rows from a different session - this should be very slow


