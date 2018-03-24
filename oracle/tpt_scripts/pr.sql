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

.

-- Notes:   This script is based on Tom Kyte's original printtbl code ( http://asktom.oracle.com )
--          For coding simplicity (read: lazyness) I'm using custom quotation marks ( q'\ ) so 
--          this script works only from Oracle 10gR2 onwards

prompt Pivoting output using Tom Kyte's printtab....

def _pr_tmpfile=&_tpt_tempdir/pr_&_tpt_tempfile..tmp

@@saveset
set serverout on size 1000000 termout off
save &_pr_tmpfile replace
set termout on

0 c clob := q'\
0 declare

999999      \';;
999999      l_theCursor     integer default dbms_sql.open_cursor;;
999999      l_columnValue   varchar2(4000);;
999999      l_status        integer;;
999999      l_descTbl       dbms_sql.desc_tab;;
999999      l_colCnt        number;;
999999  begin
999999      dbms_sql.parse(  l_theCursor, c, dbms_sql.native );;
999999      dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );;
999999      for i in 1 .. l_colCnt loop
999999          dbms_sql.define_column( l_theCursor, i,
999999                                  l_columnValue, 4000 );;
999999      end loop;;
999999      l_status := dbms_sql.execute(l_theCursor);;
999999      while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
999999          dbms_output.put_line( '==============================' );;
999999          for i in 1 .. l_colCnt loop
999999                  dbms_sql.column_value( l_theCursor, i,
999999                                         l_columnValue );;
999999                  dbms_output.put_line
999999                      ( rpad( l_descTbl(i).col_name,
999999                        30 ) || ': ' || l_columnValue );;
999999          end loop;;
999999      end loop;;
999999  exception
999999      when others then
999999          dbms_output.put_line(dbms_utility.format_error_backtrace);;
999999          raise;;
999999 end;;
/

@@loadset

get &_pr_tmpfile nolist
host &_delete &_pr_tmpfile 

