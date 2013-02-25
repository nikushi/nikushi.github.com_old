---
layout: post
title: "モダンなPerl環境構築作りのチート"
date: 2013-02-25 09:30
comments: true
categories: 
  - 'Perl'
---

ステージや本番でどうデプロイするのか調べてみた。

調べたかったことはこのスライドにまとまっています!素晴らしい。
(モダンかもしれないPerlウェブアプリケーション開発入門 - Nigata.pm teck talk#1)[http://www.slideshare.net/ImaiHayato/niigatapm-1]

自分用にメモします。

### 開発環境

    $ curl -kL http://install.perlbrew.pl | bash
    $ echo 'source ~/perl5/perlbrew/etc/bashrc' >> ~/.bash_profile
    $ source ~/.bash_profile
    $ perlbrew install perl-5.17.9
    $ perlbrew switch perl-5.17.9
    $ perlbrew install-cpanm
    $ cpanm carton
    $ cpanm proclet # お好みで

### デプロイ先

    $ sudo useradd -m myapp && sudo su - myapp
    # perl環境構築(略)
    myapp$ git clone url myapp
    myapp$ cd myapp
    myapp$ carton install
    myapp$ carton exec -- prove

### daemontoolsスクリプト

``` daemontools script
    #!/bin/sh
    export HOME=/home/myapp
    cd $HOME/myappexec
    setuidgid myapp ./script/start.sh
```

``` script/start.sh
    source $HOME/perl5/perlbrew/etc/bashrc
    carton exec -- myapp
```


