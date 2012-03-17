---
layout: post
title: "OctopressのソースリポジトリをDropboxに変更"
date: 2012-03-18 05:32
comments: true
categories: 
  - Octopress
tags:
  - Octopress
---

### octopressのソースファイルの管理
[Deploying to Github Pages](http://octopress.org/docs/deploying/github/)の手順でgithub pagesを使うと、localのworking copyにはsourceというブランチが生成される。この環境でblogの記事を書くときは以下のワークフローをになってるとおもう。

1. ```rake new_post['hoge']```で記事を作成
1. ```rake deploy```で記事を公開
1. ```git push```にてlocalhostのsourceブランチ -> github pagesのsourceブランチemote backup。 

```rake deploy```するとgithubのmasterブランチにpublicディレクトリのみuploadされるのはよいが、```git push```にてsourceファイルも公開している。
 
個人的にはソースファイルは公開しなくてよいかなと考えた。
そこで、sourceブランチはgithub上にはpushするのではなく、 Dropbox上にリポジトリを作成し管理することにする。


### リポジトリ作成
    mkdir -p ~/Dropbox/repos/ni-blog.git        
    cd ~/Dropbox/repos/ni-blog.git              
    git --bare init                           

### リモートリポジトリの追加
リモートリポジトリの確認
現在のremoteのripositoryはoctopressとoriginの2種類。
    $ cd path/to/octopress
    $ git remote -v                     
    octopress       git://github.com/imathis/octopress.git (fetc
    octopress       git://github.com/imathis/octopress.git (push
    origin  git@github.com:niku4i/niku4i.github.com.git (fetch) 
    origin  git@github.com:niku4i/niku4i.github.com.git (push)  
~/Dropbox/repos/ni-blog.gitをdropboxという名前で登録
    git remote add dropbox ~/Dropbox/repos/ni-blog.git
確認
    $ git remote -v                          
    dropbox /Users/nikushi/Dropbox/repos/ni-blog.git (fetch)       
    dropbox /Users/nikushi/Dropbox/repos/ni-blog.git (push)        
    octopress       git://github.com/imathis/octopress.git (fetch) 
    octopress       git://github.com/imathis/octopress.git (push)  
    origin  git@github.com:niku4i/niku4i.github.com.git (fetch)    
    origin  git@github.com:niku4i/niku4i.github.com.git (push)     
dropboxが追加されました。

### Dropboxのリポジトリにソースファイルをpushする
まずbareで作成したDropboxのリポジトリにpush。-uを指定することで以降```git push```(引数なし)で実行可能になる。
    $ git push -u dropbox source                   
    Counting objects: 4110, done.                                        
    Delta compression using up to 4 threads.                             
    Compressing objects: 100% (1598/1598), done.                         
    Writing objects: 100% (4110/4110), 2.73 MiB, done.                   
    Total 4110 (delta 2307), reused 3836 (delta 2197)                    
    To /Users/nikushi/Dropbox/repos/ni-blog.git                          
     * [new branch]      source -> source                                
     Branch source set up to track remote branch source from dropbox.     
以後```git push```を実行するとDropboxのリポジトリにバックアップされる。

本当にバックアップされたか確認する。```git clone```する際には-bでsourceブランチを指定する必要がある。
    mkdir ~/tmp/ && cd ~/tmp/
    git clone -b source ~/Dropbox/repos/ni-blog.git
    cd ni-blog
    ls

rake deployにてgithubに記事をアップロード、git pushにてDropboxにバックアップするワークフローに変更できた。しばらくこれで運用してみる。
