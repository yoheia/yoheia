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

SELECT * FROM dual dontrun;

@hash

@oddc optim

ALTER SESSION SET EVENTS 'trace [SQL_Optimizer] [sql:g40pz6bqjwbzt] controlc_signal()';

ALTER SYSTEM FLUSH SHARED_POOL;

SELECT * FROM dual pleaserun;
SELECT * FROM dual dontrun;
SELECT * FROM dual dontrun;

ALTER SESSION SET EVENTS 'trace [SQL_Optimizer] [sql:g40pz6bqjwbzt] off';

ALTER SESSION SET EVENTS 'trace [Parallel_Execution] [sql:g40pz6bqjwbzt] controlc_signal()';

SELECT * FROM dual dontrun;

ALTER SESSION FORCE PARALLEL QUERY PARALLEL 4;

SELECT * FROM dual dontrun;

ALTER SESSION SET EVENTS 'trace [Parallel_Execution] [sql:g40pz6bqjwbzt] off';


ALTER SYSTEM FLUSH SHARED_POOL;

ALTER SESSION SET EVENTS 'trace [SQL_Optimizer] [sql:g40pz6bqjwbzt] crash';

SELECT * FROM dual dontrun;


