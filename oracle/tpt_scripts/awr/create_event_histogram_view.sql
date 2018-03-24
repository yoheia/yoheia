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

CREATE OR REPLACE VIEW sys.t_hist_event_histogram AS
SELECT
    SNAP_ID                         -- NOT NULL NUMBER
  , DBID                            -- NOT NULL NUMBER
  , INSTANCE_NUMBER                 -- NOT NULL NUMBER
  , EVENT_ID                        -- NOT NULL NUMBER
  , EVENT_NAME                      -- NOT NULL VARCHAR2(64)
  , WAIT_CLASS_ID                   --          NUMBER
  , WAIT_CLASS                      --          VARCHAR2(64)
  , WAIT_TIME_MILLI                 -- NOT NULL NUMBER
  , WAIT_COUNT                      --          NUMBER
  , CAST(BEGIN_INTERVAL_TIME AS DATE) snapshot_begin_time   -- NOT NULL TIMESTAMP(3)
  , CAST(END_INTERVAL_TIME AS DATE)   snapshot_end_time     -- NOT NULL TIMESTAMP(3)
  , TO_CHAR(begin_interval_time, 'YYYY')  snapshot_begin_year
  , TO_CHAR(begin_interval_time, 'MM')    snapshot_begin_month_num
  , TO_CHAR(begin_interval_time, 'MON')   snapshot_begin_mon
  , TO_CHAR(begin_interval_time, 'Month') snapshot_begin_month
  , TO_CHAR(begin_interval_time, 'DD')    snapshot_begin_day
  , TO_CHAR(begin_interval_time, 'HH24')  snapshot_begin_hour
  , TO_CHAR(begin_interval_time, 'MI')    snapshot_begin_minute
FROM
    dba_hist_snapshot
NATURAL JOIN
    dba_hist_event_histogram
/

GRANT SELECT ON sys.t_hist_event_histogram TO PUBLIC;
CREATE PUBLIC SYNONYM t_hist_event_histogram FOR sys.t_hist_event_histogram;

