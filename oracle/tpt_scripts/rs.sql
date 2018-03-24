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
-- File name:   rs.sql
-- Purpose:     Display available Redo Strands
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @rs
--          
-- Other:       Shows both public and private redo strands
--
--------------------------------------------------------------------------------

COL rs_indx HEAD STR# FOR 999

prompt Display available redo strands in the instance (both private and public)...

SELECT 
    indx                            rs_indx,
    first_buf_kcrfa                 firstbufadr,
    last_buf_kcrfa                  lastbufadr,
    pnext_buf_kcrfa_cln             nxtbufadr, 
    next_buf_num_kcrfa_cln          nxtbuf#, 
    strand_header_bno_kcrfa_cln     flushed,
    total_bufs_kcrfa                totbufs#, 
    strand_size_kcrfa               strsz,
    space_kcrf_pvt_strand           strspc,
    bytes_in_buf_kcrfa_cln          "B/buf", 
    pvt_strand_state_kcrfa_cln      state,
    strand_num_ordinal_kcrfa_cln    strand#, 
    ptr_kcrf_pvt_strand             stradr, 
    index_kcrf_pvt_strand           stridx, 
    txn_kcrf_pvt_strand             txn
FROM 
        x$kcrfstrand
/


