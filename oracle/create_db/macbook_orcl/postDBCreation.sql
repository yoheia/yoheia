connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/postDBCreation.log
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='/Users/oracle/u01/app/oracle/product/10.2.0/db_1/dbs/spfileorcl.ora' FROM pfile='/Users/oracle/u01/app/oracle/admin/orcl/scripts/init.ora';
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/postDBCreation.log
