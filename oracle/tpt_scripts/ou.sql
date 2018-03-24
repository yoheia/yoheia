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

col o_owner heading OWNER for a25
col o_object_name heading OBJECT_NAME for a30
col o_object_type heading OBJECT_TYPE for a18
col o_status heading STATUS for a9

prompt Listing Other Users objects where username matches %&1% and object matches %&2%

select 
    owner o_owner,
    object_name o_object_name, 
    object_type o_object_type,
    created, 
    last_ddl_time,
    status o_status
from 
    dba_objects 
where 
    upper(owner) like upper('%&1%')
and upper(object_name) like upper('%&2%')
order by 
    o_object_name,
    o_owner,
    o_object_type
;

