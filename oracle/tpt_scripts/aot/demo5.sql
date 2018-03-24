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
-- File name:   demo5.sql
--
-- Purpose:     Advanced Oracle Troubleshooting Seminar demo script
--              Causes a session hang by creating a pipe instead of a tracefile
--              and enabling tracing then
--
-- Author:      Tanel Poder ( http://www.tanelpoder.com )
-- Copyright:   (c) Tanel Poder
--
-- Notes:       Meant to be executed from an Unix/Linux Oracle DB server
--              Requires the TPT toolset login.sql to be executed (via putting
--              TPT directory into SQLPATH) so that &trc variable would be
--              initialized with tracefile name.
--
--------------------------------------------------------------------------------

prompt Starting demo5...

host mknod &trc p

alter session set sql_trace=true;

select * from dual;

