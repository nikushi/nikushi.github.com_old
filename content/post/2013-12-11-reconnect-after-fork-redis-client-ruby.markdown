---
title: "Redisクライアントでforkするときは子プロセスでrecoonectする"
slug: reconnect-after-fork-redis-client-ruby
date: 2013-12-11T16:24:00+09:00
comments: true
categories: 
  - Redis
---

Redisクライアントインスタンスを親プロセスで作った後、forkし子プロセス側でGETとSETしても大丈夫だっけ? とおもったのでRubyの[redis-rb](https://github.com/redis/redis-rb)で実験しました。結論としてはfork後に子プロセス側でクローズして再確立すれば良いです。

<!-- more -->

以下のケースは動かない。
~~~ruby
require 'redis'

redis = Redis.new
redis.get 'a'       # 親プロセスがRedisサーバとコネクション確立

fork do
  redis.get 'a'     # 子プロセスがgetしようとすると...
end
~~~

例外が発生。子プロセスからコネクションを利用しようとしたので怒られる。
    => ..snip.. redis/client.rb:285:in `ensure_connected': Tried to use a connection from a child process without reconnecting. You need to reconnect to Redis after forking. (Redis::InheritedError)

fork後にreconnectするように言われるのでそのとおりします。以下はOKです。

~~~ruby
#works!
require 'redis'

redis = Redis.new
redis.get 'a'

fork do
  redis.client.reconnect
  redis.get 'a'
end
~~~

上のコードではTCPを使うのでtcpdumpでパケットを確認してみたところ、子は自分用のTCPコネクションを確立することを確認しました。

昔々Cでforkしてsocket read/writeするプログラムを書いたのを思い出しました。forkした後に複数プロセスで同じソケットを使ってはいけないので片方はクローズする、であってますかね。以上です!
