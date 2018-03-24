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

prompt Show invalid objects, indexes, index partitions and index subpartitions....

col ind_owner head OWNER for a20
col inv_oname head OBJECT_NAME for a30

select owner ind_owner, object_name inv_oname, object_type from dba_objects where status != 'VALID';

select owner ind_owner, table_name, index_name from dba_indexes where status not in ('VALID', 'N/A');

select index_owner ind_owner, index_name, partition_name from dba_ind_partitions where status not in ('N/A', 'USABLE');

select indeX_owner ind_owner, index_name, partition_name, subpartition_name from dba_ind_subpartitions where status not in ('USABLE');

