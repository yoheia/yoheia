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

-- OERR functionality - list description for and ORA- error code
-- The data comes from $ORACLE_HOME/rdbms/mesg/oraus.msb file
-- which is a binary compiled version of $ORACLE_HOME/rdbms/mesg/oraus.msg file


@@saveset
set serverout on size 1000000 feedback off
prompt
exec dbms_output.put_line(sqlerrm(-&1))
prompt
@@loadset
