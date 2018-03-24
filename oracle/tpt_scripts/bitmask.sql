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

select
    level - 1 bit
   ,DECODE(bitand(to_number('&1','XXXXXXXXXXXXXXXX'),power(2,level-1)),0,0,1) is_set
   ,to_char(power(2,level-1),'XXXXXXXXXXXXXXXX') val_hex
   ,bitand(to_number('&1','XXXXXXXXXXXXXXXX'),power(2,level-1)) val_dec
from 
    dual
where
    DECODE(bitand(to_number('&1','XXXXXXXXXXXXXXXX'),power(2,level-1)),0,0,1) != 0
connect by
    level <= (select log(2,to_number('&1','XXXXXXXXXXXXXXXX'))+2 from dual)
/
