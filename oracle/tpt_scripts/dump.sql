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

-- prompt @dump <file#> <block#> <what regexp>

--select dump(&1) dec from dual;
--select dump(&1,16) hex from dual;

@ti
set termout off

alter system dump datafile &1 block &2;

--host "cat &trc | grep -v '\[................\]$' | grep -v 'col ' | grep -v 'tab ' | grep -v 'Dump of memory' | grep -v ' Repeat ' | grep &3"
host "cat &trc | grep -v '\[................\]' | grep -v '^\*\*\*' | grep -v '^Dump of memory' | grep -v '    Repeat ' | grep -A15 '&3'"

set termout on
