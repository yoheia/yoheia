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
-- File name:   sampleaddr.sql 
-- Purpose:     High-frequency sampling of contents of a SGA memory address
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @sampleaddr <hex_addr> <sample_count>
-- 	        @sampleaddr 
--	        
-- Other:       Requires the sample.sql script:
--
--                http://www.tanelpoder.com/files/scripts/sample.sql
--
--              Also requires access to X$KSMMEM and X$DUAL tables
--              
--------------------------------------------------------------------------------

col sampleaddr_addrlen new_value _sampleaddr_addrlen

set termout off
select vsize(addr)*2 sampleaddr_addrlen from x$dual;
set termout on

@@sample ksmmmval x$ksmmem "addr=hextoraw(lpad('&1',&_sampleaddr_addrlen,'0'))" &2
