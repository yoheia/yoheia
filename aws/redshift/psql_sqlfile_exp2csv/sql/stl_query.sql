select * from stl_query where datediff(seconds, starttime, endtime) > 60 order by starttime;

