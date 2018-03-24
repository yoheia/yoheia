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

CREATE TABLE sales_part
PARTITION BY RANGE (time_id) (
    PARTITION Y1998 VALUES LESS THAN (DATE'1999-01-01')
  , PARTITION Y1999 VALUES LESS THAN (DATE'2000-01-01')
  , PARTITION Y2000 VALUES LESS THAN (DATE'2001-01-01')
  , PARTITION Y2001 VALUES LESS THAN (MAXVALUE)
)
TABLESPACE tanel_large
PARALLEL 32
AS SELECT * FROM sales_100g
/

ALTER TABLE sales_part NOPARALLEL;

EXEC DBMS_STATS.GATHER_TABLE_STATS(user, 'SALES_PART', degree=>16);

CREATE TABLE sales_part_query_high
PARTITION BY RANGE (time_id) (
    PARTITION Y1998 VALUES LESS THAN (DATE'1999-01-01')
  , PARTITION Y1999 VALUES LESS THAN (DATE'2000-01-01')
  , PARTITION Y2000 VALUES LESS THAN (DATE'2001-01-01')
  , PARTITION Y2001 VALUES LESS THAN (MAXVALUE)
)
TABLESPACE tanel_large
COMPRESS FOR QUERY HIGH
PARALLEL 32
AS SELECT * FROM sales_100g
/

ALTER TABLE sales_part_query_high NOPARALLEL;
EXEC DBMS_STATS.GATHER_TABLE_STATS(user, 'SALES_PART_QUERY_HIGH', degree=>16);

alter session set "_fix_control"='6941515:ON';

CREATE TABLE sales_part_fix_6941515
PARTITION BY RANGE (time_id) (
    PARTITION Y1998 VALUES LESS THAN (DATE'1999-01-01')
  , PARTITION Y1999 VALUES LESS THAN (DATE'2000-01-01')
  , PARTITION Y2000 VALUES LESS THAN (DATE'2001-01-01')
  , PARTITION Y2001 VALUES LESS THAN (MAXVALUE)
)
TABLESPACE tanel_large
PARALLEL 32
AS SELECT * FROM sales_100g
/

ALTER TABLE sales_part_fix_6941515 NOPARALLEL;

CREATE TABLE sales_part_query_high_fix
PARTITION BY RANGE (time_id) (
    PARTITION Y1998 VALUES LESS THAN (DATE'1999-01-01')
  , PARTITION Y1999 VALUES LESS THAN (DATE'2000-01-01')
  , PARTITION Y2000 VALUES LESS THAN (DATE'2001-01-01')
  , PARTITION Y2001 VALUES LESS THAN (MAXVALUE)
)
TABLESPACE tanel_large
COMPRESS FOR QUERY HIGH
PARALLEL 32
AS SELECT * FROM sales_100g
/

ALTER TABLE sales_part_query_high_fix NOPARALLEL;
EXEC DBMS_STATS.GATHER_TABLE_STATS(user, 'SALES_PART_QUERY_HIGH_FIX', degree=>16);


