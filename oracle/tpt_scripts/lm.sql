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

column lm_parent_name heading LATCH_NAME format a50
column lm_where heading WHERE format a50
column lm_label heading LABEL format a30
column lm_nwfail_count heading NOWAITFAILS format 999999999999
column lm_sleep_count heading SLEEPS format 999999999999

PROMPT Querying V$LATCH_MISSES....

--select 
--	t1.ksllasnam	lm_parent_name, 
--	t2.ksllwnam	lm_where, 
----	t1.kslnowtf, 
----	t1.kslsleep, 
----	t1.kslwscwsl, 
----	t1.kslwsclthg,
--	t2.ksllwlbl	lm_label
--from
--	x$ksllw t2,
--	x$kslwsc t1
--where 
--	t2.indx = t1.indx
--and	lower(t1.ksllasnam) like lower('%&1%')
--/

select * from (
	select 
	        rownum-1 loc#,
	        to_char(rownum-1, 'XXXX') hexl#,
		parent_name	lm_parent_name,
		"WHERE"		lm_where,
		nwfail_count	lm_nwfail_count,
		sleep_count	lm_sleep_count
	from
		v$latch_misses
)
where
	lower(lm_parent_name) like lower('%&1%')
or	lower(lm_where) like lower('%&1%')
/

	
