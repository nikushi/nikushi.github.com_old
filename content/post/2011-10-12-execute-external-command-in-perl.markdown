---
date: 2011-10-12T00:00:00+09:00
slug: execute-external-command-in-perl
title: 外部コマンドを実行した時の戻り値判定(Perl)
tags:
- perl
- programming
status: publish
published: true
meta:
  _edit_last: '1'
---
perlで外部コマンドするときの話。外部コマンドの戻り値によりエラー処理させるコードの書き方。

### system()

~~~perl
if ( system( $command ) ) {
    warn "fail";
} else {
    print "success";
}
~~~

`if ! system()` ではない。

### back quote

~~~perl
$buffer = `$command`;
if ( $? != 0 ) { # if false
    warn "fail";
} else {
    print "success\n";
    print "buffer=$buffer";
}
~~~

`$?`に戻り値が入る。0以外はfalse

### open()

~~~perl
open(OUTPUT, ’sort >foo’) or die "Can’t start sort: $!";
close OUTPUT   # wait for sort to finish
    or warn $! ? "Error closing sort pipe: $!" # 純粋にcloseが失敗した場合(外部コマンドのfailではなく)
               : "Exit status $? from sort";   # 外部コマンドがnon-zeroでexitした場合
~~~

外部コマンドの実行が何らかの理由で失敗すると、close()は偽を返す。close()するまで、外部コマンドがfailしたかはわからない。close()が実行され、外部コマンドがnon-zeroでexitすると$!に0にセットされる。

併せて`perldoc perlfunc`を参照するといい。

では、`ping 1.2.3.4 -c 3`(pingを3発1秒毎に打つ)をperlプログラムから外部プログラムで実行した結果を標準出力したいとき、back quoteを使うとプログラムが終了する3秒間は出力を得られない。

~~~perl
my $buffer = `ping 202.232.0.1 -c 3`;
print $buffer;
~~~

一方`open()`だと都度ストリームで出力してくれる。

~~~perl
open ( IN , "ping 202.232.0.1 -c 3 |" ) or die $!;
while(){
    chomp;
    print $_ . "\n";
}
close IN;
~~~
