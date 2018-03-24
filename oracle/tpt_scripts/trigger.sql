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

create or replace trigger test
after servererror on oracle.schema
begin
  dbms_output.put_line('Error: '|| sysdate);
end;
/




declare
  cursor getDepartments is
    select xtab.name NAME, ref(d) XMLREF
    from DEPARTMENT_XQL d, xmltable(
     'for $i in . return $i/Department/Name' PASSING d.object_value
      COLUMNS name VARCHAR2(30) PATH '/Name') xtab;
  res boolean;
  targetFolder varchar2(1024) :=  '/home//OE/XQDepartments';
begin
  if dbms_xdb.existsResource(targetFolder) then
     dbms_xdb.deleteResource(targetFolder,dbms_xdb.DELETE_RECURSIVE);
  end if;
  res := dbms_xdb.createFolder(targetFolder);
  for dept in getDepartments loop
    res := DBMS_XDB.createResource(targetFolder || '/' || dept.NAME || '.xml', dept.XMLREF);
  end loop;
end;
/

