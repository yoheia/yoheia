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

-- create table kkpap_pruning (
--     operation_id number
--   , it_type varchar(5)
--         CONSTRAINT check_it_type
--         CHECK (it_type in ('RANGE', 'ARRAY'))
--   , it_level varchar(15)
--         CONSTRAINT check_it_level 
--         CHECK (it_level in ('PARTITION', 'SUBPARTITION', 'ABSOLUTE'))
--   , it_order varchar(10)
--         CONSTRAINT check_it_order
--         CHECK (it_order in ('ASCENDING', 'DESCENDING'))
--   , it_call_time varchar(10)
--         CONSTRAINT check_it_call_time
--         CHECK (it_call_time in ('COMPILE', 'START', 'RUN'))
--   , pnum number
--   , spnum number
--   , apnum number
-- );


SELECT
    OPERATION_ID 
  , IT_TYPE      
  , IT_LEVEL     
  , IT_ORDER     
  , IT_CALL_TIME 
  , PNUM  + 1 real_partnum     
  , SPNUM + 1 subpartnum       
  , APNUM        
FROM
   kkpap_pruning
/

