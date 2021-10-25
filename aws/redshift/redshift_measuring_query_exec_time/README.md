## Redshift クエリ単体性能計測スクリプト

* Amazon Redshift でクエリの単体性能（実行時間）を計測するための bash/sql スクリプトです。

## 設定方法

* スクリプトを取得する

```bash
$ git clone https://github.com/yoheia/yoheia.git
```

* パーミッションを設定する

```bash
$ chmod u+x redshift_measuring_query_exec_time.sh
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
\timing on
Timing is on.
\pset pager
Pager usage is off.
set enable_result_cache_for_session=off;
SET
Time: 3.476 ms
\i lineorder.sql
select count(a.*) from lineorder a;
   count
-----------
 600037902
(1 row)

Time: 41.571 ms
-- query id
select pg_last_query_id();
 pg_last_query_id
------------------
            99229
(1 row)

Time: 3.232 ms
-- execution time
select userid,
        trim(database) "database",
        trim(label) as label,
        query,
        xid,
        pid,
        endtime - starttime as "exec_time",
        starttime,
        endtime,
        aborted,
        insert_pristine,
        concurrency_scaling_status,
        trim(querytxt) as query_text
        from STL_QUERY where query = pg_last_query_id();
 userid | database |  label  | query |  xid   |  pid  | exec_time |         starttime          |          endtime           | aborted | insert_pristine | concurrency_scaling_status |             query_text
--------+----------+---------+-------+--------+-------+-----------+----------------------------+----------------------------+---------+-----------------+----------------------------+-------------------------------------
    100 | dev      | default | 99229 | 370892 | 11676 | 28465     | 2021-10-25 02:46:35.426428 | 2021-10-25 02:46:35.454893 |       0 |               0 |                         19 | select count(a.*) from lineorder a;
(1 row)

Time: 5621.525 ms (00:05.622)
\q

```

