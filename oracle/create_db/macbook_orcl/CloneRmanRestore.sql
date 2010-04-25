connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/CloneRmanRestore.log
startup nomount pfile="/Users/oracle/u01/app/oracle/admin/orcl/scripts/init.ora";
@/Users/oracle/u01/app/oracle/admin/orcl/scripts/rmanRestoreDatafiles.sql;
