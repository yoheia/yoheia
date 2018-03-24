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

col pd_name head NAME for a54
col pd_value head VALUE for a30
column pd_descr heading DESCRIPTION format a70 word_wrap

Prompt Show all parameters and session values from x$ksppi/x$ksppcv...

select 
   n.indx + 1 num
 , to_char(n.indx + 1, 'XXXX') n_hex
 , n.ksppinm pd_name
 , c.ksppstvl pd_value
 , n.ksppdesc pd_descr
from sys.x$ksppi n, sys.x$ksppcv c
where n.indx=c.indx
and (
--   lower(n.ksppinm) || ' ' || lower(n.ksppdesc) like lower('&1') 
--   or lower(n.ksppdesc) like lower('&1')
     n.indx + 1 in (&1)
);
