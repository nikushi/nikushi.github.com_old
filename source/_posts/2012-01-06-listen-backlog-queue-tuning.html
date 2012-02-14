---
layout: post
title: Listen Backlog Queue Tuning
tags:
- kernel
- linux
- sysctl
- tcp
- tcp/ip
status: private
type: post
published: false
meta:
  _edit_last: '1'
---
とあるdaemonが動作するサーバでたまにトラフィックが落ち込む事象があり、調べてみるとSYNセグメントを取りこぼす事象が起きていた。さらに調べてみるとどうもlisten backlogの値が小さいことが分かったのでメモ。

サーバがSYNパケットを受け取るとTCPのlisten backlog queue に格納しaccept()されるまでキューイングする。ソケットはLISTENからSYN_RCVDに遷移しますがbacklog queue以上をためることはできないので、SYNパケットが瞬間的にバーストしたりするとSYNパケットを取りこぼしちゃう。

listen backlog queue sizeはlisten()システムコールを実行するときに指定できるみたい。
<pre lang="c">$ man 2 listen
SYNOPSIS
  #include 

  int listen(int sockfd, int backlog);</pre>

さてそこでdaemonのソースコードを確認してみた。しかし、listenの第2引数には10000以上の大きな値が設定されているようで、この数を越えるリクエストがあるとは到底思えない。

もう一度manを見なおした。
<pre lang="shell">$ man 2 listen
BUGS
  If the socket is of type AF_INET, and the backlog argument is greater than the constant SOMAXCONN (128 in Linux 2.0 &amp; 2.2), it is silently truncated to SOMAXCONN.</pre>
listen()で指定したback log queue sizeがsomaxconnより大きい場合、somaxconnの値に切りつめられる、ということ。これはBUGなんだろうか。

確認してみると確かに小さい。
<pre lang="shell">$ cat /proc/sys/net/core/somaxconn
 128</pre>
値を増やして様子を見ることにした。

ネット上の情報を探してみると今回のdaemonに限らずapacheはmemcachedなどlisten()するのは基本的にこれにはまる可能性があるみたい。
<pre lang="shell">
 # sysctl -w net.core.somaxconn=1024
 net.core.somaxconn = 1024
 $ /sbin/sysctl -n net.core.somaxconn
 1024</pre>
他に確認するところとしては、somaxconnとは少し違うが、net.ipv4.tcp_max_syn_backlog の値とかも確認するとよさそう。


サーバのbacklog queueにどのくらい溜まっているかは SYN_RCVDを数えればいい(間違ってたら指摘ください)
<pre lang=shell>
$ netstat -an |grep SYN_RCVD | wc -l
15</pre>

TCPは奥が深く、楽しい。勉強になった。
