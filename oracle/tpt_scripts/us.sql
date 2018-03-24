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

col username for a25
col default_Tablespace for a25
col temp_tablespace for a20

prompt Show database usernames from dba_users matching %&1%

select 
	username, 
	default_tablespace, 
	temporary_tablespace, 
	user_id,
	created,
	profile
from 
	dba_users 
where 
	upper(username) like upper('%&1%');
