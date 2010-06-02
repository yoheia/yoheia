connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/cloneDBCreation.log
Create controlfile reuse set database "orcl"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
Datafile 
'/Users/oracle/u01/app/oracle/oradata/orcl/system01.dbf',
'/Users/oracle/u01/app/oracle/oradata/orcl/undotbs01.dbf',
'/Users/oracle/u01/app/oracle/oradata/orcl/sysaux01.dbf',
'/Users/oracle/u01/app/oracle/oradata/orcl/users01.dbf'
LOGFILE GROUP 1 ('/Users/oracle/u01/app/oracle/oradata/orcl/redo01.log') SIZE 51200K,
GROUP 2 ('/Users/oracle/u01/app/oracle/oradata/orcl/redo02.log') SIZE 51200K,
GROUP 3 ('/Users/oracle/u01/app/oracle/oradata/orcl/redo03.log') SIZE 51200K RESETLOGS;
exec dbms_backup_restore.zerodbid(0);
shutdown immediate;
startup nomount pfile="/Users/oracle/u01/app/oracle/admin/orcl/scripts/initorclTemp.ora";
Create controlfile reuse set database "orcl"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
Datafile 
'/Users/oracle/u01/app/oracle/oradata/orcl/system01.dbf',
'/Users/oracle/u01/app/oracle/oradata/orcl/undotbs01.dbf',
'/Users/oracle/u01/app/oracle/oradata/orcl/sysaux01.dbf',
'/Users/oracle/u01/app/oracle/oradata/orcl/users01.dbf'
LOGFILE GROUP 1 ('/Users/oracle/u01/app/oracle/oradata/orcl/redo01.log') SIZE 51200K,
GROUP 2 ('/Users/oracle/u01/app/oracle/oradata/orcl/redo02.log') SIZE 51200K,
GROUP 3 ('/Users/oracle/u01/app/oracle/oradata/orcl/redo03.log') SIZE 51200K RESETLOGS;
alter system enable restricted session;
alter database "orcl" open resetlogs;
alter database rename global_name to "orcl";
ALTER TABLESPACE TEMP ADD TEMPFILE '/Users/oracle/u01/app/oracle/oradata/orcl/temp01.dbf' SIZE 20480K REUSE AUTOEXTEND ON NEXT 640K MAXSIZE UNLIMITED;
select tablespace_name from dba_tablespaces where tablespace_name='USERS';
alter system disable restricted session;
connect "SYS"/"&&sysPassword" as SYSDBA
@/Users/oracle/u01/app/oracle/product/10.2.0/db_1/demo/schema/mkplug.sql &&sysPassword change_on_install change_on_install change_on_install change_on_install change_on_install change_on_install /Users/oracle/u01/app/oracle/product/10.2.0/db_1/assistants/dbca/templates/example.dmp /Users/oracle/u01/app/oracle/product/10.2.0/db_1/assistants/dbca/templates/example01.dfb /Users/oracle/u01/app/oracle/oradata/orcl/example01.dbf /Users/oracle/u01/app/oracle/admin/orcl/scripts/ "\'SYS/&&sysPassword as SYSDBA\'";
connect "SYS"/"&&sysPassword" as SYSDBA
shutdown immediate;
startup pfile="/Users/oracle/u01/app/oracle/admin/orcl/scripts/initorclTemp.ora";
alter system enable restricted session;
select sid, program, serial#, username from v$session;
alter database character set INTERNAL_CONVERT JA16SJISTILDE;
alter database national character set INTERNAL_CONVERT AL16UTF16;
alter user sys identified by "&&sysPassword";
alter user system identified by "&&systemPassword";
alter system disable restricted session;
