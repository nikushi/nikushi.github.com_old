---
title: "Fluentdのマルチプロセス化が簡単になったので試してみた!"
slug: fluentd-multiprocess-input-plugin
date: 2013-12-06T08:35:00+09:00
comments: true
categories: 
  - Fluentd
---

ワイワイ! [Fluentd Advent Calendar 2013](http://qiita.com/advent-calendar/2013/fluentd) 6日目担当の [@niku4i](http://twitter.com/niku4i) です。

<!--more-->

今日はFluentdのマルチプロセス化について。最近公式ページに [Multiprocess Input Plugin](http://docs.fluentd.org/articles/in_multiprocess) がドキュメント化されました。

Fluentdはシングルプロセスで動作するため、マルチコアなサーバ環境下では全コアのCPUを消費できません。Fluentd1プロセスでも小〜中規模の環境であれば十分さばけますが、大規模環境ではCPUが足りなくなります。そこでCPUを効率的に使うため、一昔前までは起動スクリプトをコア数に応じて用意しマルチプロセス化するといった手法を用いていましたが手軽にはできませんでした。

そこで最近登場したのが [@frsyuki](https://twitter.com/frsyuki) さん作の [Multiprocess Input Plugin](http://docs.fluentd.org/articles/in_multiprocess) です。ネット上に試した記事がなかったので試してみました。

Fluentdは0.10.41を使っています。gemコマンドでインストールしました。

### インストール
Fluentdのコアプラグインではないので、fluent-gemコマンドを使ってインストールします。

~~~bash
#install
$ fluent-gem install fluent-plugin-multiprocess
~~~

なお、td-agent版の場合はコマンドのパスが通っていないので以下のとおりインストールしてください。

~~~bash
#install
$ /usr/lib64/fluent/ruby/bin/fluent-gem install fluent-plugin-multiprocess
~~~

### コンフィグレーション

今回は4プロセスでそれぞれ24221〜24224/TCPでListenし受信したメッセージを標準出力に書き出す設定を作りました。書き出し部分は全プロセス共通なので `include` で1つにまとめました。非常に簡単な設定例なので面白みがないですが実際はinclude先にout系の設定を入れていくことになります。

~~~apache
#/etc/fluent/fluentd.conf
<source>
  type multiprocess

  <process>
    cmdline -c /etc/fluent/fluentd_child1.conf
    sleep_before_start 1s
    sleep_before_shutdown 5s
  </process>

  <process>
    cmdline -c /etc/fluent/fluentd_child2.conf
    sleep_before_start 1s
    sleep_before_shutdown 5s
  </process>

  <process>
    cmdline -c /etc/fluent/fluentd_child3.conf
    sleep_before_start 1s
    sleep_before_shutdown 5s
  </process>

  <process>
    cmdline -c /etc/fluent/fluentd_child4.conf
    sleep_before_start 1s
    sleep_before_shutdown 5s
  </process>

</source>
~~~

`cmdline`にマルチプロセス化した時の子プロセスに読み込ませるコンフィグファイルを指定します。このコンフィグは以下のように記述します。

~~~apache
#/etc/fluent/fluentd_child1.conf
# Receive events from TCP port
<source>
  type forward
  port 24221
</source>

# Include common configurations
include conf.d/*.conf
~~~

fluentd_child[2-4].confのコンフィグ掲載は省略しますが `port` の番号のみ変更します。

includeしたコンフィグで出力を定義しました。

~~~apache
#/etc/fluent/conf.d/match_all.conf
# Output messages to STDOUT
<match **>
  type stdout
</match>
~~~

### 起動

今回はコマンドラインから起動します。

`$ fluentd -c fluent/fluentd.conf`

[起動ログ](https://gist.github.com/niku4i/7802190)を見ると親fluentdプロセスが子fluentdを立ち上げていることが分かります。

~~~bash
#起動ログ抜粋
2013-12-05 08:45:30 +0000 [info]: launching child fluentd -c /etc/fluent/fluentd_child4.conf
~~~

netstatコマンドを使って確認しました。確かに4ポートでListenしています。
~~~sh
$ sudo netstat -anpt | grep -e ruby -e Proto
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 0.0.0.0:24221               0.0.0.0:*                   LISTEN      25160/ruby          
tcp        0      0 0.0.0.0:24222               0.0.0.0:*                   LISTEN      25143/ruby          
tcp        0      0 0.0.0.0:24223               0.0.0.0:*                   LISTEN      25126/ruby          
tcp        0      0 0.0.0.0:24224               0.0.0.0:*                   LISTEN      25108/ruby 
~~~

### 追記: -i オプションによる動的リッスンポート切替

*2013/12/19 追記*

あまり知られていないですがFluentdには`-i`という起動オプションがあり`-i`に続いてコンフィグを記述することができます。以下のようにすればinput forwardでリッスンするポートをプロセス毎に変えることができます。ポート番号などプロセス固有の設定は`-i`で渡すことで同じ設定ファイルで異なる挙動ということも実現できますね。

~~~
<source>
  type multiprocess
  <process>
    cmdline -i "<source>\ntype forward\nport 20000\n</source>" -c /etc/fluentd/fluentd.conf
    sleep_before_start 1s
    sleep_before_shutdown 1s
  </process>
  <process>
    cmdline -i "<source>\ntype forward\nport 20001\n</source>" -c /etc/fluentd/fluentd.conf
    sleep_before_start 1s
    sleep_before_shutdown 1s
  </process>
  <process>
    cmdline -i "<source>\ntype forward\nport 20002\n</source>" -c /etc/fluentd/fluentd.conf
    sleep_before_start 1s
    sleep_before_shutdown 1s
  </process>
<source>
~~~

### まとめ

Multiprocess Input Pluginにより簡単にマルチプロセス化することができました。

気になる安定性などに関して、[Fluentdのメーリングリスト上の議論](https://groups.google.com/forum/#!topic/fluentd/syXPqRAE-4w) によると 10+ billion records / day 環境下に投入しているユーザ事例もあるようです!

話はそれますが、Fluentdを使っている人やこれから使ってみようという人は [Fluentdのメーリングリスト](http://docs.fluentd.org/ja/articles/mailing-list) にjoinすることをオススメします!(自分はもっぱら読むだけ専門ですが) メールは基本英語ですが流し読みするだけでも有益な情報を拾えたり、リリース状況をタイムリーに知ることができます。また、最近では海外のエンジニアの間でも知られるようになってきており、海外でのユースケースなど知れるかもしれません。個人的には英語の勉強にもなるので両得だとおもっています。コミュニティについては@tagomorisさんの[Fluentdとはどのようなソフトウェアなのか](http://tagomoris.hatenablog.com/entry/2013/12/03/150656)の中で詳しく書かれていますね。

またFluentdの`-i`オプションを紹介しました。

簡単ではありましたが以上です。

すごい知った風でしたがgemの使い方を紹介しただけでした。最近Fluentdにふれる機会がなかったので、ユースケースを開拓してFluentdを積極的に使ってアウトプットしていきたいですね。

次は、[@yteraoka](https://twitter.com/yteraoka) さんです!
