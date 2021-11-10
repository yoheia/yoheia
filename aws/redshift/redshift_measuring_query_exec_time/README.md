## Redshift クエリ単体性能計測スクリプト

* Amazon Redshift でクエリの単体性能（実行時間）を計測するための bash/sql スクリプトです。
* 主な処理内容は以下の通り。
	* リザルトキャッシュを OFF に設定
	* 対象テーブルを VACUUM & ANALYZE
	* 実行時間を計測
		* クライアントサイド：`\timing on`
		* サーバサイド：`STL_QUERY` の `endtime` - `starttime`  
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
$ head -10 redshift_measuring_query_exec_time_2021-11-09-040401_env_info.log
{
    "Clusters": [
        {
            "PubliclyAccessible": false,
            "MasterUsername": "awsuser",
            "VpcSecurityGroups": [
                {
                    "Status": "active",
                    "VpcSecurityGroupId": "sg-086f4a6e"
                }
$ tail -20 redshift_measuring_query_exec_time_2021-11-09-040401_env_info.log
set enable_result_cache_for_session=off;
SET
Time: 3.585 ms
-- show Redshift version
select version();
                                                          version
---------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 8.0.2 on i686-pc-linux-gnu, compiled by GCC gcc (GCC) 3.4.2 20041017 (Red Hat 3.4.2-6.fc3), Redshift 1.0.31651
(1 row)

Time: 3.558 ms
-- show table stats
select * from svv_table_info;
 database | schema | table_id |   table   |     encoded     | diststyle  |   sortkey1    | max_varchar | sortkey1_enc | sortkey_num | size  | pct_used | empty | unsorted | stats_off | tbl_rows  | skew_sortkey1 | skew_rows | estimated_visible_rows | risk_event | vacuum_sort_benefit
----------+--------+----------+-----------+-----------------+------------+---------------+-------------+--------------+-------------+-------+----------+-------+----------+-----------+-----------+---------------+-----------+------------------------+------------+---------------------
 dev      | public |   128384 | lineorder | Y, AUTO(ENCODE) | AUTO(EVEN) | AUTO(SORTKEY) |          15 |              |           0 | 25082 |   6.9314 |     0 |          |      0.00 | 600037902 |               |           |              600037888 |            |
(1 row)

Time: 668.956 ms
\q
```

* `redshift_measuring_query_exec_time_YYYY-MM-DD-HHMMSS_query_perf.log` ログの内容は以下の通り。
 * vacuum & analyze 後に、対象クエリを実行し、`STL_QUERY` からクエリの実行時間を取得している。
 * リザルトキャッシュは OFF で計測している。

```bash
$ cat redshift_measuring_query_exec_time_2021-11-09-040401_query_perf.log
--timing on
\timing on
Timing is on.
--pager off
\pset pager
Pager usage is off.
-- result cache off
set enable_result_cache_for_session=off;
SET
Time: 3.457 ms
-- execute target query
\i lineorder_count.sql
-- vacuum and analyze
vacuum lineorder;
VACUUM
Time: 2110.643 ms (00:02.111)
analyze lineorder;
ANALYZE SKIP
Time: 21.832 ms
select count(a.*) from lineorder a;
   count
-----------
 600037902
(1 row)

Time: 151.328 ms
-- query id
select pg_last_query_id();
 pg_last_query_id
------------------
              845
(1 row)

Time: 3.339 ms
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
        from STL_QUERY where query = pg_last_query_id();
 userid | database |  label  | query |   xid   |  pid  | exec_time(ms) |         starttime          |          endtime           | aborted | insert_pristine | concurrency_scaling_status |             query_text
--------+----------+---------+-------+---------+-------+---------------+----------------------------+----------------------------+---------+-----------------+----------------------------+-------------------------------------
    100 | dev      | default |   845 | 1470649 | 19334 |           135 | 2021-11-09 04:04:05.326059 | 2021-11-09 04:04:05.461166 |       0 |               0 |                       19 | select count(a.*) from lineorder a;
(1 row)

Time: 357.846 ms
\q
```
