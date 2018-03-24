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

--------------------------------------------------------------------------------
--
-- File name:   calc.sql
-- Purpose:     Basic calculator and dec/hex converter
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @calc <num1> <operation> <num2>
-- 	        	@calc 10 + 10
--	        	@calc 10 + 0x10
--				@calc 0xFFFF - 0x5F
--				@calc xBB * 1234
-- Other:       
--				Can calculate only 2 operands a time
--              You can use just "x" instead of "0x" for indicating hex numbers
--
--------------------------------------------------------------------------------

COL calc_dec HEAD "DEC" FOR 999999999999999999999999999.999999
COL calc_hex HEAD "HEX" FOR A20 JUSTIFY RIGHT


with 
p1 as (
    select case 
             when lower('&1') like '%x%' then 'XXXXXXXXXXXXXXXXXX' 
             else '999999999999999999999999999.9999999999' 
             end
           format 
    from dual
),
p3 as (
    select case 
             when lower('&3') like '%x%' then 'XXXXXXXXXXXXXXXXXX' 
             else '999999999999999999999999999.9999999999' 
             end
           format 
    from dual
)
select 
    -- decimal
    to_number(substr('&1',instr(upper('&1'),'X')+1), p1.format) 
      &2 
    to_number(substr('&3',instr(upper('&3'),'X')+1), p3.format) calc_dec,
    -- hex
    to_char( to_number(substr('&1',instr(upper('&1'),'X')+1), p1.format)
               &2 
             to_number(substr('&3',instr(upper('&3'),'X')+1), p3.format)
    , 'XXXXXXXXXXXXXXXXXXX') calc_hex
from 
    p1,p3
/
