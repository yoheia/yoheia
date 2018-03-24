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

col jobs_what head WHAT for a50
col jobs_interval head INTERVAL for a40

col jobs_job_name head JOB_NAME for a40
col jobs_program_name head PROGRAM_NAME for a40

select job, what jobs_what, last_date, next_date, interval jobs_interval, failures, broken from dba_jobs;

select
    job_name      jobs_job_name
  , program_name  jobs_program_name
  , state         jobs_state
  , to_char(start_date, 'YYYY-MM-DD HH24:MI') start_date
  , to_char(next_run_date, 'YYYY-MM-DD HH24:MI') next_run_date
  , enabled
from
    dba_scheduler_jobs
where
    state = 'RUNNING'
/

