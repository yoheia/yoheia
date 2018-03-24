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

col p_name head NAME for a40
col p_value head VALUE for a40
col p_descr head DESCRIPTION for a80

select n.ksppinm p_name, c.ksppstvl p_value
from sys.x$ksppi n, sys.x$ksppcv c
where n.indx=c.indx
and lower(n.ksppinm) like lower('%&1%');
