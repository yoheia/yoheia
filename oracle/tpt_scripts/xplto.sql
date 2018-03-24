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

prompt Show execution plan operations and options matching &1 (11g+)

SELECT RPAD('OPERATION',20) "TYPE", indx, TO_CHAR(indx,'XX') hex, xplton_name FROM x$xplton WHERE lower(xplton_name) LIKE lower('%&1%')
UNION ALL
SELECT 'OPTION', indx, TO_CHAR(indx,'XX'), xpltoo_name FROM x$xpltoo WHERE lower(xpltoo_name) LIKE lower('%&1%')
/
 
