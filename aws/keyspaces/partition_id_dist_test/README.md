

Readme
====================================


Getting Started
---------------


    * ファイルを分割する

    ```sh
    split -d -a 3 -l 10000 base_insert.cql  ks_insert_
    ```

    * 最初の行に CONSISTENCY LOCAL_QUORUM; を追記する
    
    ```sh
     ls ks*|while read LINE; do sed -i '1s/^/CONSISTENCY LOCAL_QUORUM;\n/' ${LINE}; done
    ```
