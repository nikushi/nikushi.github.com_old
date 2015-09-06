---
title: "Wordpressからoctopressに移行した"
slug: migration-from-wordpress-to-octopress
date: 2012-02-14T15:53:00+09:00
comments: true
categories: 
 - octopress
---
Wordpressからoctopressに移行した。

移行作業でいくつかつまづいて時間がかかったので、どなたかの役に立てばとメモを残す。

Wordpressは数年使っていて機能豊富でテーマも充実してるし管理画面も使いやすく、正直あまり不満はない。
でもWordpress = PHPなんだよね。PHP... 別にPHP嫌いなわけではない。今年はRubyを勉強すると決めているので、
ならば周りのツールもみんなRubyにしよー! という流れ。

さらにoctopressはgithubやherokuと連携してサーバいらずでgit pushすればブログ公開があっというまにできる仕組み。
gitやPasSに触れれてこれは一石二鳥。

以下詳細。

<!-- more -->

## 方針
 - Wordpressのデータベースから直接データはひっこぬかない
 - Wordpressの投稿データはxmlでexport
 - xmlのデータをyekyllに変換
 - 写真などのデータは移行対象外。必要に応じて手動で移行

## 手順
### Wordpressの管理画面から投稿データをxml形式でエクスポート
ツール -> エクスポート というのが標準で備わっている。Wordpressを去るのにWordpressは便利だというのは皮肉か。
タグやカテゴリ、タグのページは不要なのでエクスポート対象は"投稿"だけにする。
適当な作業ディレクトリにwordpress.xmlという名前で保存する。以下の例であればwordpress.xmlを~/tmp/migration/に保存

~~~
$ mkdir ~/tmp/migration
$ cd ~/tmp/migration
~~~

### yekyllスタイルに変換
githubのjekyllのリポジトリには[migrationツール](https://github.com/mojombo/jekyll/blob/master/lib/jekyll/migrators/wordpressdotcom.rb)が備わっている。
wordpressdotcom.rbを利用してそれなりにデータ変換ができたが以下の問題がみつかった。

- 日本語タイトルのエントリをconvertするとファイル名にURLエンコードされた文字が含まれ、octopressのpermalinkがうまく解釈されなかった
- 各記事の本文の文字コードがCR+LF。

そこでオリジナルのwordpressdoccom.rbを拝借しつつ、コードを少し修正。以下のコードを用いる。

{% gist 1824307 %}

### 修正ポイント
- permalinkを生成する箇所で一度 nkf --url-input -w して文字コードをプレーンにし、さらにto_urlメソッドで日本語をローマ字に変換する。
- 記事のデータをputsする際にもnkf -Lu -wするようにした。

to_urlメソッドはrequre 'stringex'することでStringクラスのメソッドとしてto_urlが追加される。to_urlメソッドを使うと漢字でも強制的に
ローマ字に変換する模様。octopressでrake new_postする際のコードを参考に。

では改めて変換作業を行う
~~~
$ ls
wordpress.xml wordpressdotcom.rb
$ ruby -rubygems -e 'require "./wordpressdotcom"; Jekyll::WordpressDotCom.process("wordpress.xml")'
Imported 65 posts
$ ls
_post wordpress.xml wordpressdotcom.rb
~~~
_post以下にエントリが出来上がるのでエディタで開いてざっくり問題なさそうか確認する。生成されたファイルの拡張子は.htmlになる。.markdownではない
ファイルの中身をみるとわかるが、ブログポストの本文はmarkdownではなくhtmlのまま。なので.htmlのままにする。

### ローカルテスト
変換したデータをローカルのoctopressディレクトリにコピし、記事を生成する。
~~~
$ cp _post/* /path/to/octopress/source/_post/
$ cd /path/to/octopress/source/_post/
$ rake generate
$ rake preview
~~~
rake previewするとlocalhost:4000でwebサーバが立ち上がる。内容をチェック。
ちなみにrake watchするとローカルファイルの更新を監視して逐次プレビューに反映してくれるので便利。

### deploy
~~~
$ rake deploy
~~~
rake deployを実行するとrake pushが内部で呼び出される。rake pushは内部で
- git add .
- git commit
- git push origin master
を実行するので、rake deployを実行するとコミットと公開まで自動的に実行してくれる。

git push origin masterは、origin = githubのusername/username.github.comレポジトリ に master = localの_public/ディレクトリ以下をpushする。

~~~ruby
#Rakefile
desc "deploy public directory to github pages"
multitask :push do
  puts "## Deploying branch to Github Pages "
  (Dir["#{deploy_dir}/*"]).each { |f| rm_rf(f) }
  Rake::Task[:copydot].invoke(public_dir, deploy_dir)
  puts "\n## copying #{public_dir} to #{deploy_dir}"
  cp_r "#{public_dir}/.", deploy_dir
  cd "#{deploy_dir}" do
    system "git add ."
    system "git add -u"
    puts "\n## Commiting: Site updated at #{Time.now.utc}"
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push origin #{deploy_branch} --force"
    puts "\n## Github Pages deploy complete"
  end
end
~~~


本番のブログにアップされたか確認して問題なければ完了。
