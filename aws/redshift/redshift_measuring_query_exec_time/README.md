## Redshift クエリ単体性能計測スクリプト

* Amazon Redshift でクエリの単体性能（実行時間）を計測するための bash/sql スクリプトです。
* 主な処理内容は以下の通り。
	* リザルトキャッシュを OFF に設定
	* 対象テーブルを VACUUM & ANALYZE
	* 実行時間を計測
		* クライアントサイド：`\timing on`
		* サーバサイド：`STL_QUERY` の `endtime` - `starttime`  
	* クエリの性能統計情報を取得
		* `STL_QUERY`, `SVL_QUERY_SUMMARY`, `STL_EXPLAIN`, `STL_WLM_QUERY`, `SVL_QUERY_REPORT` 
	* 計測時の構成・バージョン情報を取得
		* Redshift の構成情報: `aws redshift describe-clusters`
			* IAM権限 `redshift:DescribeClusters` が必要（[参考URL](https://docs.aws.amazon.com/ja_jp/redshift/latest/mgmt/redshift-iam-access-control-overview.html)）   
		* Redshift のバージョン情報: `select version()` 
		* テーブルの統計情報: `select * from svv_table_info` 

## 設定方法

* スクリプトを取得する

```bash
$ git clone https://github.com/yoheia/yoheia.git
```

* パーミッションを設定する

```bash
$ cd yoheia/aws/redshift/redshift_measuring_query_exec_time
$ chmod u+x redshift_measuring_query_exec_time.sh
```

* `redshift_measuring_query_exec_time.sh` を編集し、接続情報を設定する

```bash
# Redshift のエンドポイント
PG_HOST=${PG_HOST:-redshift-cluster-2.********.ap-northeast-1.redshift.amazonaws.com}
# Redshift のユーザー名
PG_USER=${PG_USER:-awsuser}
# Redshift のDB名
PG_DB=${PG_DB:-dev}
```

* Redshift のパスワードを設定する（実行時に毎度入力する必要がないよう設定する）

```bash
$ vi ~/.pgpass
#hostname:port:database:username:password
redshift-cluster-1.********.ap-northeast-1.redshift.amazonaws.com:5439:dev:awsuser:Password123
```

* `exec_query_perf.sql` を編集して、計測するSQLスクリプトファイルを指定する。

```sql
-- execute target query
\i lineorder_count.sql
```

* SQL スクリプトファイルではアクセス対象テーブルの vacuum & analyze し、対象クエリを記述する。

```sql
-- vacuum and analyze
vacuum lineorder;
analyze lineorder;

select count(a.*) from lineorder a;
```

* 本スクリプトを実行する EC2 インスタンスに IAM権限 `redshift:DescribeClusters` を付与する。
	* EC2 にアタッチする IAM ロールに `redshift:DescribeClusters` を許可したIAMポリシーをアタッチするなど。

## 実行方法

* 実行する

```bash
$ ./redshift_measuring_query_exec_time.sh
```

## 実行結果を確認する

* log ディレクトリ以下にログ出力される。suffix が `_env_info` は Redshift の構成情報・バージョン情報、`_query_perf` は性能計測結果。

```bash
$ ls -1 log/
total 36
-rw-rw-r-- 1 ec2-user ec2-user   81 Nov  9 04:01 redshift_measuring_query_exec_time_2021-11-09-040100_query_perf.log
-rw-rw-r-- 1 ec2-user ec2-user 7078 Nov  9 04:01 redshift_measuring_query_exec_time_2021-11-09-040100_env_info.log
-rw-rw-r-- 1 ec2-user ec2-user 7065 Nov  9 04:03 redshift_measuring_query_exec_time_2021-11-09-040307_env_info.log
-rw-rw-r-- 1 ec2-user ec2-user   60 Nov  9 04:03 redshift_measuring_query_exec_time_2021-11-09-040307_query_perf.log
-rw-rw-r-- 1 ec2-user ec2-user 7065 Nov  9 04:04 redshift_measuring_query_exec_time_2021-11-09-040401_env_info.log
-rw-rw-r-- 1 ec2-user ec2-user 1670 Nov  9 04:04 redshift_measuring_query_exec_time_2021-11-09-040401_query_perf.log
```

* `redshift_measuring_query_exec_time_YYYY-MM-DD-HHMMSS_env_info.log` ログの内容は以下の通り。
	* Redshift の構成情報: `aws redshift describe-clusters`
	* Redshift のバージョン情報: `select version()` 
	* テーブルの統計情報: `select * from svv_table_info` 

```bash
$ head -10  redshift_measuring_query_exec_time_2021-11-18-005131_env_info.log
2021-11-18-00:51:31
{
    "Clusters": [
        {
            "PubliclyAccessible": false,
            "MasterUsername": "awsuser",
            "VpcSecurityGroups": [
                {
                    "Status": "active",
                    "VpcSecurityGroupId": "sg-086f4a6e"
$ tail -20  redshift_measuring_query_exec_time_2021-11-18-005131_env_info.log
set enable_result_cache_for_session=off;
SET
Time: 3.347 ms
-- show Redshift version
select version();
                                                          version
---------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 8.0.2 on i686-pc-linux-gnu, compiled by GCC gcc (GCC) 3.4.2 20041017 (Red Hat 3.4.2-6.fc3), Redshift 1.0.32946
(1 row)

Time: 3.436 ms
-- show table stats
select * from svv_table_info;
 database | schema | table_id |   table   |     encoded     | diststyle  |   sortkey1    | max_varchar | sortkey1_enc | sortkey_num | size  | pct_used | empty | unsorted | stats_off | tbl_rows  | skew_sortkey1 | skew_rows | estimated_visible_rows | risk_event | vacuum_sort_benefit
----------+--------+----------+-----------+-----------------+------------+---------------+-------------+--------------+-------------+-------+----------+-------+----------+-----------+-----------+---------------+-----------+------------------------+------------+---------------------
 dev      | public |   128384 | lineorder | Y, AUTO(ENCODE) | AUTO(EVEN) | AUTO(SORTKEY) |          15 |              |           0 | 25082 |   6.9314 |   0 |          |      0.00 | 600037902 |               |           |              600037888 |            |
(1 row)

Time: 620.233 ms
\q
```

* `redshift_measuring_query_exec_time_YYYY-MM-DD-HHMMSS_query_perf.log` ログの内容は以下の通り。
 * vacuum & analyze 後に、対象クエリを実行し、`STL_QUERY` からクエリの実行時間を取得している。
 * リザルトキャッシュは OFF で計測している。

```bash
$ cat redshift_measuring_query_exec_time_2021-11-09-040401_query_perf.log
2021-11-18-00:51:32
-- Current timestamp(UTC)
select getdate();
       getdate
---------------------
 2021-11-18 00:51:32
(1 row)

--timing on
\timing on
Timing is on.
--pager off
\pset pager
Pager usage is off.
-- result cache off
set enable_result_cache_for_session=off;
SET
Time: 2.973 ms
-- execute target query
\i lineorder_count.sql
-- vacuum and analyze
vacuum lineorder;
VACUUM
Time: 1897.568 ms (00:01.898)
analyze lineorder;
ANALYZE SKIP
Time: 21.902 ms
select count(a.*) from lineorder a;
   count
-----------
 600037902
(1 row)

Time: 39.937 ms
-- query id
select pg_last_query_id();
 pg_last_query_id
------------------
           308978
(1 row)

Time: 3.168 ms
\gset
Time: 2.978 ms
-- execution time
select userid,
        trim(database) "database",
        trim(label) as label,
        query,
        xid,
        pid,
        datediff(milliseconds, starttime, endtime) as "exec_time(ms)",
        starttime,
        endtime,
        aborted,
        insert_pristine,
        concurrency_scaling_status,
        trim(querytxt) as query_text
        from STL_QUERY where query = :pg_last_query_id;
 userid | database |  label  | query  |   xid   | pid  | exec_time(ms) |         starttime         |          endtime           | aborted | insert_pristine | concurrency_scaling_status |             query_text
--------+----------+---------+--------+---------+------+---------------+---------------------------+----------------------------+---------+-----------------+----------------------------+-------------------------------------
    100 | dev      | default | 308978 | 2166033 | 5842 |            28 | 2021-11-18 00:51:34.53772 | 2021-11-18 00:51:34.565941 |       0 |0 |                         19 | select count(a.*) from lineorder a;
(1 row)

Time: 139.696 ms
-- show execution plan
select query,
       maxtime,
       avgtime,
       rows,
       bytes,
       lpad(' ',stm+seg+step) || label as label,
       is_diskbased,
       workmem,
       is_rrscan,
       is_delayed_scan,
       rows_pre_filter
from svl_query_summary
where query = :pg_last_query_id
order by stm, seg, step;
 query  | maxtime | avgtime |   rows    |   bytes    |                    label                     | is_diskbased | workmem | is_rrscan | is_delayed_scan | rows_pre_filter
--------+---------+---------+-----------+------------+----------------------------------------------+--------------+---------+-----------+-----------------+-----------------
 308978 |   20268 |   20235 | 600037902 | 4800303216 | scan   tbl=128384 name=lineorder             | f            |       0 | f         | f |       600037902
 308978 |   20268 |   20235 | 600037902 |          0 |  project                                     | f            |       0 | f         | f |               0
 308978 |   20268 |   20235 | 600037902 |          0 |   project                                    | f            |       0 | f         | f |               0
 308978 |   20268 |   20235 |         2 |         16 |    aggr   tbl=934                            | f            |       0 | f         | f |               0
 308978 |     143 |     137 |         2 |         16 |   scan   tbl=934 name=Internal Worktable     | f            |       0 | f         | f |               0
 308978 |     143 |     137 |         2 |         16 |    return                                    | f            |       0 | f         | f |               0
 308978 |    1410 |    1410 |         2 |         16 |    scan   tbl=249848 name=Internal Worktable | f            |       0 | f         | f |               0
 308978 |    1410 |    1410 |         1 |         16 |     aggr   tbl=939                           | f            |       0 | f         | f |               0
 308978 |      63 |      63 |         1 |         16 |      scan   tbl=939 name=Internal Worktable  | f            |       0 | f         | f |               0
 308978 |      63 |      63 |         1 |          0 |       project                                | f            |       0 | f         | f |               0
 308978 |      63 |      63 |         1 |          0 |        project                               | f            |       0 | f         | f |               0
 308978 |      63 |      63 |         1 |         15 |         return                               | f            |       0 | f         | f |               0
(12 rows)

Time: 3001.376 ms (00:03.001)
-- STL_EXPLAIN
select query,
        nodeid,
        parentid,
        substring(plannode from 1 for 200) as plannode,
        substring(info from 1 for 100) as info
from stl_explain
where query = :pg_last_query_id
order by 1,2;
 query  | nodeid | parentid |                                     plannode                                     | info
--------+--------+----------+----------------------------------------------------------------------------------+------
 308978 |      1 |        0 | XN Aggregate  (cost=7500473.60..7500473.60 rows=1 width=0)                       |
 308978 |      2 |        1 |   ->  XN Seq Scan on lineorder a  (cost=0.00..6000378.88 rows=600037888 width=0) |
(2 rows)

Time: 209.882 ms
-- STL_WLM_QUERY
select * from STL_WLM_QUERY
where query = :pg_last_query_id
order by service_class;
 userid |   xid   |  task  | query  | service_class | slot_count |  service_class_start_time  |      queue_start_time      |       queue_end_time       |total_queue_time |      exec_start_time       |       exec_end_time       | total_exec_time |  service_class_end_time   |   final_state    | est_peak_mem|    query_priority    |                        service_class_name
--------+---------+--------+--------+---------------+------------+----------------------------+----------------------------+----------------------------+------------------+----------------------------+---------------------------+-----------------+---------------------------+------------------+--------------+----------------------+------------------------------------------------------------------
    100 | 2166033 | 242060 | 308978 |           100 |          1 | 2021-11-18 00:51:34.538381 | 2021-11-18 00:51:34.538433 | 2021-11-18 00:51:34.538433 |               0 | 2021-11-18 00:51:34.538437 | 2021-11-18 00:51:34.56535 |           26913 | 2021-11-18 00:51:34.56535 | Completed        |      2097152| Normal               | Default queue
(1 row)

Time: 161.336 ms
-- SVL_QUERY_REPORT
select * from SVL_QUERY_REPORT
where query = :pg_last_query_id
order by segment, step, slice;
 userid | query  | slice | segment | step |         start_time         |          end_time          | elapsed_time |   rows    |   bytes    |      label                   | is_diskbased | workmem | is_rrscan | is_delayed_scan | rows_pre_filter
--------+--------+-------+---------+------+----------------------------+----------------------------+--------------+-----------+------------+-------------------------------------------+--------------+---------+-----------+-----------------+-----------------
    100 | 308978 |     0 |       0 |    0 | 2021-11-18 00:51:34.540569 | 2021-11-18 00:51:34.560772 |        20203 | 300018951 | 2400151608 | scan   tbl=128384 name=lineorder          | f            |       0 | f         | f               |       300018951
    100 | 308978 |     1 |       0 |    0 | 2021-11-18 00:51:34.540569 | 2021-11-18 00:51:34.560837 |        20268 | 300018951 | 2400151608 | scan   tbl=128384 name=lineorder          | f            |       0 | f         | f               |       300018951
    100 | 308978 |     0 |       0 |    1 | 2021-11-18 00:51:34.540569 | 2021-11-18 00:51:34.560772 |        20203 | 300018951 |          0 | project                              | f            |       0 | f         | f               |               0
    100 | 308978 |     1 |       0 |    1 | 2021-11-18 00:51:34.540569 | 2021-11-18 00:51:34.560837 |        20268 | 300018951 |          0 | project                              | f            |       0 | f         | f               |               0
    100 | 308978 |     0 |       0 |    2 | 2021-11-18 00:51:34.540569 | 2021-11-18 00:51:34.560772 |        20203 | 300018951 |          0 | project                              | f            |       0 | f         | f               |               0
    100 | 308978 |     1 |       0 |    2 | 2021-11-18 00:51:34.540569 | 2021-11-18 00:51:34.560837 |        20268 | 300018951 |          0 | project                              | f            |       0 | f         | f               |               0
    100 | 308978 |     0 |       0 |    3 | 2021-11-18 00:51:34.540569 | 2021-11-18 00:51:34.560772 |        20203 |         1 |          8 | aggr   tbl=934                            | f            |       0 | f         | f               |               0
    100 | 308978 |     1 |       0 |    3 | 2021-11-18 00:51:34.540569 | 2021-11-18 00:51:34.560837 |        20268 |         1 |          8 | aggr   tbl=934                            | f            |       0 | f         | f               |               0
    100 | 308978 |     0 |       1 |    0 | 2021-11-18 00:51:34.563224 | 2021-11-18 00:51:34.563355 |          131 |         1 |          8 | scan   tbl=934 name=Internal Worktable    | f            |       0 | f         | f               |               0
    100 | 308978 |     1 |       1 |    0 | 2021-11-18 00:51:34.563387 | 2021-11-18 00:51:34.56353  |          143 |         1 |          8 | scan   tbl=934 name=Internal Worktable    | f            |       0 | f         | f               |               0
    100 | 308978 |     0 |       1 |    1 | 2021-11-18 00:51:34.563224 | 2021-11-18 00:51:34.563355 |          131 |         1 |          8 | return                              | f            |       0 | f         | f               |               0
    100 | 308978 |     1 |       1 |    1 | 2021-11-18 00:51:34.563387 | 2021-11-18 00:51:34.56353  |          143 |         1 |          8 | return                              | f            |       0 | f         | f               |               0
    100 | 308978 | 12813 |       2 |    0 | 2021-11-18 00:51:34.562313 | 2021-11-18 00:51:34.563723 |         1410 |         2 |         16 | scan   tbl=249848 name=Internal Worktable | f            |       0 | f         | f               |               0
    100 | 308978 | 12813 |       2 |    1 | 2021-11-18 00:51:34.562313 | 2021-11-18 00:51:34.563723 |         1410 |         1 |         16 | aggr   tbl=939                            | f            |       0 | f         | f               |               0
    100 | 308978 | 12813 |       3 |    0 | 2021-11-18 00:51:34.56472  | 2021-11-18 00:51:34.564783 |           63 |         1 |         16 | scan   tbl=939 name=Internal Worktable    | f            |       0 | f         | f               |               0
    100 | 308978 | 12813 |       3 |    1 | 2021-11-18 00:51:34.56472  | 2021-11-18 00:51:34.564783 |           63 |         1 |          0 | project                              | f            |       0 | f         | f               |               0
    100 | 308978 | 12813 |       3 |    2 | 2021-11-18 00:51:34.56472  | 2021-11-18 00:51:34.564783 |           63 |         1 |          0 | project                              | f            |       0 | f         | f               |               0
    100 | 308978 | 12813 |       3 |    3 | 2021-11-18 00:51:34.56472  | 2021-11-18 00:51:34.564783 |           63 |         1 |         15 | return                              | f            |       0 | f         | f               |               0
(18 rows)

Time: 2726.708 ms (00:02.727)
\q
```
