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

col bhobjects_owner head OWNER for a30
col bhobjects_object_name head OBJECT_NAME for a30
col bhobjects_subobject_name head SUBOBJECT_NAME for a30
col bhobjects_object_type head OBJECT_TYPE for a20 word_wrap



select * from (
    select
        count(*) buffers
      , o.owner                bhobjects_owner
      , o.object_name          bhobjects_object_name
      , o.subobject_name       bhobjects_subobject_name
      , o.object_type          bhobjects_object_type
    from
        v$bh bh
      , dba_objects o
    where 
        bh.objd = o.data_object_id
    group by
        o.owner, o.object_name, o.subobject_name, o.object_type
    order by 
        buffers desc
)
where rownum <=30
/

