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

col kstex_seqh head SEQH for 99999999999999

select 
	sid,
	pid,
	op    event, 
	id,
	val0, 
	func, 
	decode(id,1,'call',2,'return',3,'longjmp') calltype, 
	nvals,  
	val2, 
	val3,
	seqh + power(2,32) kstex_seqh, 
	seql 
from 
	x$kstex 
where
	sid like '&1'
order by
	seqh, seql asc
/

