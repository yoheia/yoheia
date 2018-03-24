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

-- Original by William Robertson but modified by Tanel - added the varying array filter
-- in comment section: http://awads.net/wp/2005/10/13/pre-defined-collection-types-in-oracle/

SELECT ct.owner, ct.type_name, ct.elem_type_name, ct.length
FROM   all_coll_types ct
     , all_types ot
WHERE  ct.coll_type IN ('TABLE', 'VARYING ARRAY')
AND    ot.type_name(+) = ct.elem_type_name
AND    ot.owner(+) = ct.elem_type_owner
AND    ot.type_name IS NULL
ORDER BY ct.owner, ct.type_name
/

