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
-- File name:   lotshparses2.sql
-- Purpose:     Generate Lots of hard parses and shared pool activity 
--              for testing purposes
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @lotshparses <number>
--              @lotshparses 100
--              @lotshparses 1000000
--          
-- Other:       You probably don't want to run this in production as it can
--              fill your shared pool with junk and flush out any useful stuff!
--
--------------------------------------------------------------------------------

alter session set plsql_optimize_level = 0;

declare
    x number;
    r varchar2(1000);
begin
    for i in 1..&1 loop
        r := to_char(dbms_random.random);
        execute immediate 'select count(*) from dual where rownum = '||r into x;
        execute immediate 'select count(*) from dual where rownum = '||r into x;
        execute immediate 'select count(*) from dual where rownum = '||r into x;
    end loop;
end;
/
