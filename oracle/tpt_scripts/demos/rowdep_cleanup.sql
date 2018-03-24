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

drop table t;

Prompt Creating table with NO rowdependencies...


create table t tablespace users as select * From dba_objects;

update t set object_id = 1;

alter system flush buffer_cache;

@db
commit;

pause Press any key to select count(*) from t...

select distinct ora_rowscn from t;

pause Done. Press any key to continue...

drop table t;

Prompt Creating table WITH rowdependencies...


create table t tablespace users ROWDEPENDENCIES as select * From dba_objects;

update t set object_id = 1;

alter system flush buffer_cache;

@db
commit;

pause Press any key to select count(*) from t...

select distinct ora_rowscn from t;
