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

--------------------------------------------------------------------------------
--
-- File name:   demo2a.sql
--
-- Purpose:     Advanced Oracle Troubleshooting Seminar demo script
--              Will cause some recursive dynamic sampling activity
--              that does not show up in V$SESSION and ASH
--
--              Uses SwingBench Order Entry schema table (but you can use
--              any other large table for testing this effect).
--
--              Requires Oracle 11.2 or lower (12c works slightly differently)
--
-- Author:      Tanel Poder ( http://tanelpoder.com )
-- Copyright:   (c) Tanel Poder
--
--------------------------------------------------------------------------------

prompt Starting Demo2a...

set echo on

ALTER SYSTEM FLUSH SHARED_POOL;

SELECT /*+ DYNAMIC_SAMPLING(o 10) */ * FROM soe.order_items o WHERE order_id = 1;
SELECT /*+ DYNAMIC_SAMPLING(o 10) */ * FROM soe.order_items o WHERE order_id = 1;
SELECT /*+ DYNAMIC_SAMPLING(o 10) */ * FROM soe.order_items o WHERE order_id = 1;

ALTER SYSTEM FLUSH SHARED_POOL;

SELECT /*+ DYNAMIC_SAMPLING(o 10) */ * FROM soe.order_items o WHERE order_id = 1;
SELECT /*+ DYNAMIC_SAMPLING(o 10) */ * FROM soe.order_items o WHERE order_id = 1;
SELECT /*+ DYNAMIC_SAMPLING(o 10) */ * FROM soe.order_items o WHERE order_id = 1;

set echo off

