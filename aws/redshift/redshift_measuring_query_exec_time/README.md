## Redshift クエリ単体性能計測スクリプト

* Amazon Redshift でクエリの単体性能（実行時間）を計測するための bash/sql スクリプトです。
* 主な処理内容は以下の通り。
	* リザルトキャッシュを OFF に設定
	* 対象テーブルを VACUUM & ANALYZE
	* 実行時間を計測
		* クライアントサイド：\timing on
		* サーバサイド：STL_QUERY の endtime - starttime  	 	

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

* redshift_measuring_query_exec_time.sh を編集し、接続情報を設定する

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


## 実行方法

* 実行する

```bash
$ ./redshift_measuring_query_exec_time.sh
```

## 実行結果を確認する

* log ディレクトリ以下に redshift_measuring_query_exec_time_2021-10-25-025011.log  のようなファイル名でログ出力される。

```bash
$ ls -1 log/
redshift_measuring_query_exec_time_2021-10-25-044009.log
redshift_measuring_query_exec_time_2021-10-25-112542.log
redshift_measuring_query_exec_time_2021-10-25-112712.log
redshift_measuring_query_exec_time_2021-10-25-112825.log
redshift_measuring_query_exec_time_2021-10-25-210852.log
redshift_measuring_query_exec_time_2021-10-25-211001.log
redshift_measuring_query_exec_time_2021-10-25-211858.log
```

* ログの内容は以下の通り。

```bash
$ cat redshift_measuring_query_exec_time_2021-10-25-211858.log
--timing on
\timing on
Timing is on.
--pager off
\pset pager
Pager usage is off.
-- result cache off
set enable_result_cache_for_session=off;
SET
Time: 3.451 ms
-- execute target query
\i lineorder_count.sql
-- vacuum and analyze
vacuum lineorder;
VACUUM
Time: 1861.212 ms (00:01.861)
analyze lineorder;
ANALYZE SKIP
Time: 20.017 ms
select count(a.*) from lineorder a;
   count
-----------
 600037902
(1 row)

Time: 39.160 ms
-- query id
select pg_last_query_id();
 pg_last_query_id
------------------
           126141
(1 row)

Time: 3.148 ms
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
 userid | database |  label  | query  |  xid   |  pid  | exec_time(ms) |         starttime          |          endtime           | aborted | insert_pristine | concurrency_scaling_status |             query_text
--------+----------+---------+--------+--------+-------+---------------+----------------------------+----------------------------+---------+-----------------+----------------------------+-------------------------------------
    100 | dev      | default | 126141 | 433919 | 17692 |            28 | 2021-10-25 21:19:00.641828 | 2021-10-25 21:19:00.669105 |       0 |               0 |                         19 | select count(a.*) from lineorder a;
(1 row)

Time: 87.843 ms
\q
```
