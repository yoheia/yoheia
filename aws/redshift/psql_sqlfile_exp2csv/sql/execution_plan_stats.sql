select a.*, b.* from sys_query_detail a, sys_query_explain b, sys_query_history c
	where  a.query_id = b.query_id
		and b.plan_node_id = a.plan_node_id
		and a.query_id = c.query_id
		and c.elapsed_time > 1000*1000*60*1
order by a.query_id, a.stream_id, a.segment_id, a.step_id;


