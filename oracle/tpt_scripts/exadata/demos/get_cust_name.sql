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

CREATE OR REPLACE FUNCTION get_cust_name (id IN NUMBER) RETURN VARCHAR2 
    AUTHID CURRENT_USER
AS
    n VARCHAR2(1000); 
BEGIN 
    SELECT /*+ FULL(c) */ cust_first_name||' '||cust_last_name INTO n 
    FROM soe.customers c
    WHERE customer_id = id; 
    RETURN n; 
END;
/

