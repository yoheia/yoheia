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

DEF datafile="/u02/oradata/SOL102/ppx01.dbf"

DEF ppxuser=PPX
DEF oeuser=SOE
DEF shuser=SH
DEF ppxtablespace=PPX

PROMPT Creating the user and tablespaces...

--CREATE TABLESPACE ppx DATAFILE SIZE 100M AUTOEXTEND ON NEXT 10M;
--CREATE USER &ppxuser IDENTIFIED BY oracle DEFAULT TABLESPACE &ppxtablespace TEMPORARY TABLESPACE temp;
--GRANT create session, select any dictionary, dba TO &ppxuser;

-- Create clone tables
@range_part
@range_hash_subpart
@range_id_part

