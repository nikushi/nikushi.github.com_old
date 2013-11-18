---
layout: post
title: "スロークエリをMySQL再起動せずオンラインで調査する"
date: 2013-11-05 10:11
comments: true
categories: 
  - MySQL
---
スロークエリをログに吐く方法。設定ファイル修正する必要はなかった。

<!--more-->

```
mysql> set global slow_query_log = 1;
mysql> set global slow_query_log_file = '/tmp/slowquery.log';
mysql> set global long_query_time = 0; # 0秒にセットすると全queryをロギング
```
調査が終わったら`slow_query_log = 0`にするのを忘れないように。本番環境とかでやるとログがぶくぶく太るのでやらないほうが良いでしょう。

ログの解析はmysqldumpslowコマンドで。
```
mysqldumpslow /tmp/slowquery.log
```

なお、コネクションプーリングしている場合は新規コネクションから有効になるようです。アプリを再起動しないと反映されないです。mysqlコマンドから設定した場合も`show variables like 'long_query_time';`やっても値が反映されていないように見えますが、再接続すると確認できました。

