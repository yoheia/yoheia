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

col hold_mode head HOLD_MODE for a10
col req_mode head REQ_MODE for a10
col object_owner head OBJECT_OWNER for a15
col namespace for a20 word_wrap
col kgllk_state head 0xSTATE for A8

SELECT * FROM (
    SELECT
       s.sid
     , KGLLKSNM rsid
    -- , KGLLKADR
    -- , KGLLKUSE
    -- , KGLLKSES
     , decode(l.kgllkmod, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive', to_char(l.kgllkmod)) hold_mode
     , decode(l.kgllkreq, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive', to_char(l.kgllkreq)) req_mode
    -- , LPAD('0x'||TRIM(TO_CHAR(l.kgllkflg,'XXXXX')),8) kgllk_state
    -- , decode(l.kgllkflg, 0, 1, 'BROKEN', 2, 'BREAKABLE', l.kgllkflg) kgllk_state
    -- 11g stuff
    -- , kgllkest
    -- , kgllkexc
    -- , KGLLKFLG
    -- , KGLLKSPN
    -- , KGLLKHTB
       , KGLNAHSH
    -- , KGLLKSQLID
    -- , KGLHDPAR
    -- , KGLHDNSP
    -- , n.kglsttyp
     , n.kglstdsc namespace
     , USER_NAME object_owner
     , KGLNAOBJ  object_name
     , TO_CHAR(l.kgllkflg,'XXXXX') kgllk_state
     , KGLLKHDL
     , KGLLKPNC
     , KGLLKPNS
     , KGLLKCNT
    -- , KGLLKCTP -- cursor type
    FROM
       x$kgllk l
     , v$session s
     , x$kglst n
    WHERE
        s.saddr(+) = l.kgllkuse
    AND l.kglhdnsp = n.indx
    --AND kgllkhdl = hextoraw(upper(lpad('&1',vsize(l.kgllkhdl)*2,'0')))
)
WHERE &1
/
