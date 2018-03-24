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

-- use the @ast/02_choosing_join_order.sql script to run the demo query
--------------------------------------------------------------------------------------------------------
-- SQL Profiles (require Tuning + Diag Pack):
--------------------------------------------------------------------------------------------------------

-- Drop the profile:
--  EXEC DBMS_SQLTUNE.DROP_SQL_PROFILE('MANUAL_PROFILE_1ka5g0kh4h6pc');

VAR sql_fulltext CLOB
EXEC SELECT sql_fulltext INTO :sql_fulltext FROM v$sql WHERE sql_id = '1ka5g0kh4h6pc' AND rownum = 1;

-- Example 1: Set Join order:
EXEC DBMS_SQLTUNE.IMPORT_SQL_PROFILE(sql_text=>:sql_fulltext, profile=>sys.sqlprof_attr('LEADING(@"SEL$1" "CO"@"SEL$1" "CH"@"SEL$1" "CU"@"SEL$1" "S"@"SEL$1" "P"@"SEL$1")'), name=> 'MANUAL_PROFILE_1ka5g0kh4h6pc');

-- Example 2: Adjust cardinality:
EXEC DBMS_SQLTUNE.IMPORT_SQL_PROFILE(sql_text=>:sql_fulltext, profile=>sys.sqlprof_attr('OPT_ESTIMATE(@"SEL$1", TABLE, "CU"@"SEL$1", SCALE_ROWS=100000)'), name=> 'MANUAL_PROFILE_1ka5g0kh4h6pc');

-- Example 3: Set multiple hints:
DECLARE
    hints sys.sqlprof_attr := sys.sqlprof_attr(
        ('LEADING(@"SEL$1" "CO"@"SEL$1" "CH"@"SEL$1"')
      , ('OPT_ESTIMATE(@"SEL$1", TABLE, "CU"@"SEL$1", SCALE_ROWS=100000)')
    );
BEGIN
    DBMS_SQLTUNE.IMPORT_SQL_PROFILE(sql_text=>:sql_fulltext, profile=> hints, name=> 'MANUAL_PROFILE_1ka5g0kh4h6pc');
END;
/

