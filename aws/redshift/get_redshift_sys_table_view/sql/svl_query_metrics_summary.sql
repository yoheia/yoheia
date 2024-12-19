select a.*, b.xid, b.elapsed, b.starttime, b.endtime, b.aborted, b.source_query, b.concurrency_scaling_status_txt, b.from_sp_call, b.substring
from svl_query_metrics_summary a,svl_qlog b
where a.userid = b.userid
	and a.query = b.query
	and b.elapsed > 1000*1000*60*15
order by b.elapsed desc;
