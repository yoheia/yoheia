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

COL w_metric_value HEAD METRIC_VALUE FOR 9,999,999,999,999.99

prompt What's going on right now?!
prompt System metrics...

SET FEEDBACK OFF

SELECT
    metric_name
  , ROUND(value,2) w_metric_value
  , metric_unit
FROM
    v$sysmetric 
WHERE 
    metric_name IN (
				'Average Active Sessions'                      
			, 'Average Synchronous Single-Block Read Latency'
			, 'CPU Usage Per Sec'                            
			, 'Background CPU Usage Per Sec'                 
			, 'DB Block Changes Per Txn'                     
			, 'Executions Per Sec'                           
			, 'Host CPU Usage Per Sec'                       
			, 'I/O Megabytes per Second'                     
			, 'I/O Requests per Second'                      
			, 'Logical Reads Per Txn'                        
			, 'Logons Per Sec'                               
			, 'Network Traffic Volume Per Sec'               
			, 'Physical Reads Per Sec'                       
			, 'Physical Reads Per Txn'                       
			, 'Physical Writes Per Sec'                      
			, 'Redo Generated Per Sec'                       
			, 'Redo Generated Per Txn'                       
			, 'Response Time Per Txn'                        
			, 'SQL Service Response Time'                    
			, 'Total Parse Count Per Txn'                    
			, 'User Calls Per Sec'                           
			, 'User Transaction Per Sec'                     
)
AND group_id = 2 -- get last 60 sec metrics
ORDER BY
    metric_name
/

PROMPT
PROMPT Session level breakdown...
SET FEEDBACK ON

@@snapper ash,ash1,ash2,ash3=sqlid 5 1 all
