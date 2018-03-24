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
		why.why0, 
		why.why1,
		why.why2,
		sw.other_wait
	FROM
		x$kcbuwhy	why,
		x$kcbwh		dsc,
		x$kcbsw		sw
	WHERE
		why.indx = dsc.indx
	AND	why.why0 + why.why1 + why.why2 + sw.other_wait > 0
	AND dsc.indx = sw.indx
	AND why.indx = sw.indx
	ORDER by
	--	dsc.kcbwhdes
		why.why0 + why.why1 + why.why2 ASC
)
--WHERE rownum <= 10
/
