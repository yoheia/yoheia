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

col ls_file_name head FILE_NAME for a80
col ls_mb head MB
col ls_maxsize head MAXSZ

select 
    tablespace_name,
    file_id,
    file_name ls_file_name,
    autoextensible ext,
    round(bytes/1048576,2) ls_mb,
    decode(autoextensible, 'YES', round(maxbytes/1048576,2), null) ls_maxsize
from
    (select tablespace_name, file_id, file_name, autoextensible, bytes, maxbytes from dba_data_files where upper(tablespace_name) like upper('%&1%')
     union all
     select tablespace_name, file_id, file_name, autoextensible, bytes, maxbytes from dba_temp_files where upper(tablespace_name) like upper('%&1%')
    )
order by
    tablespace_name,
    file_name
;
