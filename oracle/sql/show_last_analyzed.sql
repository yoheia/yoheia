set pageszie 50000
set linesize 200
col owner for a10

select 'DBA_TABLES' "DICTIONARY", owner,
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_tables group by owner
	union all
select 'DBA_TAB_PARTITIONS' "DICTIONARY", table_owner "OWNER", 
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_tab_partitions group by table_owner
union all
select 'DBA_TAB_SUBPARTITIONS' "DICTIONARY", table_owner "OWNER", 
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_tab_subpartitions group by table_owner
union all
select 'DBA_INDEXES' "DICTIONARY", owner,
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_indexes group by owner
union all
select 'DBA_IND_PARTITIONS' "DICTIONARY", index_owner "OWNER", 
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_ind_partitions group by index_owner
union all
select 'DBA_IND_SUBPARTITIONS' "DICTIONARY", index_owner "OWNER", 
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_ind_subpartitions group by index_owner
union all
select 'DBA_TAB_COLUMNS' "DICTIONARY", owner "OWNER", 
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_tab_columns group by owner
union all
select 'DBA_TAB_COL_STATISTICS' "DICTIONARY", owner "OWNER", 
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_tab_col_statistics group by owner
union all
select 'DBA_PART_COL_STATISTICS' "DICTIONARY", owner "OWNER", 
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_part_col_statistics group by owner
union all
select 'DBA_SUBPART_COL_STATISTICS' "DICTIONARY", owner "OWNER", 
		to_char(min(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MIN",
		to_char(max(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "MAX",
		to_char(median(last_analyzed),'YYYY-MM-DD HH24:MI:SS') "AVG",
		to_date(max(last_analyzed)) - to_date(min(last_analyzed)) "MAX-MIN"
	from dba_subpart_col_statistics group by owner
;
