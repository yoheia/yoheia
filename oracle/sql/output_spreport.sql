--http://d.hatena.ne.jp/MATSU/20090822/1250944663
--Regular version

set pages 0
spool statsall_a.sql
 select 
 'define begin_snap='  || SNAP_ID      || chr(10) ||
 'define end_snap='    || (SNAP_ID + 1)|| chr(10) ||
 'define report_name=' || SNAP_ID || '_' || (SNAP_ID + 1) || '.txt'  ||
 chr(10) ||
 '@?/rdbms/admin/spreport.sql' || chr(10)
 from stats$snapshot
 /* Only the latest
 where snap_id > 
     (select max(snap_id)-3 from stats$snapshot)
 order by snap_id
 */
 ;
spool off
@statsall_a.sql
