---
layout: post
title: manファイルを直接読む方法
tags:
- linux
- man
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
manpathが取っていないmanファイルを読む方法。

<pre lang="shell">
$ nroff -man pdsh.1 | less
</pre>

よく忘れるのでメモ。

manpathコマンドを実行するとmanのパスが通っているディレクトリを知ることができる
<pre>
$ manpath
/opt/local/man/ja:/opt/local/man:/usr/share/man:/usr/local/share/man:/usr/X11/man
</pre>
