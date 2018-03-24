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

set head off feedback off
select 'grant '||granted_role||' to '||grantee||decode(admin_option, 'YES', ' WITH ADMIN OPTION;',';') cmd from dba_role_privs where upper(grantee) like upper('%&1%');
select 'grant '||privilege||' to '||grantee||decode(admin_option, 'YES', ' WITH ADMIN OPTION;',';') cmd from dba_sys_privs where upper(grantee) like upper('%&1%');
select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||grantee||decode(grantable, 'YES', ' WITH GRANT OPTION;',';') cmd from dba_tab_privs where upper(grantee) like upper('%&1%');
set head on feedback on
