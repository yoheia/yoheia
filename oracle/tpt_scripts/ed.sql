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

define _ed_tmp_editor="&_editor"
define _editor="&_editor"

ed &1

define _editor="&_ed_tmp_editor"
undefine _ed_tmp_editor

-- for unix use smth like:
--     define _editor="host xterm -c vi &1 &#"
-- or
--     define _editor="host nedit &1 &#"
