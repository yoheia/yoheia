connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /Users/oracle/u01/app/oracle/admin/orcl/scripts/CreateDB.log
startup nomount pfile="/Users/oracle/u01/app/oracle/admin/orcl/scripts/init.ora";
CREATE DATABASE "orcl"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
DATAFILE '/Users/oracle/u01/app/oracle/oradata/orcl/system01.dbf' SIZE 300M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE '/Users/oracle/u01/app/oracle/oradata/orcl/sysaux01.dbf' SIZE 120M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
SMALLFILE DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '/Users/oracle/u01/app/oracle/oradata/orcl/temp01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED
SMALLFILE UNDO TABLESPACE "UNDOTBS1" DATAFILE '/Users/oracle/u01/app/oracle/oradata/orcl/undotbs01.dbf' SIZE 200M REUSE AUTOEXTEND ON NEXT  5120K MAXSIZE UNLIMITED
CHARACTER SET JA16SJISTILDE
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('/Users/oracle/u01/app/oracle/oradata/orcl/redo01.log') SIZE 51200K,
GROUP 2 ('/Users/oracle/u01/app/oracle/oradata/orcl/redo02.log') SIZE 51200K,
GROUP 3 ('/Users/oracle/u01/app/oracle/oradata/orcl/redo03.log') SIZE 51200K
USER SYS IDENTIFIED BY "&&sysPassword" USER SYSTEM IDENTIFIED BY "&&systemPassword";
spool off
