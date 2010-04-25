connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/context.log
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/ctx/admin/catctx change_on_install SYSAUX TEMP NOLOCK;
connect "CTXSYS"/"change_on_install"
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/ctx/admin/defaults/dr0defin.sql "JAPANESE";
spool off
