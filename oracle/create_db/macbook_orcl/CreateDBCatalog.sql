connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/CreateDBCatalog.log
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catalog.sql;
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catblock.sql;
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catproc.sql;
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/catoctk.sql;
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/rdbms/admin/owminst.plb;
connect "SYSTEM"/"&&systemPassword"
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/sqlplus/admin/pupbld.sql;
connect "SYSTEM"/"&&systemPassword"
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/sqlPlusHelp.log
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/sqlplus/admin/help/hlpbld.sql helpus.sql;
spool off
spool off
