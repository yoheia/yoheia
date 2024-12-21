select * from svl_query_metrics where query_execution_time > 60*1 order by userid, query, dimension;

