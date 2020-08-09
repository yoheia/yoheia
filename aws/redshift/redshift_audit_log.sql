/* returned_rows */ select max(d.starttime) as starttime
	,max(d.endtime) as endtime
	,'Redshift' as servie_type
	,max(d.database)  as database 
	,max(d.userid)  as userid
	,d.query
	,max(d.sql) as sql
	,max(d.rows) as rows
	,max(d.pid) as pid
    ,max(g.remotehost) as remotehost
    ,max(g.username) as username
from (select c.starttime
		,c.endtime
		,'Redshift' servie_type
		,c.database
		,a.userid
		,a.query
		,a.substring sql
		,b.rows
		,c.pid
from svl_qlog a join stl_return b
				on a.query=b.query
		join stl_query c
		on c.query = a.query
where
	b.slice >= 6411
	and a.userid != 1
	and c.starttime between '2020-08-09 00:00' and '2020-08-09 23:59'
	and sql not like '/* returned_rows */%'
union all
select  c.starttime
		,c.endtime
		,'Redshift' servie_type
		,c.database
		,a.userid
		,a.query
		,a.substring sql
		,b.rows
		,c.pid
from svl_qlog a join stl_return b
		on a.source_query=b.query
		join stl_query c
		on c.query = a.query
where
	sql not like '/* returned_rows */%'
	and c.starttime between '2020-08-09 00:00' and '2020-08-09 23:59') d left outer join 
		(select e.pid, e.remotehost, e.username, f.usesysid, e.recordtime
			from stl_connection_log e 
				join SVL_USER_INFO f 
					on e.username = f.usename
			where e.event = 'authenticated' ) g
on d.pid = g.pid 
	and d.userid = g.usesysid 
	and d.starttime > g.recordtime
group by query