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

--prompt Running DBMS_SQLTUNE.REPORT_SQL_MONITOR for SID &3....

SET HEADING OFF

SELECT
	DBMS_SQLTUNE.REPORT_SQL_MONITOR(   
	   &3=>&4,   
	   report_level=>'&1',
	   type => '&2') as report   
FROM dual
/

SET HEADING ON

