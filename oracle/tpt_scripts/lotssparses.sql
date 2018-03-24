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
-- File name:   lotssparses.sql
-- Purpose:     Generate Lots of soft parses and library cache/mutex activity 
--              for testing purposes
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @lotsparses <number>
--              @lotsparses 100
--              @lotsparses 1000000
--	        
-- Other:       You probably don't want to run this in production as it can
--              fill your shared pool with junk and flush out any useful stuff!
--
--------------------------------------------------------------------------------

declare
    x number;
begin
    for i in 1..&1 loop
    	execute immediate 'select count(*) cnt from dual x1 where rownum = 1';
    end loop;
end;
/
