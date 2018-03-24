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

create table t PCTFREE 0 as select * from dba_source, (select 1 from dual connect by level<=5);
--create table t PCTFREE 0 as select * from dba_source;

-- deliberately using analyze table command to compute the number of chained rows
analyze table t compute statistics;
select num_rows,blocks,empty_blocks,chain_cnt from user_tables where table_name = 'T';

update t set owner = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' where rownum <= 100000;
commit;

update t set owner = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' where rownum <= 100000;
commit;

update t set owner = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' where rownum <= 100000;
commit;

update t set owner = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' where rownum <= 100000;
commit;

update t set owner = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' where rownum <= 100000;
commit;

update t set owner = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' where rownum <= 100000;
commit;

analyze table t compute statistics;
select num_rows,blocks,empty_blocks,chain_cnt from user_tables where table_name = 'T';

--exec dbms_stats.gather_table_stats(user,'T');

pause About to create the index, run snapper in another window on this session. Press ENTER to continue...

create index i on t(case when owner = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' then owner else null end) online;


