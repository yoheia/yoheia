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
-- File name:   usql (show outher User's SQL)
-- Purpose:     Show another session's SQL directly from library cache
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @usql <sid>
-- 	        @usql 150
--	        
-- Other:       This script calls sql.sql (for displaying SQL text) and xmsh.sql
--              (for displaying execution plan)           
--              
--
--------------------------------------------------------------------------------


def _usql_sid="&1"

@@sql  "select /*+ NO_MERGE */ sql_hash_value from v$session where sid in (&_usql_sid)"
--@@xmsh "select /*+ NO_MERGE */ sql_hash_value from v$session where sid in (&_usql_sid)" %

undef _usql_sid
