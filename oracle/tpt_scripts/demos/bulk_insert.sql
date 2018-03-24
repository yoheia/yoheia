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

-- Simple Export

drop table t;
create table t as select * from all_users where 1=0;

-- this type def is created based on data dictionary definition of extracted table when exporting 
create or replace type rtype as object ( username varchar2(30), user_id number, created date )
/
create or replace type ttype as table of rtype;
/

-- set nls_date format to some standard format

declare
    rows ttype := ttype();
begin 
    insert into t 
    select * from table ( 
        ttype ( 
            rtype('a',1,sysdate), 
            rtype('b',2,sysdate),
            rtype('c',3,sysdate),
            rtype('d',4,sysdate),
            rtype('e',5,sysdate),
            rtype('f',6,sysdate),
            rtype('g',7,sysdate),
            rtype('h',8,sysdate),
            rtype('i',9,sysdate),
            rtype('j',10,sysdate),
            rtype('k',11,sysdate),
            rtype('l',12,sysdate),
            rtype('m',13,sysdate),
            rtype('n',14,sysdate)
        )
    );
end;
/

select * from t;

drop type ttype;
drop type rtype;

-- can we do completely without creating stored types?