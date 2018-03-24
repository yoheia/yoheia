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

DEF datafile_dir=/export/home/oracle/oradata/SOL102

-- CREATE TABLESPACE ast DATAFILE '&datafile_dir/ast.01.dbf' SIZE 200M AUTOEXTEND ON;
CREATE BIGFILE TABLESPACE ast DATAFILE SIZE 200M AUTOEXTEND ON;

CREATE USER ast IDENTIFIED BY ast DEFAULT TABLESPACE ast TEMPORARY TABLESPACE temp;

ALTER USER ast QUOTA UNLIMITED ON ast;

GRANT CREATE SESSION TO ast;
GRANT CONNECT, RESOURCE TO ast;
GRANT SELECT ANY DICTIONARY TO ast;

GRANT EXECUTE ON DBMS_LOCK TO ast;
GRANT EXECUTE ON DBMS_MONITOR  TO ast;

GRANT EXECUTE ON DBMS_SQLTUNE TO ast;
GRANT EXECUTE ON DBMS_WORKLOAD_REPOSITORY TO ast;

-- for testing
GRANT DBA TO ast;

