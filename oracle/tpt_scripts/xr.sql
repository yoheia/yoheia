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

set termout off

set markup HTML ON HEAD "<style type='text/css'> body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White; } p {font:10pt Arial,Helvetica,sans-serif; color:black; background:White; white-space: pre; } table,tr,td {font:10pt Courier New,Courier,fixed,Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px; white-space: pre;} th {font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; padding:0px 0px 0px 0px;} h1 {font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} h2 {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;} a {font:9pt Arial,Helvetica,sans-serif; color:#663300; background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;}</style><title>&1</title>" BODY "" TABLE "border='1' align='center' summary='Script output'" SPOOL ON ENTMAP OFF PREFORMAT OFF

set feedback off
spool %SQLPATH%\tmp\output_&_connect_identifier..xls

clear buffer
--prompt &1
1 &1
/

spool off
set markup html off spool off feedback on

host start %SQLPATH%\tmp\output_&_connect_identifier..xls
set termout on
