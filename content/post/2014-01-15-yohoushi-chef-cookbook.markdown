---
title: "Yohoushi Chef Cookbook作った"
slug: yohoushi-chef-cookbook
date: 2014-01-15T20:35:00+09:00
comments: true
categories: 
  - Yohoushi
tags:
  - Yohoushi
  - Chef
---

[chef-yohoushi](https://github.com/yohoushi/chef-yohoushi) を作った。YohoushiをChefでインストールするクックブック。

<!--more-->

ユーザ作成、データベースマイグレーション、Yohoushiリポジトリをgit cloneしてというところまでやってくれます。RubyのbuildとかMySQLサーバのインストールとかはクックブックの範囲外にしてて別クックブックと組み合わせて使ってください。

またサービスの再起動とかchkconfig的なところはレシピに書いてない。その辺やろうとすると諸々yack shavingになるので今時点ではインストールだけ。
