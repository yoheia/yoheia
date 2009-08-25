SELECT /*+ INDEX (s) INDEX (w) */
to_char(sysdate, 'MMDDHH24MISS')||','||s.SID||','||s.MACHINE||','||s.USERNAME||
','||s.COMMAND||','||s.STATUS||','||s.PROGRAM||','||s.SQL_ADDRESS||','||
s.SQL_HASH_VALUE||','||s.PREV_SQL_ADDR||','||s.PREV_HASH_VALUE||','||
to_char(s.LOGON_TIME,'MMDDHH24MISS')||','||w.EVENT||', '||w.P1||','||
w.P2||','||w.P3||','||w.WAIT_TIME||','||w.SECONDS_IN_WAIT
FROM V$SESSION s, V$SESSION_WAIT w
WHERE s.SID = w.SID
AND (s.STATUS = 'ACTIVE'
OR w.EVENT NOT IN ('SQL*Net message to client','SQL*Net message from client'));

