connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/odm.log
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/dminst.sql SYSAUX TEMP;
spool off
