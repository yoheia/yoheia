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

@@saveset
set serverout on size 1000000

-- This is modified Tom Kyte's printtab code ( http://asktom.oracle.com )

declare
    c clob := q'\&1\';
     l_theCursor     integer default dbms_sql.open_cursor;
     l_columnValue   varchar2(4000);
     l_status        integer;
     l_descTbl       dbms_sql.desc_tab;
     l_colCnt        number;
 begin
     dbms_sql.parse(  l_theCursor, c, dbms_sql.native );
     dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );
     for i in 1 .. l_colCnt loop
         dbms_sql.define_column( l_theCursor, i,
                                 l_columnValue, 4000 );
     end loop;
     l_status := dbms_sql.execute(l_theCursor);
     while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
         for i in 1 .. l_colCnt loop
                 dbms_sql.column_value( l_theCursor, i,
                                        l_columnValue );
                 dbms_output.put_line
                     ( rpad( l_descTbl(i).col_name,
                       30 ) || ': ' || l_columnValue );
         end loop;
         dbms_output.put_line( '==============================' );
     end loop;
 exception
     when others then
         dbms_output.put_line(dbms_utility.format_error_backtrace);
         raise;
end;
/

@@loadset
