connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/ordinst.log
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/ord/admin/ordinst.sql SYSAUX SYSAUX;
spool off
