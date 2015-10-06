---
date: 2015-09-11T11:50:31+09:00
title: daemontoolsインストール後にトラブった
---

普段と違うで順でマシンをセットアップした時のこと。daemontoolsまわりたまにハマると詰んだ。メモメモ。

<!--more-->

* CentOS 6.3
* upstart経由でsvscanbootを起動させる

こういう構成

daemontoolsをrpmからインストールした後、上げたいプロセス(mysqld)が起動しなくて困った。

```
svscan: warning: unable to start supervise mysql: file does not exist
```

こういうエラーが出てる。でもためしにupstart経由せずマニュアル `$ svscan /service` で起動するとうまく起動する。$PATH確認してみたりパーミッション確認したりしたが問題なさそう。英語Q&AサイトでOS再起動したら治るよ、っていう記述があって乱暴だな...とおもったのだが。困ったときのreboot、マシンを再起動したらupstart経由でデーモン起動できた。謎...。

