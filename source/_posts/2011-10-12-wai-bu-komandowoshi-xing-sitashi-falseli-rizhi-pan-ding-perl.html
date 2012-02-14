---
layout: post
title: 外部コマンドを実行した時の戻り値判定(Perl)
tags:
- perl
- programming
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
perlで外部コマンドするときの話。外部コマンドの戻り値によりエラー処理させるコードの書き方。

<strong>system()</strong>
<pre lang="perl">if ( system( $command ) ) {
    warn "fail";
} else {
    print "success";
}</pre>
if ! system() ではないことに注意。
&nbsp;
<strong>`xxx` back quote</strong>
<pre lang="perl">$buffer = `$command`;
if ( $? != 0 ) { # if false
    warn "fail";
} else {
    print "success\n";
    print "buffer=$buffer";
}
$?に戻り値が入る。0以外はfalse。</pre>
&nbsp;

<strong>open()</strong>
<pre lang="perl">open(OUTPUT, ’sort >foo’)  # pipe to sort
    or die "Can’t start sort: $!";
#...                        # print stuff to output
close OUTPUT                # wait for sort to finish
    or warn $! ? "Error closing sort pipe: $!" # 純粋にcloseが失敗した場合(外部コマンドのfailではなく)
               : "Exit status $? from sort";   # 外部コマンドがnon-zeroでexitしｓた場合</pre>
外部コマンドがfailすると、close()はfalseを返す。close()するまで、外部コマンドがfailしたかはわからない。close()が実行され、外部コマンドがnon-zeroでexitすると$!に0にセットされる。
$ perldoc perlfunc に詳しく説明されています。

&nbsp;

system()かback quoteでおおむね代用できるけど、たとえばping 1.2.3.4 -c 3 (pingを3発1秒毎に打つ)をperlプログラムから外部プログラムで実行した結果を標準出力したいとき、back quoteはプログラムが終了する3秒間は出力を得られない。一方open()だと都度ストリームで出力してくれるのでイライラしなくてよい。個人的にopen()のこの使い方をする際のエラー処理をどうするかが分からず、結構調べたのでここにメモした。
<pre lang="perl">open ( IN , "ping 202.232.0.1 -c 3 |" ) or die $!;
while(){
    chomp;
    print $_ . "\n";
}
close IN;</pre>
こちらは都度出力してくれる。
<pre lang="perl">my $buffer = `ping 202.232.0.1 -c 3`;
print $buffer;</pre>
こちらは、pingが終了するまで出力を得られない。
