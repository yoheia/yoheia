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
-- Author:	Tanel Poder
-- Copyright:	(c) http://www.tanelpoder.com
-- 
-- Notes:	This software is provided AS IS and doesn't guarantee anything
-- 		Proofread before you execute it!
--
--------------------------------------------------------------------------------

-- add on script for pre-10g databases which need to record CPU usage
-- for long-running calls (as 9i doesnt update session cpu usage in 
-- v$ views before end of call)
--
-- this script needs tidying up
--


-- rm /tmp/sawr_vmstat_pipe
-- rm /tmp/sawr_ps_pipe

-- mknod /tmp/sawr_vmstat_pipe p
-- mknod /tmp/sawr_ps_pipe p

-- create directory osstat as 'c:/tmp';
-- drop directory sawr$osstat;

create directory sawr$osstat as '/tmp';

grant read,write on directory sawr$osstat to &spuser;


drop table vmstat;
drop table ps;

CREATE TABLE sawr$ext_vmstat (
	value number,
	parameter varchar2(100)
)
ORGANIZATION EXTERNAL (
  TYPE oracle_loader
  DEFAULT DIRECTORY sawr$osstat
    ACCESS PARAMETERS (
    FIELDS TERMINATED BY ';'
    MISSING FIELD VALUES ARE NULL
    (value, parameter)
    )
    LOCATION ('sawr_vmstat_pipe')
  )
;

CREATE TABLE sawr$ext_ps (
	ospid varchar2(100),
	value varchar2(100)
)
ORGANIZATION EXTERNAL (
  TYPE oracle_loader
  DEFAULT DIRECTORY sawr$osstat
    ACCESS PARAMETERS (
    FIELDS TERMINATED BY ';'
    MISSING FIELD VALUES ARE NULL
    (ospid, value)
    )
    LOCATION ('sawr_ps_pipe')
  )
;

