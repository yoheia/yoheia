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

prompt Show PX Table Queue statistics from last Parallel Execution in this session...

col tq_tq head "TQ_ID|(DFO,SET)" for a10
col tq_flow_dir head "TQ_FLOW|DIRECTION" for a9
col tq_process head PROCESS for a10
break on tq_tq on dfo_number on tq_id 

select 
    ':TQ'||trim(to_char(t.dfo_number))||','||trim(to_char(t.tq_id,'0999')) tq_tq
  , DECODE(replace(SERVER_TYPE,chr(0),''),'Producer', 'Produced', 'Consumer', 'Consumed', SERVER_TYPE) tq_flow_dir
  , NUM_ROWS     
  , BYTES        
--  , OPEN_TIME    
--  , AVG_LATENCY  
  , WAITS        
  , TIMEOUTS     
  , PROCESS    tq_process    
  , INSTANCE    
  , DFO_NUMBER
  , TQ_ID 
from 
    v$pq_tqstat t
order by 
    dfo_number, tq_id,server_type  desc
/

