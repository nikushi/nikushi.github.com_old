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
<a href="http://orihubon.com/wp-content/uploads/tail-log-with-capistrano-image.jpg"><img class="size-medium wp-image-309" title="tail-log-with-capistrano-image" src="http://orihubon.com/wp-content/uploads/tail-log-with-capistrano-image-300x133.jpg" alt="tail-log-with-capistrano-image" width="300" height="133" /></a>

複数のリモートホスト上のログファイルをtail -fして同時に流しながら見やすくする１つのアプローチとしてCapistranoを使って実現してみました。

Capistranoの標準のstreamメソッドを使うと簡単に複数ホストでのtail -fを１つにまとめて眺めることができますが、要望的に足りないところがあったので最終的にはstreamメソッドを拡張し対応しました。さらにcolorize gemモジュールを使って色をつけてみやすくしました。

まずは、Capistranoのstreamメソッドを使って試します。
<h1><strong>streamメソッドを使った例</strong></h1>
カレントディレクトリにCapfileというファイル名で以下を保存してください。
<pre lang="ruby">server server1, :web
server server2, :web

desc "tail -f accees_log"
task :tail, :roles =&gt; :web do
  stream "tail -f /var/log/apache/access_log ; true"
end</pre>
<h4>実行</h4>
<pre lang="shell">$ cap tail</pre>
capコマンドはCapistranoがインストールされていればあるとおもいます。capコマンドはカレントディレクトリのCapfileという名前を探して読み込みます。引数に指定したtailタスクを実行します。

出力をみると分かりますが、単純にログがストリームされるだけなので、１つのログがどのサーバのログか分かりません。微妙です。

次に別のアプローチとしてrunメソッドを使った方法を試してみました。
<h1><strong>runメソッドにブロックを渡す方法</strong></h1>
runは通常
<pre lang="ruby">desc "hoge"
task :uptime do
  run "uptime"
end</pre>
みたいにリモートでコマンドを実行する際に使いますが、ブロックを渡して出力を編集したりできます。Capfileを以下のように修正します。参考 : <a href=" http://errtheblog.com/posts/19-streaming-capistrano">Err the Blog</a>
<pre lang="ruby">desc "tail -f accees_log"
task :tail, :roles =&gt; :web do
  run "tail -f /var/log/apache/access_log ; true" do |ch, stream, out|
    puts "#{ch[:host]}: #{out}"
    break if stream == :err
  end
end</pre>
ブロック変数に指定したoutにリモートで実行したコマンドの標準出力がストアされます。chはセッションの情報とかが保存されるようです。

こによりログの左側にサーバ名が付加されます。

しかしすぐに問題が見つかりました。tail -fの標準出力は複数行をまとめたバルクデータとしてoutにストアされるらしく、上のコードだと1行ごとには処理できません。ですので1行ごとにホスト名を先頭に付加できませんでした。
<h1><strong>streamメソッドを拡張</strong></h1>
そこで、ここからはいっきに進みますが、以下のとおり標準のstreamメソッドを拡張しました。さらにcolorizeモジュールを使ってホスト名毎に色づけをして、どのサーバのログかを見やすくしてみました。

inspect-stream.rbという名前で以下の内容でファイルを作成します。
<pre lang="ruby">require 'colorize'

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
end</pre>
さらにCapfileを以下の内容に書き換えます。
<pre lang="ruby">require './inspect-stream'

server server1, :web
server server2, :web

desc "tail -f accees_log"
task :tail, :roles =&gt; :web do
  stream "tail -f /var/log/apache/access_log ; true"
end</pre>
<h4>colorizeモジュールはあらかじめインストールしてください</h4>
<pre lang="shell">$ gem install colorize --remote</pre>
<h4>実行</h4>
<pre lang="shell">$ cap tail</pre>
<h4>結果</h4>
<span style="color: #ff0000;">server1</span>: 192.168.1.1 - - [05/Feb/2012:01:46:04 +0900] "HEAD /index.html HTTP/1.1" 200 -
<span style="color: #339966;">server2</span>: 192.168.1.1 - - [05/Feb/2012:01:46:05 +0900] "HEAD /style.css HTTP/1.1" 200 -
<span style="color: #ff0000;">server1</span>: 192.168.1.6 - - [05/Feb/2012:01:46:07 +0900] "HEAD /index.html HTTP/1.1" 200 -
<span style="color: #ff0000;">server1</span>: 192.168.2.1 - - [05/Feb/2012:01:46:04 +0900] "HEAD /style.css HTTP/1.1" 200 -
<span style="color: #ff0000;">server1</span>: 192.168.2.1 - - [05/Feb/2012:01:47:05 +0900] "HEAD /index.html HTTP/1.1" 200 -
<span style="color: #339966;">server2</span>: 192.168.2.5 - - [05/Feb/2012:01:48:07 +0900] "HEAD /style.css HTTP/1.1" 200 -

ログの最初が色づけされてだけですが結構眺めてると楽しめます。

streamメソッド自体を拡張したのでCapfile自体は元々最初にやろうとしてた内容とほぼ同じになりすっきりしました。ホストごとに色が異なるので、どのホストがログが多めかが何となく視覚的に分かるようになりました。ログが多すぎると目がちかちかしてあまり効果は無いかもしれません(爆)

Capistranoモジュールのソースにinspect.rbというのが含まれておりstreamメソッドを定義しなおして上書きしてます。Capistrano 2系で動作確認しました。

Rubyはまだ勉強中のためやり方が間違ってるとか別のやり方があるとかあればぜひ教えてください。

&nbsp;

ここまで書いてなんですが、実際の現場ではsyslogやfluentdなどでログをログサーバに転送してログサーバで見るのが普通でしょう。この使い方は、ちょっとしたログを確認したいとき用途とか、syslogでとばせない環境だったりとか向きかもしれません。

&nbsp;

今回おまけでログに色をつけましたが、色がつくだけでログ調査が数倍楽しくなりました。
