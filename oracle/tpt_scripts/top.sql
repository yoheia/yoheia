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

-- MOATS TOP script
-- MOATS packages and install code is located in tools/moats directory

-- Following settings should be mandatory and documented...
-- --------------------------------------------------------
set arrays 72
set lines 110
set pagesize 0
set head off
set tab off

-- Windows sqlplus properties for optimal output (relative to font):
--  * font: lucide console 12
--  * window size: height of 47

select * from table(moats.top(5));


