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

define spuser=&1
define spkeep=&2

prompt

set heading off feedback off
select 'sesspack_purge: removing records older than '|| to_char( sysdate - &spkeep, 'YYYYMMDD HH24:MI:SS') from dual;
set heading on feedback on 

prompt

prompt delete from &spuser..SAWR$SNAPSHOTS where snaptime < sysdate - &spkeep;
delete from &spuser..SAWR$SNAPSHOTS where snaptime < sysdate - &spkeep;
commit;

prompt delete from &spuser..SAWR$SESSIONS where snaptime < sysdate - &spkeep;
delete from &spuser..SAWR$SESSIONS where snaptime < sysdate - &spkeep;
commit;

prompt delete from &spuser..SAWR$SESSION_EVENTS where snaptime < sysdate - &spkeep;
delete from &spuser..SAWR$SESSION_EVENTS where snaptime < sysdate - &spkeep;
commit;

prompt delete from &spuser..SAWR$SESSION_STATS where snaptime < sysdate - &spkeep;
delete from &spuser..SAWR$SESSION_STATS where snaptime < sysdate - &spkeep;
commit;

-- compact the indexes & IOTs for saving space
alter index SAWR$SNAPSHOTS_PK coalesce;
alter table SAWR$SESSIONS move online;
alter table SAWR$SESSION_STATS move online;
alter table SAWR$SESSION_EVENTS move online;

undefine spuser
undefine spkeep
