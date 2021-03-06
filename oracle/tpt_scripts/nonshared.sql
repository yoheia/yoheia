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
-- File name:   nonshared.sql   
-- Purpose:     Print reasons for non-shared child cursors from v$sql_shared_cursor
--              in a readable format
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @nonshared <sql_id>
-- 	            @nonshared 7gf6xg9xfv3vb
--	        
-- Other:       Uses modified version of Tom Kyte's printtab code 
--              ( http://asktom.oracle.com )
--
--------------------------------------------------------------------------------

--@@saveset
set serverout on size 1000000
prompt Show why existing SQL child cursors were not reused (V$SQL_SHARED_CURSOR)...
prompt

def cmd="select * from v$sql_shared_cursor where sql_id = ''&1''"


declare
    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_descTbl       dbms_sql.desc_tab;
    l_colCnt        number;
    procedure execute_immediate( p_sql in varchar2 )
    is
    BEGIN
        dbms_sql.parse(l_theCursor,p_sql,dbms_sql.native);
        l_status := dbms_sql.execute(l_theCursor);
    END;
begin
    execute_immediate( 'alter session set nls_date_format=
                        ''dd-mon-yyyy hh24:mi:ss'' ');
    dbms_sql.parse(  l_theCursor,
                     replace( '&cmd', '"', ''''),
                     dbms_sql.native );
    dbms_sql.describe_columns( l_theCursor,
                               l_colCnt, l_descTbl );
    for i in 1 .. l_colCnt loop
        dbms_sql.define_column( l_theCursor, i,
                                l_columnValue, 4000 );
    end loop;
    l_status := dbms_sql.execute(l_theCursor);
    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
        for i in 1 .. l_colCnt loop
            dbms_sql.column_value( l_theCursor, i,
                                   l_columnValue );
            if l_columnValue != 'N' then 
	            dbms_output.put_line
	                ( rpad( l_descTbl(i).col_name,
	                  30 ) || ': ' || l_columnValue );
	        end if;
        end loop;
        dbms_output.put_line( '-----------------' );
    end loop;
    execute_immediate( 'alter session set nls_date_format=
                           ''dd-MON-yy'' ');
exception
    when others then
        execute_immediate( 'alter session set
                         nls_date_format=''dd-MON-yy'' ');
        raise;
end;
/

--@@loadset
set serverout off
