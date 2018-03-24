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

PROMPT display a matrix of optimizer parameters which change when changing optimizer_features_enabled...

CREATE TABLE opt_param_matrix(
    opt_features_enabled VARCHAR2(100) NOT NULL
  , parameter            VARCHAR2(100) NOT NULL
  , value                VARCHAR2(1000)
);



DECLARE

BEGIN
    FOR i IN (select value from v$parameter_valid_values where name = 'optimizer_features_enable' order by ordinal) LOOP
        EXECUTE IMMEDIATE 'alter session set optimizer_features_enable='''||i.value||'''';
        EXECUTE IMMEDIATE 'insert into opt_param_matrix select :opt_features_enable, n.ksppinm, c.ksppstvl from sys.x$ksppi n, sys.x$ksppcv c where n.indx=c.indx' using i.value;
    END LOOP;
END;
/

PROMPT To test, run: @cofep.sql 10.2.0.1 10.2.0.4

