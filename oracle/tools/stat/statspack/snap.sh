#!/bin/sh

LANG=C
export LANG
NLS_LANG=American_America.JA16EUC
export NLS_LANG

BASE_DIR=`dirname $0`

cd $BASE_DIR
sqlplus perfstat/perfstat @snap.sql

