set pagesize 1000
set linesize 300

col tablespace_name for a20
col owner for a10
col segment_cnt for 999999
col blocks for 99999999999
col kb for 999999

select	sg.tablespace_name,
		sg.owner,
		sg.segment_type,
		count(segment_name) segment_cnt, 
		sum(blocks) blocks, 
		round(sum(bytes)/1024/1024) mb
	from dba_segments sg, dba_tablespaces ts
	where sg.tablespace_name = ts.tablespace_name
	group by sg.tablespace_name, sg.owner, sg.segment_type
	order by sg.tablespace_name, sg.owner, sg.segment_type;

