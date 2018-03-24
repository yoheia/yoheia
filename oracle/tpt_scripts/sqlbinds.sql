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

prompt Show captured binds from V$SQL_BIND_CAPTURE...

SELECT
  HASH_VALUE          
, SQL_ID              
, CHILD_NUMBER        
, NAME                
, POSITION            
, DUP_POSITION        
, DATATYPE            
, DATATYPE_STRING     
, CHARACTER_SID       
, PRECISION           
, SCALE               
, MAX_LENGTH          
, WAS_CAPTURED        
, LAST_CAPTURED       
, VALUE_STRING        
, VALUE_ANYDATA  
FROM
  v$sql_bind_capture
WHERE
    hash_value IN (&1)
AND child_number like '&2'
/
