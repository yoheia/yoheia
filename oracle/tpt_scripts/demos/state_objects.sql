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

create or replace function delete_func (owner_name in varchar2) return number
as
   num_deleted number;
begin
   -- this is a demo procedure
   -- it does not do anything useful!

   DELETE FROM mytab WHERE owner = owner_name;
   COMMIT;

   num_deleted := SQL%ROWCOUNT;
   DBMS_OUTPUT.PUT_LINE('Deleted rows ='|| TO_CHAR(num_deleted));

   return num_deleted;
end;
/
show err
