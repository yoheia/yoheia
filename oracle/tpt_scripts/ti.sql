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

@@saveset

column _ti_sequence noprint new_value _ti_sequence

set feedback off heading off

select trim(to_char( &_ti_sequence + 1 , '0999' )) "_ti_sequence" from dual;

alter session set tracefile_identifier="&_ti_sequence";

set feedback on heading on

set termout off

column tracefile noprint new_value trc

	select value ||'/'||(select instance_name from v$instance) ||'_ora_'||
	       (select spid||case when traceid is not null then '_'||traceid else null end
                from v$process where addr = (select paddr from v$session
	                                         where sid = (select sid from v$mystat
	                                                    where rownum = 1
	                                               )
	                                    )
	       ) || '.trc' tracefile
	from v$parameter where name = 'user_dump_dest';

set termout on
@@loadset

prompt New tracefile_identifier=&trc

col tracefile clear

