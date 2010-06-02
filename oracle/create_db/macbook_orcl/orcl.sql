set verify off
PROMPT specify a password for sys as parameter 1;
DEFINE sysPassword = &1
PROMPT specify a password for system as parameter 2;
DEFINE systemPassword = &2
host /Users/oracle/u01/app/oracle/product/10.2.0/db_1/bin/orapwd file=/Users/oracle/u01/app/oracle/product/10.2.0/db_1/dbs/orapworcl password=&&sysPassword force=y
@/Users/oracle/u01/app/oracle/admin/orcl/scripts/CloneRmanRestore.sql
@/Users/oracle/u01/app/oracle/admin/orcl/scripts/cloneDBCreation.sql
@/Users/oracle/u01/app/oracle/admin/orcl/scripts/postScripts.sql
@/Users/oracle/u01/app/oracle/admin/orcl/scripts/postDBCreation.sql
