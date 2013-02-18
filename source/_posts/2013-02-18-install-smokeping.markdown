---
layout: post
title: "SmokePingをインストールしてみた"
date: 2013-02-18 16:41
comments: true
categories: 
  - 'Server'
tags:
  - 'smokeping'
  - 'Perl'
---
SmokePingをインストールしたメモ。

SmokePingの概要は以下のとおりです。
- 監視対象を登録するとsmokepingデーモンが対象に対して定期的にpingポーリング
- 監視対象ホストのネットワークレイテンシ可視化
- pingロスリストの可視化
- 閾値監視、通知
- ping以外にcurlでHTTPのレスポンス可視化、とかもできます

インストールしたときの超手抜きメモ。詳しくは公式ページを見てね。

### 1. RRDTool

    yum install rrdtool rrdtool-devel rrdtoo-perl   
 
### 2. fping

sourceからインストールしました。fpingをroot権限で実行させるためsetuidしました。

    mkdir ~/src/ ; cd ~/src/
    wget http://oss.oetiker.ch/smokeping/pub/fping-2.4b2_to4-ipv6.tar.gz
    tar zxvf fping-2.4b2_to4-ipv6.tar.gz
    cd fping-2.4b2_to4-ipv6
    ./configure --prefix=/usr/local/smokeping
    make
    su -
    make install
    chmod u+s /usr/local/sbin/fping

### 3. Perl Modules
公式に書いてあるCPANモジュールをcpanでインストールします。optionalなモジュールは必要ないので入れてません。

    # perl -MCPAIN -e shell
    cpan> install FCGI CGI CGI::Fast Config::Grammar LWP

### 4. SmokePingのインストール

こちらもソースからインストールします。

    cd ~/src
    wget http://oss.oetiker.ch/smokeping/pub/smokeping-2.6.8.tar.gz
    tar zxvf smokeping-2.6.8.tar.gz
    cd smokeping-2.6.8
    ./configure --prefix=/usr/local/smokeping
    /usr/bin/gmake install
    mkdir -p /usr/local/smokeping/cache
    mkdir -p /usr/local/smokeping/data
    mkdir -p /usr/local/smokeping/var
    mkdir /usr/local/smokeping/var/log
    chown -R smokeping:smokeping /usr/local/smokeping
    chmod -R g+rw /usr/local/smokeping/cache
    chmod 600 /usr/local/smokeping/etc/smokeping_secrets.dist

smokepingユーザを作ります。

    useradd smokeping
    usermod -G smokeping apache

### 5. SmokePingのコンフィグ

`etc/config.dist`を`etc/smokeping.conf`にリネームしてサンプルを参考に設定する。

### 6. 起動
pingを定期実行するsmokepingデーモンを上げます。

ためしに起動する

    su - smokeping -m -c /usr/local/smokeping/bin/smokeping --config=/usr/local/smokeping/etc/smokeping.conf --debug

問題なければinitスクリプトから起動する。initスクリプトは適当に作ったのを[gist](https://gist.github.com/niku4i/4975644)に上げました。


### 7. apacheの設定

以下を`/etc/httpd/conf.d/smokeping.conf`に。

{% gist 4976007 %}

cgi用に以下を作った

{% gist 4976014 %}

### その他

コンフィグの構文チェック

    smokeping --check --config=/path/to/config

デバッグモード実行

    smokeping --config=/path/to/config --debug

### 所感

Apacheが必要な点や、CPANモジュール入れたり結構インストールの手間がかかる。
alert機能を使える点は良いとおもうが最近だとGrowthForecastとかで可視化できるから、可視化だけならSmokePing使うほどでもないというのが正直な感想。
