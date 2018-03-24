-- sqlmon.sql
--
-- Copyright 2015 Gluent Inc. All rights reserved
--
set heading off pagesize 0 linesize 32767 trimspool on trimout on long 9999999 verify off longchunksize 9999999 feedback off
set serverout on size unlimited
set autotrace off feedback off termout off
set define on

--whenever sqlerror exit sql.sqlcode

-- Parameters section...
-- ------------------------------------------------------------------------------------------
undefine _sid
undefine _sql_id
undefine _sql_exec_id
undefine _sql_exec_start
undefine _sql_exec_start_format
undefine _sqlmon_call_formats
undefine _report_name

column 1 new_value 1
column 2 new_value 2
column 3 new_value 3
column 4 new_value 4
SELECT NULL as "1"
,      NULL as "2"
,      NULL as "3"
,      NULL as "4"
FROM   dual
WHERE  1=2;

set termout on
prompt
prompt ================================================================================
prompt Gluent Augmented SQL Monitoring Report v2.5.0-DEV
prompt Copyright 2015-2017 Gluent Inc. All rights reserved.
prompt ================================================================================
set termout off

column _sid                   new_value _sid
column _sql_id                new_value _sql_id
column _sql_exec_id           new_value _sql_exec_id
column _sql_exec_start        new_value _sql_exec_start
SELECT CASE
           WHEN sid IS NOT NULL
           THEN sid
           WHEN q'[&1]' IS NOT NULL AND INSTR(q'[&1]', '=') = 0
           THEN q'[&1]'
           ELSE 'NULL'
       END                              AS "_sid"
,      NVL(sql_id, 'NULL')              AS "_sql_id"
,      NVL(sql_exec_id, 'NULL')         AS "_sql_exec_id"
,      NVL(sql_exec_start, 'NULL')      AS "_sql_exec_start"
FROM  (
        SELECT REGEXP_SUBSTR(args, '(sid=)([^\|]+)', 1, 1, 'i', 2)             AS sid
        ,      REGEXP_SUBSTR(args, '(sql_id=)([^\|]+)', 1, 1, 'i', 2)          AS sql_id
        ,      REGEXP_SUBSTR(args, '(sql_exec_id=)([^\|]+)', 1, 1, 'i', 2)     AS sql_exec_id
        ,      REGEXP_SUBSTR(args, '(sql_exec_start=)([^\|]+)', 1, 1, 'i', 2)  AS sql_exec_start
        FROM  (
                SELECT q'[&1|&2|&3|&4]' AS args
                FROM   dual
              )
      );

define _sql_exec_start_format = "YYYYMMDD_HH24MISS"
define _sqlmon_call_formats   =                        "1. @sqlmon.sql sid=<n>"
define _sqlmon_call_formats   = "&_sqlmon_call_formats. 2. @sqlmon.sql sid=userenv(''sid'')"
define _sqlmon_call_formats   = "&_sqlmon_call_formats. 3. @sqlmon.sql sid=sys_context(''userenv'',''sid'')"
define _sqlmon_call_formats   = "&_sqlmon_call_formats. 5. @sqlmon.sql sql_id=<s>"
define _sqlmon_call_formats   = "&_sqlmon_call_formats. 4. @sqlmon.sql sql_id=<s> sql_exec_id=<n> sql_exec_start=<&_sql_exec_start_format.>"

set termout on

var sid            NUMBER
var sql_id         VARCHAR2(30)
var sql_exec_id    NUMBER
var sql_exec_start VARCHAR2(30)

DECLARE
    v_sid            NUMBER;
    v_sql_id         VARCHAR2(30);
    v_sql_exec_id    NUMBER;
    v_sql_exec_start DATE;
BEGIN
    -- Parameter validations...
    BEGIN
        v_sid := &_sid;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20000, q'{Invalid value for SID [&_sid]. Use a numeric literal or a USERENV/SYS_CONTEXT expression}');
    END;
    BEGIN
        v_sql_id := NULLIF('&_sql_id','NULL');
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid value for SQL_ID [&_sql_id]');
    END;
    BEGIN
        v_sql_exec_id := &_sql_exec_id;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid value for SQL_EXEC_ID [&_sql_exec_id]. Use a numeric literal');
    END;
    BEGIN
        v_sql_exec_start := TO_DATE(NULLIF('&_sql_exec_start','NULL'), '&_sql_exec_start_format');
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20003, 'Invalid value or format for SQL_EXEC_START [&_sql_exec_start]. Format must be &_sql_exec_start_format');
    END;
    IF (v_sid IS NOT NULL AND (v_sql_id IS NOT NULL OR v_sql_exec_id IS NOT NULL OR v_sql_exec_start IS NOT NULL))
    OR (v_sid IS NULL AND v_sql_id IS NULL)
    THEN
        RAISE_APPLICATION_ERROR(-20004, 'Invalid or missing parameters specified. Valid call formats are: ' || REGEXP_REPLACE('&_sqlmon_call_formats', '([0-9]\.)', CHR(10) || '\1') );
    END IF;
    -- Set parameter binds...
    :sid            := v_sid;
    :sql_id         := v_sql_id;
    :sql_exec_id    := v_sql_exec_id;
    :sql_exec_start := TO_CHAR(v_sql_exec_start, '&_sql_exec_start_format');
END;
/

-- Report generation...
prompt
prompt Generating report...

set termout off

var report_name VARCHAR2(1000)
var report_data REFCURSOR

DECLARE
    v_sid            NUMBER         := :sid;
    v_sql_id         VARCHAR2(30)   := :sql_id;
    v_sql_exec_id    NUMBER         := :sql_exec_id;
    v_sql_exec_start DATE           := TO_DATE(:sql_exec_start, '&_sql_exec_start_format');
BEGIN
    IF v_sid IS NOT NULL THEN
        :report_name := offload_tools.sqlmon_report_name( p_sid => v_sid );
        OPEN :report_data
        FOR
            SELECT report_text
            FROM   TABLE( offload_tools.sqlmon( p_sid => v_sid ))
            ORDER  BY
                   report_id;
    ELSE
        :report_name := offload_tools.sqlmon_report_name( p_sql_id         => v_sql_id,
                                                          p_sql_exec_id    => v_sql_exec_id,
                                                          p_sql_exec_start => v_sql_exec_start );
        OPEN :report_data
        FOR
            SELECT report_text
            FROM   TABLE( offload_tools.sqlmon( p_sql_id         => v_sql_id,
                                                p_sql_exec_id    => v_sql_exec_id,
                                                p_sql_exec_start => v_sql_exec_start ))
            ORDER  BY
                   report_id;
    END IF;
END;
/

column _report_name new_value _report_name
SELECT :report_name AS "_report_name"
FROM   dual;

spool &_report_name
print :report_data
spool off

set termout on
prompt
prompt Report saved to &_report_name.
prompt
prompt ================================================================================
prompt Gluent Augmented SQL Monitoring Report completed.
prompt ================================================================================
prompt
set termout off

-- Open the report...
host open &_report_name

set termout on heading on pagesize 5000 linesize 999 serverout off
set feedback 6

undefine 1 2 3 4
undefine _sid
undefine _sql_id
undefine _sql_exec_id
undefine _sql_exec_start
undefine _sql_exec_start_format
undefine _report_name
undefine _sqlmon_call_formats

--set timing on
