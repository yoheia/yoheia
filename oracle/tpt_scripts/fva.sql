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

column fva_ksmfsnam heading SGAVARNAME for a20
column fva_ksmfstyp heading DATATYPE for a20
column fva_ksmmval_dec heading KSMMVAL_DEC for 99999999999999999999

select /*+ LEADING(f) USE_NL(m) USE_CONCAT */
    f.addr, 
    f.indx, 
    f.ksmfsnam fva_ksmfsnam, 
    f.ksmfstyp fva_ksmfstyp, 
    f.ksmfsadr, 
    f.ksmfssiz, 
    m.ksmmmval,
    to_number(m.ksmmmval, 'XXXXXXXXXXXXXXXX') fva_ksmmval_dec
from 
    x$ksmfsv f, 
    x$ksmmem m
where 
    f.ksmfsadr = m.addr
and (
        f.ksmfsadr = hextoraw( lpad(substr(upper('&1'), instr(upper('&1'), 'X')+1), vsize(f.addr)*2, '0') ) 
        or 
        m.ksmmmval = hextoraw( lpad(substr(upper('&1'), instr(upper('&1'), 'X')+1), vsize(f.addr)*2, '0') )
    )
order by
    ksmfsnam
/

