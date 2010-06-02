connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/JServer.log
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/javavm/install/initjvm.sql;
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/xdk/admin/initxml.sql;
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/xdk/admin/xmlja.sql;
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catjava.sql;
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catexf.sql;
spool off
