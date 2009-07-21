--$Id:$
set pagesize 0
set linesize 32767
set linesize &MAX_LINE_SIZE
set trimspool on
set feedback off
set verify off
ACCEPT DT_FMT CHAR PROMPT 'DATETIME FORMAT:'
ALTER SESSION  SET NLS_DATE_FORMAT = '&DT_FMT';

ACCEPT TABLE CHAR PROMPT 'TABLE NAME:'
ACCEPT QUERY CHAR PROMPT 'QUERY(e.g. "ENAME = ''''SCOTT''''"):'
ACCEPT FILE CHAR PROMPT 'OUTPUT FILE NAME:'
DEFINE QUERY = &QUERY || 'AND 1=1'

set termout off
spool tmp_csv.sql

SELECT 'SELECT ' FROM DUAL;
SELECT CHR(9)
    || DECODE( DATA_TYPE, 'VARCHAR2', '''"'' || REPLACE( '
                         , 'CHAR'    , '''"'' || REPLACE( '
                                     , NULL )
    || COLUMN_NAME
    || DECODE( DATA_TYPE, 'VARCHAR2', ', ''"'', ''""'' ) || ''",'' ||'
                        , 'CHAR'    , ', ''"'', ''""'' ) || ''",'' ||'
                                    , ' || '','' ||' )
 FROM USER_TAB_COLUMNS
 WHERE TABLE_NAME = UPPER( '&TABLE' )
   AND COLUMN_ID != ( SELECT MAX( COLUMN_ID ) FROM USER_TAB_COLUMNS
                        WHERE TABLE_NAME = UPPER( '&TABLE' ) )
 ORDER BY COLUMN_ID;
SELECT CHR(9)
    || DECODE( DATA_TYPE, 'VARCHAR2', '''"'' || REPLACE( '
                        , 'CHAR'    , '''"'' || REPLACE( '
                                    , NULL )
    || COLUMN_NAME
    || DECODE( DATA_TYPE, 'VARCHAR2', ', ''"'', ''""'' ) || ''"'''
                        , 'CHAR'    , ', ''"'', ''""'' ) || ''"'''
                                    , NULL )
 FROM USER_TAB_COLUMNS
 WHERE TABLE_NAME = UPPER( '&TABLE' )
   AND COLUMN_ID = ( SELECT MAX( COLUMN_ID ) FROM USER_TAB_COLUMNS
                        WHERE TABLE_NAME = UPPER( '&TABLE' ) );
SELECT ' FROM &TABLE WHERE &QUERY;' FROM DUAL;

spool off

spool &FILE
@tmp_csv
spool off
set termout on
