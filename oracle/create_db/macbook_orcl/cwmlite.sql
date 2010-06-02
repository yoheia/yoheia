set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/cwmlite.log
connect "SYS"/"&&sysPassword" as SYSDBA
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/olap/admin/olap.sql SYSAUX TEMP;
spool off
