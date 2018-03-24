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

col ii_service_name	head SERVICE_NAME 	for a20
col ii_module 		head MODULE		for a32
col ii_action		head ACTION		for a32
col ii_client_identifier head CLIENT_IDENTIFIER	for a32
col ii_client_info	head CLIENT_INFO	for a32
col ii_program head PROGRAM for a20 truncate

select 
        userenv('SID') sid , 
        userenv('SESSIONID') audsid, 
        '0x'||trim(to_char(userenv('SID'), 'XXXX')) "0xSID",
        '0x'||trim(to_char(userenv('SESSIONID'), 'XXXXXXXX')) "0xAUDSID", 
  program     ii_program,
	module			ii_module, 
	action			ii_action, 
	service_name		ii_service_name, 
	client_identifier	ii_client_identifier, 
	client_info 		ii_client_info
from 
--	v$session where audsid = sys_context('USERENV', 'SESSIONID')
	v$session where sid = sys_context('USERENV', 'SID')
/
