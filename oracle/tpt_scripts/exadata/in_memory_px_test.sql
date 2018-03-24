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

DROP TABLE test_impx;
CREATE TABLE test_impx  (
    id                  NUMBER         NOT NULL
  , owner               VARCHAR2(30)
  , object_name         VARCHAR2(128)
  , subobject_name      VARCHAR2(30)   
  , object_id           NUMBER         
  , data_object_id      NUMBER         
  , object_type         VARCHAR2(19)   
  , created             DATE           
  , last_ddl_time       DATE           
  , timestamp           VARCHAR2(19)   
  , status              VARCHAR2(7)    
  , temporary           VARCHAR2(1)    
  , generated           VARCHAR2(1)    
  , secondary           VARCHAR2(1)    
  , namespace           NUMBER         
  , edition_name        VARCHAR2(30)   
)
PARTITION BY RANGE (id) (
    PARTITION id_05m VALUES LESS THAN (6000000)  
  , PARTITION id_09m VALUES LESS THAN (MAXVALUE) 
)
/

INSERT
    /*+ APPEND */ INTO test_impx
SELECT 
    ROWNUM id, t.* 
FROM 
    dba_objects t
  , (SELECT 1 FROM dual CONNECT BY LEVEL <= 100) u -- cartesian join for generating lots of rows
/

@gts test_impx
