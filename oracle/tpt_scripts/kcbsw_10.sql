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

SELECT * FROM (
	SELECT 
		dsc.kcbwhdes,
		sw.why0, 
		sw.why1,
		sw.why2,
		sw.other_wait
	FROM
		x$kcbwh		dsc,
		x$kcbsw		sw
	WHERE
		dsc.indx = sw.indx
	AND	sw.why0 + sw.why1 + sw.why2 + sw.other_wait > 0
	ORDER by
	--	dsc.kcbwhdes
		sw.why0 + sw.why1 + sw.why2 ASC
)
--WHERE rownum <= 10
/
