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

COL sqlfn_descr HEAD DESCRIPTION FOR A100 WORD_WRAP
COL sqlfn_name  HEAD NAME FOR A30

SELECT
    func_id
  , name sqlfn_name
  , offloadable
--  , usage
  , minargs
  , maxargs
    -- this is just to avoid clutter on screen
  , CASE WHEN name != descr THEN descr ELSE null END sqlfn_descr 
FROM
    v$sqlfn_metadata 
WHERE 
    UPPER(name) LIKE UPPER('%&1%')
/

