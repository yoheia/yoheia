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
-- File name:   demo3.sql
--
-- Purpose:     Advanced Oracle Troubleshooting Seminar demo script
--              Causes a session hang by reading from external table
--              which in turn reads from a Unix named pipe. Before 11.1.0.7
--              this wait was uninstrumented.
--
-- Author:      Tanel Poder ( http://www.tanelpoder.com )
-- Copyright:   (c) Tanel Poder
--
-- Notes:       Meant to be executed from an Unix/Linux Oracle DB server
--
--------------------------------------------------------------------------------

prompt Running demo3...

set feedback off termout off

CREATE OR REPLACE DIRECTORY mydir AS '/tmp';

host rm -f /tmp/myfile

host mknod /tmp/myfile p

DROP TABLE mytab;

CREATE TABLE mytab (
	a int
)
ORGANIZATION EXTERNAL (
	TYPE oracle_loader
	DEFAULT DIRECTORY mydir
	ACCESS PARAMETERS (
		RECORDS DELIMITED BY NEWLINE
		FIELDS TERMINATED BY ','
	(a)
	)
	LOCATION ('myfile')
)
/

select * from mytab;

set feedback on termout on

drop table mytab;

