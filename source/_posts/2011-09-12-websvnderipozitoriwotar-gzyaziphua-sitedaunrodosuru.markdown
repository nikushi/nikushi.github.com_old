---
layout: post
title: WebSvnでリポジトリをtar.gzやzip化してダウンロードする
tags:
- linux
- svn
- websvn
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
インストール時には無効になっていたが、include/config.phpを修正することで有効にできる。
<pre lang="php">
// For delivered tarballs, if option enabled...
$config->setTarPath('/bin/');

// For delivered GZIP'd files and tarballs, if option enabled...
$config->setGZipPath('/usr/bin/');

// download folder/file zipped ...
$config->setZipPath('/usr/bin/');

// You need tar and gzip installed on your system. Set the paths above if necessary
//
// Uncomment the line below to offer a tarball download option across all your
// reposi
$config->allowDownload();

// Change the line below to set the download level across all your repositories.
// 環境に合わせて調整
$config->setMinDownloadLevel(1);
</pre>


$config->setMinDownloadLevelに渡す数字はリポジトリの/を0として数える。
<pre>
 /               0
   project1/     1
     - sub/      2
   project2/     1
</pre>
