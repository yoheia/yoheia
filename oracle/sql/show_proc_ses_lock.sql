set pagesize 1000
set linesize 300
col ospid for a5
col block for 99999
col sid for 99999
col serial# for 99999
col username for a10
col lmode for 99
col request for 99
col lock_time for a10
col program for a10
col machine for a10
col osuser for a10
col sql for a40

select proc.spid ospid, 
	ses.blocking_session block,
	ses.sid, 
	ses.serial#,
	substr(ses.username,1,10) username,
	ses.status,
	lk.type,
	lk.lmode,
	lk.request,
	id1,
	id2,
	to_char(lk.ctime/60, '9990.9') lock_time,
	sql.hash_value,
	sql.address,
	substr(sql_text,1, 40) sql,
	substr(ses.machine,1,10) machine, 
	substr(ses.osuser,1,10) osuser,
	substr(ses.program,1,10) program
from v$session ses, v$process proc, v$sql sql, v$lock lk
	where ses.type = 'USER'
		and ses.paddr = proc.addr
		and ses.sid = lk.sid(+)
		and ses.sql_address = sql.address(+)
order by username, machine, osuser, program;