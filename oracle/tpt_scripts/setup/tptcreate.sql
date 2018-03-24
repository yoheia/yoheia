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
-- File name:   TPT helper functions (TPT = Tanel Poder's Tuning package)
-- Purpose:     Create TPT package
--
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Contents:    tpt.sleep function and procedure (implement sleeping via dbms_lock.sleep)
--              tpt.sqlid_to_sqlhash   
--
--------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE tpt AUTHID DEFINER AS
--------------------------------------------------------------------------------
--
-- Package:     TPT helper functions (TPT = Tanel Poder's Tuning package)
-- Purpose:     Helper functions like sleep function, convert sql id to hash value
--
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Contents:    tpt.sleep function and procedure (implement sleeping via dbms_lock.sleep)
--              tpt.sqlid_to_sqlhash   
--
--------------------------------------------------------------------------------

    FUNCTION  sleep (seconds IN NUMBER DEFAULT 1) RETURN NUMBER;
    PROCEDURE sleep (seconds IN NUMBER DEFAULT 1);
    FUNCTION  sqlid_to_sqlhash (sqlid IN VARCHAR2) RETURN NUMBER;
    FUNCTION  get_sql_hash (name IN VARCHAR2) RETURN NUMBER;

END; -- tpt
/
SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY tpt AS
--------------------------------------------------------------------------------
--
-- Package:     TPT helper functions (TPT = Tanel Poder's Tuning package)
-- Purpose:     Helper functions like sleep function, convert sql id to hash value
--
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Contents:    tpt.sleep function and procedure (implement sleeping via dbms_lock.sleep)
--              tpt.sqlid_to_sqlhash   
--
--------------------------------------------------------------------------------

    FUNCTION sleep (seconds IN NUMBER DEFAULT 1) RETURN NUMBER AS
    BEGIN
         DBMS_LOCK.SLEEP(seconds);
         RETURN 1;
    END; -- sleep

    -----------------------------------------------------------------------

    PROCEDURE sleep (seconds IN NUMBER DEFAULT 1) AS
        tmp NUMBER;
    BEGIN
        tmp := sleep(seconds);
    END; -- sleep

    -----------------------------------------------------------------------

    FUNCTION sqlid_to_sqlhash (sqlid IN VARCHAR2) RETURN NUMBER AS
        r NUMBER := 0;
        j NUMBER := 0;
        a NUMBER := 0;
        convstr VARCHAR2(32) := '0123456789abcdfghjkmnpqrstuvwxyz';
        base    NUMBER       := 32;
    BEGIN
        FOR i IN 1..LENGTH(sqlid) LOOP
            j := LENGTH(sqlid) - i + 1; 
            a := (( POWER(base, j-1) * (INSTR(convstr,SUBSTR(sqlid,i,1))-1) ));
            r := r + a;
        END LOOP;

        RETURN TRUNC(MOD(r,POWER(2,32)));
    END; -- sqlid_to_sqlhash

    -----------------------------------------------------------------------

    FUNCTION get_sql_hash (name IN VARCHAR2) RETURN NUMBER AS
        md5_raw  RAW(16);
        pre10hash NUMBER;
        hash      NUMBER;
    BEGIN
        hash := DBMS_UTILITY.GET_SQL_HASH(name, md5_raw, pre10hash);
        --DBMS_OUTPUT.PUT_LINE(rawtohex(hash_raw));
        RETURN hash;
    END;

END; -- tpt
/
SHOW ERRORS

    
GRANT EXECUTE ON tpt TO PUBLIC;

BEGIN
    EXECUTE IMMEDIATE 'drop public synonym tpt';
EXCEPTION
    WHEN others THEN NULL;
END;
/

CREATE PUBLIC SYNONYM tpt FOR tpt;
