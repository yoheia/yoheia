/* returned_rows */ select c.starttime
		,c.endtime
		,d.remotehost
        ,'Redshift' servie_type
		,c.database
		,a.userid
        ,d.username
        ,a.query
        ,a.substring sql
        ,b.rows
from svl_qlog a join stl_return b
                on a.query=b.query
        join stl_query c
        on c.query = a.query
        join stl_connection_log d
        on d.pid = c.pid
where
    b.slice >= 6411
    and a.userid != 1
    and c.starttime between '2020-04-21 11:30' and '2020-04-21 12:00'
    and sql not like '/* returned_rows */%'
union all
select  c.starttime
		,c.endtime
		,d.remotehost
        ,'Redshift' servie_type
		,c.database
		,a.userid
        ,d.username
        ,a.query
        ,a.substring sql
        ,b.rows
from svl_qlog a join stl_return b
        on a.source_query=b.query
        join stl_query c
        on c.query = a.query
        join stl_connection_log d
        on d.pid = c.pid
where
    sql not like '/* returned_rows */%'
    and c.starttime between '2020-04-21 11:30' and '2020-04-21 12:00'
order by
query desc