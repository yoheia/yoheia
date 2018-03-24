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

column fv_ksmfsnam heading SGAVARNAME for a50 wrap
column fv_ksmfstyp heading DATATYPE for a25 wrap
column fv_ksmmval_dec heading KSMMVAL_DEC for 99999999999999999999

prompt Display Fixed SGA Variables matching &1

select /*+ ORDERED USE_NL(m) */
    f.addr
  , f.indx
  , f.ksmfsnam fv_ksmfsnam
  , to_number(m.ksmmmval, 'XXXXXXXXXXXXXXXX') fv_ksmmval_dec
  , m.ksmmmval
  , f.ksmfstyp fv_ksmfstyp
  , f.ksmfsadr
  , f.ksmfssiz 
from 
    x$ksmfsv f, x$ksmmem m
where 
    f.ksmfsadr = m.addr
and (lower(ksmfsnam) like lower('&1') or lower(ksmfstyp) like lower('&1'))
order by
    ksmfsnam
/



