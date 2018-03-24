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

-- enable physical IO tracing

@seg soe.orders
@ind soe.orders
@descxx soe.orders

ALTER SESSION SET EVENTS '10298 trace name context forever, level 1';
EXEC SYS.DBMS_MONITOR.SESSION_TRACE_ENABLE(waits=>TRUE);

SET TIMING ON
SET AUTOTRACE ON STAT

PAUSE Press enter to start...
SELECT /*+ MONITOR INDEX(o, o(warehouse_id)) */ SUM(order_total) FROM soe.orders o WHERE warehouse_id BETWEEN 400 AND 599;

SET AUTOTRACE OFF

