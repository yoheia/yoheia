connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/spatial.log
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/md/admin/mdinst.sql;
spool off
