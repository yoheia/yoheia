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

-- blcass.sql by Tanel Poder (http://blog.tanelpoder.com)
--
-- Usage: @bclass <block_class#>

--with undostart as (select r from (select rownum r, class from v$waitstat) where class = 'undo header')

select class, r undo_segment_id from (
    select class, null r
    from (select class, rownum r from v$waitstat) 
    where r = bitand(&1,to_number('FFFF','XXXX'))
    union all
    select 
        decode(mod(bitand(&1,to_number('FFFF','XXXX')) - 17,2),0,'undo header',1,'undo data', 'error') type 
      , trunc((bitand(&1,to_number('FFFF','XXXX')) - 17)/2) undoseg_id
    from 
        dual
)
where rownum = 1
/
