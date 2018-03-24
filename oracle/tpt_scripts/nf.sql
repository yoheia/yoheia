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

define _nf_precision=2
define _nf_base=2
define _nf_grouplen=10

define _nf_v=&1

select round (  &_nf_v / power( &_nf_base , trunc(log(&_nf_base,&_nf_v))-trunc(mod(log(&_nf_base,&_nf_v),&_nf_grouplen)) ), &_nf_precision  ) 
	|| decode( trunc(log(&_nf_base,&_nf_v))-trunc(mod(log(&_nf_base,&_nf_v),&_nf_grouplen))
			   , 0,'', 1,'', &_nf_grouplen*1,'k', &_nf_grouplen*2,'M', &_nf_grouplen*3,'G', &_nf_grouplen*4,'T', &_nf_grouplen*5,'P', &_nf_grouplen*6,'E'
			   , '*&_nf_base^'||to_char( trunc(log(&_nf_base,&_nf_v))-trunc(mod(log(&_nf_base,&_nf_v),&_nf_grouplen)) )  
	   ) output 
from dual;
