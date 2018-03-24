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
-- File name:   nonshared2.sql
-- Purpose:     Show the reasons why more child cursors were created instead of
--              reusing old ones
--              
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.e2sn.com
--              
-- Usage:       @nonshared2.sql <PRINT|NOPRINT> <sqlid>
--
--              The PRINT or NOPRINT option will control whether the REASON
--              column in XML (can be quite lengthy) will be displayed or not
--
-- Other:       Runs on Oracle 11.2.0.2+ as earlier versions don't have the 
--              V$SQL_SHARED_CURSOR.REASON column. Use nonshared.sql on older
--              versions
--
--------------------------------------------------------------------------------


COL nonshared_sql_id HEAD SQL_ID FOR A13
COL nonshared_child HEAD CHILD# FOR A10
COL nonshared_reason_and_details HEAD REASON FOR A60 WORD_WRAP
COL reason_xml FOR A100 WORD_WRAP &1
BREAK ON nonshared_sql_id 

SELECT 
    '&2' nonshared_sql_id
  , EXTRACTVALUE(VALUE(xs), '/ChildNode/ChildNumber') nonshared_child
  , EXTRACTVALUE(VALUE(xs), '/ChildNode/reason') || ': ' ||  EXTRACTVALUE(VALUE(xs), '/ChildNode/details') nonshared_reason_and_details
  , VALUE(xs) reason_xml
FROM TABLE (
    SELECT XMLSEQUENCE(EXTRACT(d, '/Cursor/ChildNode')) val FROM (
        SELECT 
            --XMLElement("Cursor", XMLAgg(x.extract('/doc/ChildNode')))
            -- the XMLSERIALIZE + XMLTYPE combo is included for avoiding a crash in qxuageag() XML aggregation function
            XMLTYPE (XMLSERIALIZE( DOCUMENT XMLElement("Cursor", XMLAgg(x.extract('/doc/ChildNode')))) ) d
        FROM 
            v$sql_shared_cursor c
          , TABLE(XMLSEQUENCE(XMLTYPE('<doc>'||c.reason||'</doc>'))) x
        WHERE
            c.sql_id = '&2'
    )
) xs
/

