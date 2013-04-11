---
layout: post
title: "MySQL チートシート"
date: 2013-04-07 13:04
comments: true
categories: 
  - 'MySQL'
tags:
  - 'MySQL'
---

### 起動

    # mysqld_safe --user=_mysql &

### 停止

    # mysqladmin -uroot shutdown

### 接続

#### 接続
testデータベースへ接続
    $ mysql test

#### ユーザ名指指定
hogeユーザ権限でtestデータベースへ接続。-pではパスワード指定しない

    $ mysql -u hoge -p test
    Password: 

#### リモートのMySQLサーバへ接続

    $ mysql -u hoge -p --host=192.168.1.1 --port=1000 test

#### ソケットファイルを使って接続

    $ mysql --socket=/tmp/ownsocket_file test

### データベース選択

    $ mysql
    > USE test

### ページャを設定
SELECT文等で出力が大量の場合、ページャを用いる

    > pager less

ページャをオフにする場合

    > nopager

### ヘルプの表示
mysqlコマンドが持つコマンド群と使い方の説明を表示。SQL文用の説明ではない。SQL文ではないので末尾に;は不要。

    > help


### テーブル作成
aテーブルをcというフィールド付きで作成

    > CREATE TABLE a (c CHAR(100));

複数のフィールドを指定してテーブルを作成

    > CREATE TABLE t1 ( id INT, dep INT, name CHAR(30) );

### テーブル作成(ストレージエンジンの指定)

    > CREATE TABLE t2 ( id INT, dep INT, name CHAR(30) ) ENGINE=InnoDB;

### テーブル作成(キャラクタセットの指定)

    > CREATE TABLE t3 ( id INT, dep INT, name CHAR(30) ) CHARACTER SET utf8;

### テーブルのリネーム

    > ALTER TABLE old_table RENAME TO new_table;

### テーブル定義の確認
SHOW CREATE TABLE文を使用して、ストレージエンジン、テーブル、フィールドキャラクタセット等確認できる。

    > SHOW CREATE TABLE t1;

### データベースの情報確認
SHOW TABLE STATUS文を使うと、データベースに存在するすべてのテーブルの情報を確認可能。LIKE 'テーブル名'を使うと特定テーブルに限定可能。

テーブルaの詳細情報を縦型出力で出力

    > SHOW TABLE STATUS LIKE 'a'\G
    *************************** 1. row ***************************
               Name: a
             Engine: InnoDB
            Version: 10
         Row_format: Compact
               Rows: 19
     Avg_row_length: 862
        Data_length: 16384
    Max_data_length: 0
       Index_length: 0
          Data_free: 0
     Auto_increment: NULL
        Create_time: 2013-04-07 13:41:36
        Update_time: NULL
         Check_time: NULL
          Collation: latin1_swedish_ci
           Checksum: NULL
     Create_options:
            Comment:
    1 row in set (0.00 sec)

version 5.0以上では、information_schema.TABLES テーブルから情報参照も可能

    > SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA='test' AND TABLE_NAME='t1'\G
    *************************** 1. row ***************************
      TABLE_CATALOG: def
       TABLE_SCHEMA: test
         TABLE_NAME: t1
         TABLE_TYPE: BASE TABLE
             ENGINE: InnoDB
            VERSION: 10
         ROW_FORMAT: Compact
         TABLE_ROWS: 1
     AVG_ROW_LENGTH: 16384
        DATA_LENGTH: 16384
    MAX_DATA_LENGTH: 0
       INDEX_LENGTH: 0
          DATA_FREE: 0
     AUTO_INCREMENT: NULL
        CREATE_TIME: 2013-04-07 14:10:03
        UPDATE_TIME: NULL
         CHECK_TIME: NULL
    TABLE_COLLATION: latin1_swedish_ci
           CHECKSUM: NULL
     CREATE_OPTIONS:
      TABLE_COMMENT:
    1 row in set (0.00 sec)

### テーブルのフィールドの構造確認
SHOW文またはDESC文を使う

    mysql> DESC t1;
    +-------+----------+------+-----+---------+-------+
    | Field | Type     | Null | Key | Default | Extra |
    +-------+----------+------+-----+---------+-------+
    | id    | int(11)  | YES  |     | NULL    |       |
    | dep   | int(11)  | YES  |     | NULL    |       |
    | name  | char(30) | YES  |     | NULL    |       |
    +-------+----------+------+-----+---------+-------+
    3 rows in set (0.01 sec)

    > DESC t1;
    +-------+----------+------+-----+---------+-------+
    | Field | Type     | Null | Key | Default | Extra |
    +-------+----------+------+-----+---------+-------+
    | id    | int(11)  | YES  |     | NULL    |       |
    | dep   | int(11)  | YES  |     | NULL    |       |
    | name  | char(30) | YES  |     | NULL    |       |
    +-------+----------+------+-----+---------+-------+
    3 rows in set (0.01 sec)


version 5.0以上ならばinformation_schema.COLUMNSテーブルを参照することで同等のことが可能


### テーブル一覧を確認

    > SHOW TABLES

### 複数のフィールドに値をセットしたレコードを挿入

    > INSERT INTO a(c,d) VALUES ('123abc','246ace')

### フィールドの追加
テーブルaにdというCHAR(100)のフィールドをフィールド最後に追加。COLUMNは省略可能

    > ALTER TABLE a ADD COLUMN d CHAR(100);
    or
    > ALTER TABLE a ADD d CHAR(100);

フィールドを指定した位置に追加。FIRSTなら先頭、AFTERは指定したフィールドの次に追加。BEFOREは無い。

    > ALTER TABLE a ADD COLUMN b CHAR(50) FIRST;
    > ALTER TABLE a ADD COLUMN f CHAR(50) AFTER e;

### フィールドの削除

    > ALTER TABLE a DROP COLUMN f;

### フィールドの変更
名前や型を変更できる。下の例はeフィールドをe2にリネームしつつ、型をCHAR(50)に変換。

    > ALTER TABLE a CHANGE COLUMN e e2 CHAR(50);

### フィールド型の変換

    > ALTER TABLE a MODIFY e2 CHAR(100);

### ストレージエンジンの変更
テーブルのストレージエンジンを変更する

    > ALTER TABLE a ENGINE=MyISAM;

### テーブルの破棄

    > DROP TABLE a;

### レコード追加

フィールドの値セットしてレコード追加。指定されなかったフィールドにはデフォルト値が入る。

    > INSERT INTO a (c) VALUES ('123abc');

複数フィールドの値セットしてレコード追加。指定されなかったフィールドにはデフォルト値が入る。

    > INSERT INTO a (b,c) VALUES ('1', '2');

最初の()を省略すると VALUESの()はすべてのフィールドの値が含まれることが期待される。個数が足りない場合はエラーになる。

    > INSERT INTO a VALUES (1,'2','3','4');

### データの検索
テーブルaのすべてのレコードを表示

    > SELECT * FROM a;

### 特定フィールドに限定した検索
テーブルaのc,dフィールドのレコードを表示

    > SELECT c,d FROM a;

### レコードの縦表示
フィールド数が多くて横1行に収まらなく見づらい場合。1レコード毎に縦表示させる。;の代わりに\Gを末尾にする。

    > SELECT c,d FROM a\G

結果

    > SELECT c,d FROM a\G
    *************************** 1. row ***************************
    c: 123abc
    d: NULL
    *************************** 2. row ***************************
    c: 123abc
    d: NULL
    2 rows in set (0.00 sec)

### 特定値を含むレコードの抽出

    > CREATE TABLE a ( id INT, name CHAR(50), age INT );
    Query OK, 0 rows affected (0.02 sec)

    > INSERT INTO a VALUES (1, 'John', 30);
    > INSERT INTO a VALUES (2, 'Smith', 24);
    > INSERT INTO a VALUES (3, 'Alice', 18);
    > DESC a;
    +-------+----------+------+-----+---------+-------+
    | Field | Type     | Null | Key | Default | Extra |
    +-------+----------+------+-----+---------+-------+
    | id    | int(11)  | YES  |     | NULL    |       |
    | name  | char(50) | YES  |     | NULL    |       |
    | age   | int(11)  | YES  |     | NULL    |       |
    +-------+----------+------+-----+---------+-------+
    3 rows in set (0.01 sec)

名前がJohn

    > SELECT * FROM a WHERE name = 'John';
    +------+------+------+
    | id   | name | age  |
    +------+------+------+
    |    1 | John |   30 |
    +------+------+------+
    1 row in set (0.00 sec)

名前がJohn以外

    mysql> SELECT * FROM a WHERE name != 'John';
    +------+-------+------+
    | id   | name  | age  |
    +------+-------+------+
    |    2 | Smith |   24 |
    |    3 | Alice |   18 |
    +------+-------+------+
    2 rows in set (0.00 sec)


年齢が20より上

    > SELECT * FROM a WHERE age > 20;
    +------+-------+------+
    | id   | name  | age  |
    +------+-------+------+
    |    1 | John  |   30 |
    |    2 | Smith |   24 |
    +------+-------+------+
    2 rows in set (0.00 sec)

名前がAから始まる人(パターン検索)

%は0文字以上の任意の文字列の意味

    > SELECT * FROM a WHERE name LIKE 'A%';
    +------+-------+------+
    | id   | name  | age  |
    +------+-------+------+
    |    3 | Alice |   18 |
    +------+-------+------+
    1 row in set (0.00 sec)

AND

    > SELECT * FROM a WHERE id <= 2 AND age > 25;
    +------+------+------+
    | id   | name | age  |
    +------+------+------+
    |    1 | John |   30 |
    +------+------+------+
    1 row in set (0.00 sec)

OR 


    > SELECT * FROM a WHERE age > 25 OR name LIKE 'A%';
    +------+-------+------+
    | id   | name  | age  |
    +------+-------+------+
    |    1 | John  |   30 |
    |    3 | Alice |   18 |
    +------+-------+------+
    2 rows in set (0.00 sec)

IN

    > SELECT * FROM a WHERE name IN ( 'Alice', 'John' );
    +------+-------+------+
    | id   | name  | age  |
    +------+-------+------+
    |    1 | John  |   30 |
    |    3 | Alice |   18 |
    +------+-------+------+
    2 rows in set (0.00 sec)

### SELECT結果のソート

    > INSERT INTO a VALUES (0, 'Bob', 65);
    Query OK, 1 row affected (0.01 sec)

昇順

    > SELECT * FROM a ORDER BY id;
    +------+-------+------+
    | id   | name  | age  |
    +------+-------+------+
    |    0 | Bob   |   65 |
    |    1 | John  |   30 |
    |    2 | Smith |   24 |
    |    3 | Alice |   18 |
    +------+-------+------+
    4 rows in set (0.00 sec)

降順


    > SELECT * FROM a ORDER BY id DESC;
    +------+-------+------+
    | id   | name  | age  |
    +------+-------+------+
    |    3 | Alice |   18 |
    |    2 | Smith |   24 |
    |    1 | John  |   30 |
    |    0 | Bob   |   65 |
    +------+-------+------+
    4 rows in set (0.00 sec)

ソート基準のフィールドを複数指定

    > SELECT * FROM a ORDER BY id, name;


### データの更新

UPDATEを使う。key=value[, key=value] で複数指定もできる。

    > UPDATE  a SET note="hello";
    Query OK, 5 rows affected (0.00 sec)
    Rows matched: 5  Changed: 5  Warnings: 0

    > SELECT * FROM a;
    +------+-----------+------+-------+
    | id   | name      | age  | note  |
    +------+-----------+------+-------+
    |    1 | John      |   30 | hello |
    |    2 | Smith     |   24 | hello |
    |    3 | Alice     |   18 | hello |
    |    0 | Bob       |   65 | hello |
    |    5 | Christian |   65 | hello |
    +------+-----------+------+-------+
    5 rows in set (0.00 sec)

特定レコードの特定フィールドを更新するにはWHERE句を使う。

    > UPDATE  a SET age=19 WHERE name='Alice';

### テーブルからすべてのレコードを削除

テーブルからすべてのレコードを削除する。テーブルは削除されない

    > DELETE FROM b;

### テーブルから特定のレコードを削除

特定のレコードだけを削除したい場合はWHERE句を使う

    DELETE  FROM b WHERE age > 10;

### リダイレクト(SQLを記述したファイルを実行)

    $ cat sql.txt
    SELECT * FROM a;
    $ mysql test < sql.txt

    c       d       e
    123abc  NULL    NULL
    123abc  NULL    NULL
    NULL    1       NULL
    a       1       NULL
    a       1       NULL

    $

上の例では枠線は表示されない。枠線を表示したい場合は-tを使う

    $ mysql -t test < sql.txt
    +--------+------+------+
    | c      | d    | e    |
    +--------+------+------+
    | 123abc | NULL | NULL |
    | 123abc | NULL | NULL |
    | NULL   | 1    | NULL |
    | a      | 1    | NULL |
    | a      | 1    |      |
    +--------+------+------+

### リダイレクト(実行結果をファイルに出力)
'>'上書き、'>>'追記

    $ mysql test > out
    SELECT * FROM a;
    quit
    $
    $ cat out
    c       d       e
    123abc  NULL    NULL
    123abc  NULL    NULL
    NULL    1       NULL
    a       1       NULL
    a       1       NULL

### リダイレクト(< と > を同時に使う)
SQL文をファイルから読み込み実行。実行結果をファイルに保存

    $ cat sql.txt
    SELECT c FROM a;
    $ mysql test < sql.txt > out
    $
    $ cat out |head
    c
    123abc
    123abc
    NULL
    a
    a
    a
    a
    a
    a

### パイプ
パイプを使ってSQL文を実行できる

    $ echo 'SELECT * FROM a' | mysql test | head
    c       d       e
    123abc  NULL    NULL
    123abc  NULL    NULL
    NULL    1       NULL
    a       1       NULL
    a       1       NULL
    a       1       NULL
    a       1       NULL
    a       1       NULL
    a       1       NULL

### データベースの作成
testという名前のデータベースを作成

    $ mysqladmin -uroot -p create test

もしくはSQL文を使う

    > CREATE DATABASE test;

キャラクタセットを指定しデータベースを作成する

    > CREATE DATABASE test DEFAULT CHARACTER SET utf8;

### データベースの削除
testという名前のデータベースを削除

    $ mysqladmin -uroot -p drop test

もしくはSQL文を使う

    > DROP DATABASE test;

### データベース作成時のクエリを確認

    > SHOW CREATE DATABASE test;

