connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/xdb_protocol.log
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect "SYS"/"&&sysPassword" as SYSDBA
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catxdbj.sql;
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catrul.sql;
spool off
