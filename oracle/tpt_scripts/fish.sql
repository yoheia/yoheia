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


SET                                                                     LiNeSiZe 10000         PageSize 5000
SET                                                                                   TrimOut ON           Head Off
--                                                                  /**/
--                                                                SELECT
--                                                               LISTAGG
--                                                             (SUBSTR(s,
--                                        MOD(r2-1,115)+1,1)) WITHIN GROUP(ORDER BY r) 
--                                     FROM(SELECT rownum r,RPAD(RPAD(RPAD(RPAD(LPAD(LPAD
--                               ('(',x,'('),20,' '),x+20,')'),40,' '),40+y,' '),50,'W')s FROM(
--                                  SELECT CEIL(ABS(SIN(rownum/30)*13))x,CEIL(ABS(COS(rownum/9)*5))y
--                                     FROM dual CONNECT BY LEVEL<=115)), (SELECT rownum r2 FROM (dual)
----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                          CONNECT BY LEVEL <= 50) GROUP BY MOD(r2-1, 115)    +1;






                                                        SELECT
                                                  CHR(POWER(3,3))
                                            ||'[38;5;0m'||LISTAGG(SUBSTR(
                                      REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(s ,')',
                              CHR(POWER(3,3))||'[48;5;'||TRIM(TO_CHAR((POWER(2,4)+CEIL((SIN(r2/5)                                                 +
                      SIN(ROWNUM/150)+1)*3-1)+CEIL((-SIN(ROWNUM/150)+1)*3-1)*6+CEIL((COS(ROWNUM/150)+1)*3-1)                                 *6*6),
                '099'))||'m)'),'(',CHR(POWER(3,3))||'[48;5;'||TRIM(TO_CHAR((POWER(2,4)+CEIL((SIN(r2/5)+SIN(ROWNUM/150)                   +1)*3-1)+
         CEIL((-SIN(ROWNUM   /150)+1)*3-1)*6+CEIL((COS(ROWNUM/150)+1)*3-1)*6*6),'099'))||'m('),' ',CHR(POWER(3,3))||'[48;5;'||TRIM      (TO_CHAR(
  (POWER(2,4)+CEIL(4)+CEIL(4)*6+CEIL(5-(r2/8))*6*6),'099'))||'m '),'.',CHR(POWER(3,3))||'[48;5;'||TRIM(TO_CHAR((POWER(2,4)+CEIL(5)+CEIL(4)*6+CEIL
         (3)*6*6),'099'))||'m~'),'W',CHR(POWER(3,3))||'[48;5;'||TRIM(TO_CHAR((POWER(2,4)+CEIL(4+ABS(SIN(r/25)))+CEIL(2-ABS(SIN          (r/5))*2)
             *6+CEIL(2-ABS(SIN(r/5))*2)*6*6),'099'))||'m '),(MOD(r2-1,115)+1)*12+1,12))WITHIN GROUP(ORDER BY r)||CHR(POWER                  (3,3))           
                  ||'[0m' v FROM(SELECT ROWNUM r, RPAD(RPAD(RPAD(RPAD(LPAD(LPAD('(',x,'('),20,' '), x+20,')'),40,' '),                        40+y,
                        '.'),50,'W')s FROM (SELECT CEIL(ABS(SIN(ROWNUM/30)*13))x,CEIL(ABS(COS(ROWNUM                                              *
                              1/DBMS_RANDOM.VALUE(7,7.5))*7))y FROM dual CONNECT BY LEVEL<=115)),
                                      (SELECT ROWNUM r2 FROM dual CONNECT BY LEVEL<=50)
                                                 GROUP BY MOD(r2-1,115)+1;






