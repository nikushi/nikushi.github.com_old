---
layout: post
title: "carton exec plackupしたらCan't locate lib/core/only.pmで落ちた話"
date: 2013-02-23 13:09
comments: true
categories: 
  - 'Perl'
tags:
  - 'Carton'
  - 'Plack'
  - 'Perl'
---

以下のエラーに悩まされたメモです。

    $ carton -Ilib exec plackup
    Watching ./lib app.psgi for file updates.
    HTTP::Server::PSGI: Accepting connections at http://0:5000/
    # ここでブラウザでアクセスすると
    Can't locate lib/core/only.pm in @INC (@INC contains: \
    /Library/Perl/5.12/darwin-thread-multi-2level /Library/Perl/5.12 \
    /Network/Library/Perl/5.12/darwin-thread-multi-2level \
    /Network/Library/Perl/5.12 /Library/Perl/Updates/5.12.4 \
    /System/Library/Perl/5.12/darwin-thread-multi-2level \
    /System/Library/Perl/5.12 \
    /System/Library/Perl/Extras/5.12/darwin-thread-multi-2level \
    /System/Library/Perl/Extras/5.12 .).

perlbrewで使っているPerlのバージョンは 5.1.16 ですが、上のエラーではシステムグローバルな5.12のパスを参照しようとしています。よくわかりませんがこういう動作なのでしょうか。lib::core::only は local::lib に含まれるのでroot権限で local:lib をインストールすれば解決しそう。なお、プロジェクトディレクトリの Makefile.PL には local::lib は記述していません。

    $ sudo su -               # 他にいいやり方ある..?
    # which perl 
      => /usr/bin/perl
    # perl -v|grep ^This
      => This is perl 5, version 12, subversion 4 (v5.12.4) built for darwin-thread-multi-2level
    # perl -MCPAN -e shell
    cpan> install local::lib

carton exec 後のエラーが解決しました。
