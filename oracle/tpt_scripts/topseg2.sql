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

prompt Show top space users per tablespace - collapse partitions to table/index level

col topseg_seg_owner HEAD OWNER FOR A30
col topseg_segment_name head SEGMENT_NAME for a30
col topseg_segment_type head SEGMENT_TYPE for a30

select * from (
    select
        tablespace_name,
        owner,
        segment_name topseg_segment_name,
        --partition_name,
        REPLACE(segment_type, ' PARTITION', ' - PARTITIONED') topseg_segment_type,
        count(*),
        round(sum(bytes)/1048576) MB
    from dba_segments
    where upper(tablespace_name) like upper('%&1%')
    group by tablespace_name, owner, segment_name, segment_type
    order by MB desc
)
where rownum <= 30;

