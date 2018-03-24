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

column fvar_ksmfsnam heading SGAVARNAME for a30
column fvar_ksmfstyp heading DATATYPE for a30
column fval_ksmmval_dec heading VALUE_DEC for 999999999999990

select /*+ ORDERED USE_NL(m) NO_EXPAND */
    f.addr
  , f.indx
  , f.ksmfsnam fvar_ksmfsnam
  , f.ksmfstyp fvar_ksmfstyp
  , f.ksmfsadr
  , f.ksmfssiz
  , m.ksmmmval
  , to_number(rawtohex(m.ksmmmval), 'XXXXXXXXXXXXXXXX') fval_ksmmval_dec
/*  ,  (select ksmmmval from x$ksmmem where addr = hextoraw(
                                                    to_char(
                                                        to_number(
                                                            rawtohex(f.ksmfsadr),
                                                            'XXXXXXXX'
                                                        ) + 0,
                                                    'XXXXXXXX')
                                                ) 
    ) ksmmmval2 */
from
    x$ksmfsv f
  , x$ksmmem m
where
    f.ksmfsadr = m.addr
and (rawtohex(m.ksmmmval) like upper('&1'))
order by
    ksmfsnam
/
