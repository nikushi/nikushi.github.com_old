---
layout: post
title: "SmokePingをPlack + Perlbrew + Alien::RRDtoolで動かす"
date: 2015-04-19 11:45
comments: true
categories: 
  - SmokePing
---

SmokePingをApache+CGIではなくPlackだけで動かしてみた。

<!--more-->

以前書いた[SmokePingをインストールしてみた](http://orihubon.com/blog/2013/02/18/install-smokeping/)という記事ではシステムPerl + Apache CGI + yumからrrdtool, rrdtoo-perlをインストールする方法でやったが、今回は違う方針で入れてみた。

やりたいこと

* システムPerlではなくperlbrewで入れたperlを使う
* PlackでApache無しでWeb画面を立ち上げる

なお、RRDToolをシステムのパッケージシステムからインストールしPerlで使おうとするとCentOSの場合、rrdtoolとrrdtool-perlを入れることになる。rrdtool-perlを使うにはシステムPerlを使わなければならず、今回やりたいperlbrew perlを使えない。そこでAlien::RRDtoolを使ってrrdtoolをbuildすることでRRDToolをperlbrew perlで使えるようになる。Alien::RRDtoolは@gfxさんの[Alien::RRDtool - RRDtoolをCPANから入れる](http://perl-users.jp/articles/advent-calendar/2011/hacker/2)が大変参考になる。

Plack化するためCGI::Emulate::PSGIを使う。

以下CentOS6での作業

#### RRDToolのbuildに必要なパッケージを入れる

```
# yum install cairo cairo-devel pango pango-devel libxml2-devel bitmap-console-fonts vlgothic-fonts vlgothic-fonts-common
```

#### PerlbrewでSmokePing用Perlをbuildする

perlbrewの`--as`オプションを使ってperlを名前付きでインストールする。今回の作業で必須ではないが、perlのバージョンを上げたいときに普通にインストールするとshebangのパスを書き換えないといけないが、`--as`オプションを付けると変えなくて済むので便利。

まずsmokepingユーザを作成する

```
# groupadd smokeping
# useradd smokeping -g smokeping
# su - smokeping
```

続いてperlbrewをsmokepingユーザ環境化に入れる

```
$ \curl -L http://install.perlbrew.pl | bash
$ echo 'source $HOME/perl5/perlbrew/etc/bashrc' >> ~/.bashrc
$ source ~/.bashrc
```

build
```
$ perl_version=5.20.2
$ perl_name=smokeping
$ perlbrew install $perl_version --as $perl_name  -j 4 -v 
   => ~/perl5/perlbrew/perls/$perl_name にperlがインストールされる
```

#### SmokePingのsourceをダウンロード

次のcpanmの工程で必要なので、まずsourceをダウンロードしておく

```
$ wget http://oss.oetiker.ch/smokeping/pub/smokeping-2.6.11.tar.gz
$ tar zxf smokeping-2.6.11.tar.gz
$ cd smokeping-2.6.11
```

#### CPANモジュールインストール

SmokePingが依存するCPANモジュール、 Alien::RRDtool、Plack関連モジュールをインストールする

まず、perlbrew perlを使ってまずcpanmを入れる

```
$ perlbrew use $perl_name
$ curl -L https://cpanmin.us | perl - App::cpanminus
```

続いてcpanmを使ってperlbrew perl以下にCPANモジュールをインストール

```
$ cpanm Alien::RRDtool CGI::Emulate::PSGI Plack `cat PERL_MODULES`
```

PERL_MODULESはSmokePingのsourceに含まれているファイルでインストールすべきモジュールリストが定義されているのでここでインストールしておく。


#### SmokePingをインストール

SmokePingを普通に./configure -> make -> make installするとシステムPerlを使おうとするので一工夫が必要で、configure時に`PERL`環境変数で使うperlを指定することが出来る。また`--enable-pkgonly`オプションを指定することでSmokePingのインストーラ自身がCPANモジュールをインストールするのを止めている。

```
$ PERL=/home/smokeping/perl5/perlbrew/perls/smokeping/bin/perl ./configure --prefix=/usr/local/SmokePing --enable-pkgonly
$ make 
$ sudo /usr/bin/gmake install
$ sudo chown -R smokeping:smokeping /usr/local/SmokePing
```

本当にperlbrew perlを使ってるかshebangを確認してみる

```
$ head -1  /usr/local/SmokePing/bin/smokeping
#!/home/smokeping/perl5/perlbrew/perls/smokeping/bin/perl
```

#### plackupする

準備は整ったのでsmokepinユーザでplackupしてみる。なお今回は/smokepingをSmokePingのrootにした。

まず、SmokePingの設定ファイルのうち以下の項目の修正が必要。

```
imgcache = /usr/local/SmokePing/cache
imgurl   = /smokeping/cache
cgiurl   = http://localhost:5000/smokeping/  # URLは適宜読み替えてください
```

以下のapp.psgiを/usr/local/Smokeping/に置く。

```perl
use warnings;
use strict;

use Plack::Builder;
use CGI::Emulate::PSGI;
use CGI qw();

use Smokeping;

my $smokeping = sub {
    CGI::initialize_globals();
    my $q = CGI->new;
    # 適宜configは作成してください
    Smokeping::cgi("/usr/local/Smokeping/etc/config", $q);
};
$smokeping  = CGI::Emulate::PSGI->handler( $smokeping );

builder {
    use Plack::App::File;
    mount "/smokeping/cache" => Plack::App::File->new(root => './cache')->to_app;
    mount "/smokeping/cropper" => Plack::App::File->new(root => './htdocs/cropper')->to_app;
    mount "/smokeping" => $smokeping;
};
```

/cacheと/cropperはそれぞれ画像ファイルとjsファイルの参照のため。


plackup

```
$ cd /usr/local/SmokePing
$ plackup
```

http://localhost:5000/smokeping でweb画面が見れます!!!

あとはpingプロセスを立ち上げる。これもsmokepingユーザで動かす。別途fping等インストールしておく。

```
$ /usr/local/SmokePing/bin/smokeping
```

#### まとめ

何がいいの? システムPerl使いたくない人向け。また管理画面なのでCGIでも十分ではあるけどApache立てずに動かしたい人には便利。

