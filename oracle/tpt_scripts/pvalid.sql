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
-- File name:   pvalid.sql
-- Purpose:     Show valid parameter values from V$PARAMETER_VALID_VALUES
--              underlying X$ table X$KSPVLD_VALUES
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @pvalid <param_name>
--
-- 	        @pvalid optimizer
--
--------------------------------------------------------------------------------

COL pvalid_default HEAD DEFAULT FOR A7
COL pvalid_value   HEAD VALUE   FOR A30
COL pvalid_name    HEAD PARAMETER FOR A50
COL pvalid_par#    HEAD PAR# FOR 99999

BREAK ON pvalid_par# skip 1

PROMPT Display valid values for multioption parameters matching "&1"...

SELECT 
--	INST_ID, 
	PARNO_KSPVLD_VALUES     pvalid_par#,
	NAME_KSPVLD_VALUES      pvalid_name, 
	ORDINAL_KSPVLD_VALUES   ORD, 
	VALUE_KSPVLD_VALUES	pvalid_value,
	DECODE(ISDEFAULT_KSPVLD_VALUES, 'FALSE', '', 'DEFAULT' ) pvalid_default
FROM 
	X$KSPVLD_VALUES 
WHERE 
	LOWER(NAME_KSPVLD_VALUES) LIKE LOWER('%&1%')
ORDER BY
	pvalid_par#,
	pvalid_default,
  ord,
	pvalid_Value
/
