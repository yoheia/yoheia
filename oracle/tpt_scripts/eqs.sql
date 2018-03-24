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

COL eqs_req_reason HEAD REQ_REASON FOR A35 WORD_WRAP
PROMPT Display Enqueue Statistics from v$enqueue_statistics

SELECT
    eq_type
  , req_reason eqs_req_reason
  , total_req#
  , total_wait#
  , succ_req#
  , failed_req#
  , cum_wait_time
FROM
    v$enqueue_statistics
WHERE
    UPPER(eq_type) LIKE UPPER('&1')
/

