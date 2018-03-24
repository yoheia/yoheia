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

COL process_name_ksbtabact HEAD PROCESS_NAME FOR A20

-- similar to X$MESSAGES

SELECT
    indx
  , process_name_ksbtabact      
  , action_description_ksbtabact
  , timeout_ksbtabact           
  , options_ksbtabact           
FROM
    X$KSBTABACT
WHERE
    LOWER(ACTION_DESCRIPTION_KSBTABACT) LIKE LOWER('%&1%')
OR  LOWER(PROCESS_NAME_KSBTABACT) LIKE LOWER('%&1%')
/


