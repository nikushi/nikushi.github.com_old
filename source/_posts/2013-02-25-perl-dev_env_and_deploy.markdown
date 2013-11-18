---
layout: post
title: "Perl環境構築作りのチート"
date: 2013-02-25 09:30
comments: true
categories: 
  - 'Perl'
---

ステージや本番での環境構築まわりについて調べてみた。

<!--more-->

調べたかったことはこのスライドにまとまっていた。[モダンかもしれないPerlウェブアプリケーション開発入門 - Nigata.pm teck talk#1](http://www.slideshare.net/ImaiHayato/niigatapm-1)

以下、自分用にメモします。


### 開発環境

    $ curl -kL http://install.perlbrew.pl | bash
    $ echo 'source ~/perl5/perlbrew/etc/bashrc' >> ~/.bash_profile
    $ source ~/.bash_profile
    $ perlbrew install perl-5.17.9
    $ perlbrew switch perl-5.17.9
    $ perlbrew install-cpanm
    $ cpanm carton
    $ cpanm proclet # 必要であれば

### デプロイ先

    $ sudo useradd -m myapp && sudo su - myapp
    # perl環境構築(略)
    myapp$ git clone url myapp
    myapp$ cd myapp
    myapp$ carton install
    myapp$ carton exec -- prove

### daemontoolsスクリプト

``` 
    #!/bin/sh
    export HOME=/home/myapp
    export PLACK_ENV=production
    cd $HOME/myappexec
    exec setuidgid myapp ./script/start.sh
```

``` 
    source $HOME/perl5/perlbrew/etc/bashrc
    carton exec -- myapp
```

