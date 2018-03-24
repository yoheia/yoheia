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
-- Author:	Tanel Poder
-- Copyright:	(c) http://www.tanelpoder.com
-- 
-- Notes:	This software is provided AS IS and doesn't guarantee anything
-- 		Proofread before you execute it!
--
--------------------------------------------------------------------------------

define spuser=PERFSTAT
define spconn=""

accept spuser default &spuser prompt "Specify the schema where SAWR and SESSPACK are installed [&spuser]: "
accept sppassword prompt "Specify the password for &spuser user: " hide
accept spconn prompt "Enter connect string PREFIXED WITH @ if connecting to remote database [&spconn]: "

-- @@unprepare_user

connect &spuser/&sppassword&spconn

prompt Uninstalling schema...


@@drop_sesspack_packages.sql
@@drop_sesspack_schema.sql

prompt Schema uninstalled.
prompt 


prompt Uninstallation completed.
prompt Currently connected as &spuser&spconn....
prompt
