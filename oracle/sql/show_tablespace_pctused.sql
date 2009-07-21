--$Id:$
--Show pctused of all tablespaces;

ttitle - 
   center  'Database Freespace Summary'  skip 2 
 
comp sum of nfrags totsiz avasiz on report 
break on report 

set pages 999
col tsname  format     a16 justify c heading 'Tablespace' 
col nfrags  format 999,990 justify c heading 'Free|Frags' 
col mxfrag  format 999,999 justify c heading 'Largest|Frag (MB)' 
col totsiz  format 999,999 justify c heading 'Total|(MB)' 
col avasiz  format 999,999 justify c heading 'Available|(MB)' 
col pctusd  format     990 justify c heading 'Pct|Used' 

select total.TABLESPACE_NAME tsname,
       D nfrags,
       C/1024/1024 mxfrag,
       A/1024/1024 totsiz,
       B/1024/1024 avasiz,
       (1-nvl(B,0)/A)*100 pctusd
from
    (select sum(bytes) A,
            tablespace_name
            from dba_data_files
            group by tablespace_name) TOTAL,
    (select sum(bytes) B,
            max(bytes) C,
            count(bytes) D, 
            tablespace_name
            from dba_free_space
            group by tablespace_name) FREE
where 
      total.TABLESPACE_NAME=free.TABLESPACE_NAME(+);
