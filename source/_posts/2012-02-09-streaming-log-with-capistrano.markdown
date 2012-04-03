---
layout: post
title: Streaming Log with Capistrano
tags:
- Capistrano
- capistrano
- ruby
status: publish
type: post
published: true
meta:
  _edit_last: '2'
---
![tail-log-with-capistrano-image](/images/tail-log-with-capistrano-image.jpg)

複数のリモートホスト上のログファイルをtail -fして同時に流しながら見やすくする１つのアプローチとしてCapistranoを使って実現してみました。

Capistranoの標準のstreamメソッドを使うと簡単に複数ホストでのtail -fを１つにまとめて眺めることができますが、要望的に足りないところがあったので最終的にはstreamメソッドを拡張し対応しました。さらにcolorize gemモジュールを使って色をつけてみやすくしました。

以下詳細です。

<!-- more -->

## streamメソッドを使った例
まずは、Capistranoのstreamメソッドを使って試します。
カレントディレクトリにCapfileというファイル名で以下を保存してください。
``` ruby Capfile
server server1, :web
server server2, :web

desc "tail -f accees_log"
task :tail, :roles =&gt; :web do
  stream "tail -f /var/log/apache/access_log ; true"
end
```
実行
```
$ cap tail
192.168.1.1 - - [05/Feb/2012:01:46:04 +0900] "HEAD /index.html HTTP/1.1" 200 -
192.168.1.1 - - [05/Feb/2012:01:46:05 +0900] "HEAD /style.css HTTP/1.1" 200 -
192.168.1.6 - - [05/Feb/2012:01:46:07 +0900] "HEAD /index.html HTTP/1.1" 200 -
192.168.2.1 - - [05/Feb/2012:01:46:04 +0900] "HEAD /style.css HTTP/1.1" 200 -
192.168.2.1 - - [05/Feb/2012:01:47:05 +0900] "HEAD /index.html HTTP/1.1" 200 -
192.168.2.5 - - [05/Feb/2012:01:48:07 +0900] "HEAD /style.css HTTP/1.1" 200 -
```
capコマンドが見つからない場合はCapistranoがインストールされていないかもしれません。capコマンドはカレントディレクトリのCapfileという名前を探して読み込みます。引数に指定したtailタスクを実行します。
上の例では一見うまくいっていますが、複数ホストのログが単純にログがストリームされるだけなので１つのログがどのサーバのログか分かりません。微妙です。

## runメソッドにブロックを渡す方法
次に別のアプローチとしてrunメソッドを使った方法を試してみました。
runは通常以下のようにリモートホスト上で実行するコマンドを引数に書きます。
``` ruby
desc "hoge"
task :uptime do
  run "uptime"
end
```
runにはコマンドを引数に渡すだけなく、ブロックを渡して出力を加工したりできます。Capfileを以下のように修正します。<http://errtheblog.com/posts/19-streaming-capistrano>
``` ruby Capfile
desc "tail -f accees_log"
task :tail, :roles =&gt; :web do
  run "tail -f /var/log/apache/access_log ; true" do |ch, stream, out|
    puts "#{ch[:host]}: #{out}"
    break if stream == :err
  end
end
```
ブロック変数に指定したoutにリモートで実行したコマンドの標準出力がストアされます。chはセッションの情報とかが保存されるようです。
こによりログの左側にサーバ名が付加されます。
``` 
$ cap tail
server1: 192.168.1.1 - - [05/Feb/2012:01:46:04 +0900] "HEAD /index.html HTTP/1.1" 200 -
server2: 192.168.1.1 - - [05/Feb/2012:01:46:05 +0900] "HEAD /style.css HTTP/1.1" 200 -
server1: 192.168.1.6 - - [05/Feb/2012:01:46:07 +0900] "HEAD /index.html HTTP/1.1" 200 -
server1: 192.168.2.1 - - [05/Feb/2012:01:46:04 +0900] "HEAD /style.css HTTP/1.1" 200 -
server1: 192.168.2.1 - - [05/Feb/2012:01:47:05 +0900] "HEAD /index.html HTTP/1.1" 200 -
server2: 192.168.2.5 - - [05/Feb/2012:01:48:07 +0900] "HEAD /style.css HTTP/1.1" 200 -
```
しかしすぐに問題が見つかりました。tail -fの標準出力は複数行をまとめたバルクデータとしてoutにストアされるらしく、上のコードだと1行ごとには処理できません。ですので1行ごとにホスト名を先頭に付加できませんでした。

## streamメソッドを拡張
そこで、ここからはいっきに進みますが、以下のとおり標準のstreamメソッドを拡張しました。さらにcolorizeモジュールを使ってホスト名毎に色づけをして、どのサーバのログかを見やすくしてみました。

まず色をつけるためcolorizeモジュールを利用します。
```
$ gem install colorize --remote
```

inspect-stream.rbという名前で以下の内容でファイルを作成します。
``` ruby inspect-stream.rb
require 'colorize'

unless Capistrano::Configuration.respond_to?(:instance)
      abort "requires Capistrano 2"
end

module Capistrano
  class Configuration
    module Actions
      module Inspect
        # 標準のstreamメソッドを拡張する
        # 各行の先頭にホスト名を出力しつつ、ホスト名毎に色づけする
        def stream(command, options={})

          trap("INT") { puts 'Interupted'; exit 0; }

          # out の 最終行のchunk dataを一時保存するHash
          # keyはホスト名
          last = Hash.new("")
          invoke_command(command, options) do |ch, stream, out|
            a = out.split(/\n/m)

            if out[0].chr  == "\n"
              a.unshift(last[ch[:host]])
              last[ch[:host]] = ""
            else
              tmp = a.shift
              a.unshift(last[ch[:host]] + tmp)
              last[ch[:host]] = ""
            end

            if out[-1].chr == "\n"
              last[ch[:host]] = ""
            else
              last[ch[:host]] = a.pop
            end

            a.each do |line|
              puts colorize_by_host(ch[:host]) + ": " + line if stream == :out
            end
            warn "[err :: #{ch[:server]}] #{out}" if stream == :err
          end
        end

        private

        def colorize_by_host(host)
          color = [ :light_blue, :yellow, :magenta, :cyan, :light_red, :light_green, :light_yellow, :light_blue, :light_magenta, :light_cyan, :light_white ]
          host.colorize( color[str2acsii(host) % color.size] )
        end

        def str2acsii(str="")
          acsii = ""
          str.each_byte do |c|
            acsii += c.to_s
          end
          acsii.to_i
        end
      end
    end
  end
end
```
Capfileではrequireでinspect-stream.rbを読み込みます。
``` ruby Capfile
require './inspect-stream'

server server1, :web
server server2, :web

desc "tail -f accees_log"
task :tail, :roles =&gt; :web do
  stream "tail -f /var/log/apache/access_log ; true"
end
```
task側ではstreamを実行しているだけなのですっきりしました。

実行します。
``` 
$ cap tail
server1: 192.168.1.1 - - [05/Feb/2012:01:46:04 +0900] "HEAD /index.html HTTP/1.1" 200 -
server2: 192.168.1.1 - - [05/Feb/2012:01:46:05 +0900] "HEAD /style.css HTTP/1.1" 200 -
server1: 192.168.1.6 - - [05/Feb/2012:01:46:07 +0900] "HEAD /index.html HTTP/1.1" 200 -
server1: 192.168.2.1 - - [05/Feb/2012:01:46:04 +0900] "HEAD /style.css HTTP/1.1" 200 -
server1: 192.168.2.1 - - [05/Feb/2012:01:47:05 +0900] "HEAD /index.html HTTP/1.1" 200 -
server2: 192.168.2.5 - - [05/Feb/2012:01:48:07 +0900] "HEAD /style.css HTTP/1.1" 200 -
```
preタグの都合で色をつけれませんでしたが、実際にはserver1は黄色、server2は青など色付けされます

## まとめ
* Capistranoを使ってtail -f /var/log/some.log を複数ホスト上で同時実行して管理ホスト側でまとめてみることができました。
* 最終的にはstreamメソッドを定義しなおし、colorizeモジュールを使ってサーバ毎に色を変えました。

今このサーバが使われてるんだなというのが可視化できておもしろいです。色がつくだけでログ調査が数倍楽しくなりました。


ログが多すぎる場合は高速でログが流れますのであまり使えないとはおもいますが、用途によっては使いやすいかとおもいます。実際の現場ではsyslogやfluentdなどでログをログサーバに転送してログサーバで見るのが普通でしょう。この使い方は、ちょっとしたログを確認したいとき用途とか、syslogでとばせない環境だったりとかニッチなシーンでは役に立つ場合があるとおもいます。

Rubyは初心者レベルで勉強中のためやり方が間違ってるとか別のやり方があるとかあればぜひ教えてください。
