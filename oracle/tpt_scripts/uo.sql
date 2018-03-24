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

col o_owner heading owner for a25
col o_object_name heading object_name for a30
col o_object_type heading object_type for a15

prompt Listing current user's objects matching %&1%

select 
    object_name o_object_name, 
    object_type o_object_type,
    created, 
    last_ddl_time,
    status
from 
    user_objects
where 
    upper(object_name) like upper('%&1%')
order by 
    o_object_type,
    o_object_name
;

