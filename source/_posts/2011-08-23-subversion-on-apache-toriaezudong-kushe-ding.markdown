---
layout: post
title: subversion on apache とりあえず動く設定
tags:
- apache
- linux
- subversion
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
仕事でsubversion使うかもしれないので、勉強かねてhttpでsvnしてみた。最低限の設定なので認証などはつけてない。

mod_dav_svnが必要なのでyum installする。
<pre lang="shell">
 $ sudo yum install mod_dav_svn.x86_64
</pre>

svn関連のapache設定。CentOSの流儀に従って /etc/conf.d/svn.conf とした。
<pre lang="apache">
<IfModule !mod_dav_svn.c>
    LoadModule dav_svn_module modules/mod_dav_svn.so
</IfModule>
<Location /svn>
    DAV svn
    SVNParentPath /var/svn
    SVNListParentPath on
</Location>
</pre>

リポジトリが1個だけならくSVNPathを使えばよい。
SVNParentPathを使うと、配下のディレクトリにある複数のリポジトリを対象としてくれるので設定ファイルを毎度書き換えなくて良い利点がある。

複数のリポジトリで構成すると/var/svn以下は以下のようになる。
<pre>
  /var/svn/
    + repos1/
       + trunk/
       + branches/
       + tags/
    + repos2/
       + (略)
</pre>

ここで一つ不便を感じる点として、ブラウザでhttp://xxx/svn/にアクセスするとSVNモジュールがエラーページを吐く。GETリクエストを解釈できないためであるが、URI的にはリポジトリのlistを出力してほしいところだ。
そこで、SVNListParentPath on だ。これだけ。
