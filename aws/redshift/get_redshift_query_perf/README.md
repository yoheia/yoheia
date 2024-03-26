# クエリIDを指定して Amazon Redshift からクエリの性能情報を取得スクリプト

### 事前設定

* `~/.pgpass` で Amazon Redshift のパスワードを設定する。

```
#hostname:port:database:username:password
redshift-cluster-poc.********.ap-northeast-1.redshift.amazonaws.com:5439:dev:awsuser:Password123!
```

* `get_redshift_query_perf.sh` に接続情報を設定する

```
PG_HOST=${PG_HOST:-redshift-cluster-poc-central.ceyg6jv96hfq.ap-northeast-1.redshift.amazonaws.com}
PG_USER=${PG_USER:-awsuser}
PG_DB=${PG_DB:-dev}
PG_PORT=${PG_PORT:-5439}
```

### 実行方法

* 実行手順

```
# クエリIDを環境変数にセット
$ export QUERY_ID=25848324
# スクリプトを実行
$ ./get_redshift_query_perf.sh 
```

* 性能情報を取得した結果は log ディレクトリ以下に出力される。
    * `get_redshift_query_perf_<Timestamp>_<Query ID>.log` というファイル名で出力される。

```
$ ls -1 log/
get_redshift_query_perf_2024-03-26-075444_25848324.log
get_redshift_query_perf_2024-03-26-075544_25848324.log
get_redshift_query_perf_2024-03-26-075702_25848324.log
get_redshift_query_perf_2024-03-26-075732_25848324.log
get_redshift_query_perf_2024-03-26-080056_25848324.log
```
