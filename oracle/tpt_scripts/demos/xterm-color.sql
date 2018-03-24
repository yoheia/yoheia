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

col a for a20
col b for a20
col c for a20
col d for a20
col e for a20
col f for a20
col g for a20
col h for a20

select 
    chr(27)||'[40m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' a 
 ,  chr(27)||'[41m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' b
 ,  chr(27)||'[42m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' c
 ,  chr(27)||'[43m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' d
 ,  chr(27)||'[44m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' e
 ,  chr(27)||'[45m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' f
 ,  chr(27)||'[46m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' g
 ,  chr(27)||'[47m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' h
from dual 
    connect by level<=8
union all
select chr(27)||'[0m', null, null, null, null, null, null, null  from dual
union all
select 
    chr(27)||'[32m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' a 
 ,  chr(27)||'[33m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' b
 ,  chr(27)||'[34m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' c
 ,  chr(27)||'[35m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' d
 ,  chr(27)||'[36m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' e
 ,  chr(27)||'[37m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' f
 ,  chr(27)||'[38m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' g
 ,  chr(27)||'[39m'||chr(27)||'[1;'||to_char(rownum+29)||'mTest' h
from dual 
    connect by level<=8
union all
select chr(27)||'[0m', null, null, null, null, null, null, null  from dual
/
