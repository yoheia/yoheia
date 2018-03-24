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

col ba_blsiz head BLSZ for 99999

select 
--	addr,
	indx,hladdr,
	blsiz ba_blsiz,
	flag,lru_flag,ts#,file#,
	dbarfil,dbablk,class,state,mode_held,obj,tch 
from x$bh where ba = hextoraw(lpad('&1',16,0))
/

