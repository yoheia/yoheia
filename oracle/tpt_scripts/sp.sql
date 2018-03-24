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

prompt Show SPFILE parameters from v$spparameter matching %&1%
col sp_name head NAME for a40
col sp_value head VALUE for a80
col sp_sid head SID for a10

select sid sp_sid, name sp_name, value sp_value, isspecified from v$spparameter where lower(name) like lower('%&1%') and isspecified = 'TRUE';
