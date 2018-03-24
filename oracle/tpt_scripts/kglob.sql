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

col kglob_addrlen new_value kglob_addrlen

set termout off
select vsize(addr)*2 kglob_addrlen from x$dual;
set termout on

var printtab2_cursor varchar2(4000)

exec :printtab2_cursor:='select * from x$kglob where kglhdadr = hextoraw(upper(lpad(''&1'',&kglob_addrlen,''0'')))'

@@printtab2
