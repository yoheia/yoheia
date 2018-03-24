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

col dblinks_owner head OWNER for a20
col dblinks_db_link head DB_LINK for a40
col dblinks_username head USERNAME for a20
col dblinks_host head HOST for a40

select 
	owner dblinks_owner,
	db_link dblinks_db_link,
	username dblinks_username,
	host dblinks_host,
	created
from
	dba_db_links;
