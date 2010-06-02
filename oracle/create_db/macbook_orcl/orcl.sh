#!/bin/sh

mkdir -p /Users/oracle/u01/app/oracle/admin/orcl/adump
mkdir -p /Users/oracle/u01/app/oracle/admin/orcl/bdump
mkdir -p /Users/oracle/u01/app/oracle/admin/orcl/cdump
mkdir -p /Users/oracle/u01/app/oracle/admin/orcl/dpdump
mkdir -p /Users/oracle/u01/app/oracle/admin/orcl/pfile
mkdir -p /Users/oracle/u01/app/oracle/admin/orcl/udump
mkdir -p /Users/oracle/u01/app/oracle/oradata/orcl
mkdir -p /Users/oracle/u01/app/oracle/product/10.2.0/db_1/cfgtoollogs/dbca/orcl
mkdir -p /Users/oracle/u01/app/oracle/product/10.2.0/db_1/dbs
ORACLE_SID=orcl; export ORACLE_SID
echo /etc/oratab: orcl:/Users/oracle/u01/app/oracle/product/10.2.0/db_1:Y‚É‚±‚ÌƒGƒ“ƒgƒŠ‚ð’Ç‰Á‚µ‚Ä‚­‚¾‚³‚¢
/Users/oracle/u01/app/oracle/product/10.2.0/db_1/bin/sqlplus /nolog @/Users/oracle/u01/app/oracle/admin/orcl/scripts/orcl.sql
