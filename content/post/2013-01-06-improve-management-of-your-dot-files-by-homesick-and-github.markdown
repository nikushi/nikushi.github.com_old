---
title: "homesickとgithubでドットファイルを管理する"
slug: improve-management-of-your-dot-files-by-homesick-and-github
date: 2013-01-06T23:42:00+09:00
comments: true
categories: 
tags:
  - "Mac"
  - "Linux"
  - "dotfiles"
  - "github"
---

正月に時間があったのでドットファイルを[homesick](https://github.com/technicalpickles/homesick 'homesick')を使ってgithubで管理するようにした。

<!-- more -->

動機としては、昨年転職してから会社PCがMacになり家と会社のMacで設定が微妙に異なることがあり煩わしいので揃えてしまおうとおもったためです。

github上に置いたドットファイルをマスタとして扱い、各PCにリポジトリを`git clone`してシンボリックリンクを張れば済みます。

しかしながら、`ln`コマンドで1ファイルづつリンク作るのもPC台数が複数あると面倒くさく怠慢により機能しなくなることが予想されます。 [Github dotfiles](http://dotfiles.github.com/) にはdotfilesの管理にまつわる先人の知恵が紹介されていましたので、この中からカジュアルそうなツールで [homesick](https://github.com/technicalpickles/homesick) を導入しました。他にも事例はあるので自分の好みにあう方法を探すのもよいでしょう。


### dotfiles ###

github上に`dotfiles`という名前で専用リポジトリを作りましょう。名前は何でもいいです。
なお、homesickの特性上、github上のリポジトリルートに`home`ディレクトリを作成して`home`ディレクトリ以下にドットファイルを置く必要がありました。
参考までに(参考にならないですが) [私のリポジトリ](https://github.com/niku4i/dotfiles) です。

### homesick ###

gemコマンドでインストールできます。

    $ gem install homesick

github上のdotfilesリポジトリをhomesickに登録します。`~/.homesick/`以下に`git clone`されます。

    $ homesick clone git@github.com:niku4i/dotfiles.git

登録したリポジトリのドットファイルを`~/`以下に適用。

    $ homesick symlink dotfiles

既にローカルPC上に同じドットファイルがある場合、上書く前にy/nで訪ねられますのでご安心を。

現在homesickに登録されたリポジトリ一覧を確認

    $ homesick list
    dotfiles  git@github.com:niku4i/dotfiles.git

githubのリポジトリをpull(ローカルのドットファイルが更新される)

    $ homesick pull dotfiles

細かい使い方は`homesick help`を参照してください。

`homesick clone`では複数のリポジトリを登録できるので、Github Enterpriseを導入しているような会社であれば会社用のドットファイルリポジトリ、全PC共通のドットファイルはgithub.comに、といった使い方もできて便利だとおもいました。
