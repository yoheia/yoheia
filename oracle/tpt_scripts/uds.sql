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

prompt Show undo statistics from V$UNDOSTAT....
col uds_mb head MB format 999999.99
col uds_maxquerylen head "MAX|QRYLEN" format 999999
col uds_maxqueryid  head "MAX|QRY_ID" format a13 
col uds_ssolderrcnt head "ORA-|1555" format 999
col uds_nospaceerrcnt head "SPC|ERR" format 99999
col uds_unxpstealcnt head "UNEXP|STEAL" format 99999
col uds_expstealcnt head "EXP|STEAL" format 99999

select * from (
    select 
        begin_time, 
        to_char(end_time, 'HH24:MI:SS') end_time, 
        txncount, 
        undoblks * (select block_size from dba_tablespaces where upper(tablespace_name) = 
                        (select upper(value) from v$parameter where name = 'undo_tablespace')
                   ) / 1048576 uds_MB ,
        maxquerylen uds_maxquerylen,
        maxqueryid  uds_maxqueryid,
        ssolderrcnt uds_ssolderrcnt,
        nospaceerrcnt uds_nospaceerrcnt,
 	unxpstealcnt uds_unxpstealcnt,
	expstealcnt uds_expstealcnt
    from 
        v$undostat
    order by
        begin_time desc
) where rownum <= 30;
