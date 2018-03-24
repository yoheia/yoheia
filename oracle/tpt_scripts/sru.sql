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
	ru.indx SID,
/*	decode ( KSURIND                                                       
		, 0, 'COMPOSITE_LIMIT'
		, 1, 'LOGINS_PER_USER'
		, 2, 'CPU_PER_SESSION'
		, 3, 'CPU_PER_CALL'
		, 4, 'IO_PER_SESSION'
		, 5, 'IO_PER_CALL' 
		, 6, 'MAX_IDLE_TIME'   
		, 7, 'MAX_CONNECT_TIME'
		, 8, 'PRIVATE_SGA'     
		, 9, 'PROCEDURE_SPACE'
		, to_char(KSURIND) */
	rm.name RES,
	ru.ksuruse USED
from
	sys.resource_map	rm,
	x$ksuru				ru
where
	ru.indx = to_number(&1)
and rm.resource# = ru.ksurind
and rm.type# = 0
/
