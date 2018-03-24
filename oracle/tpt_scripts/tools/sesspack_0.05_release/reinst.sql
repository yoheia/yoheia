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

define spuser=perfstat
define sphost=ora92
define sppass=oracle
define sysuser=sys
define syspass=oracle

connect &spuser/&sppass@&sphost

column sesspack_v9 noprint new_value version_9_enable
column sesspack_v10 noprint new_value version_10_enable

with SQ as (
	select  substr(
		substr(banner, instr(banner, 'Release ')+8),
		1,
		instr(substr(banner, instr(banner, 'Release ')+8),'.')-1
	) db_version
	from v$version 
	where rownum = 1
)
select 
	case when db_version = '9' then '--' else '/*' end sesspack_v9,
	case when db_version = '10' then '--' else '/*' end sesspack_v10
from sq;



prompt Uninstalling schema...


@@drop_sesspack_packages.sql
@@drop_sesspack_schema.sql

--connect &sysuser/&syspass@&sphost

-- @@prepare_user.sql

-- connect &spuser/oracle

prompt Installing schema...

@@install_sesspack_schema.sql
@@install_sesspack_packages.sql
@@install_grants_syns.sql

-- connect / as sysdba
