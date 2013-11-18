---
layout: post
title: "ISUCON3予選の記録"
date: 2013-10-07 10:38
comments: true
categories: 
  - ISUCON
---

[ISUCON3](http://isucon.net/archives/29328289.html)予選に参加しました。


チームは会社の同僚の[@sonots](https://twitter.com/sonots)さん、[@Spring_MT](https://twitter.com/Spring_MT)さん3名(チーム Miami)、予選は10/5(土), 10/6(日)に分かれていて僕たちは2日目に参加しました。

<!--more-->

長時間の作業になるので会社で作業しました。僕は朝から興奮してしまって1時間前に会場入りして素振りしてましたが。


#### お題アプリ

githubのgistの機能ライクなメモアプリでした。

#### 最終的な構成

nginx + unicorn + MySQL + InnoDB memcached plugin

#### 午前 - スタート

##### 10:00
まず、インスタンスによってCPUのモデルに差異があるかもしれないのでメンバ3人それぞれインスタンスを作成しCPUのモデルを確認しましたが結局偏りはありませんでした。

##### 10:30
僕はwebappをgithub.comにgit pushしたり、予め用意しておいたカーネルチューニング(とってもネットワーク周りを少しだけ)をしてました。

##### 11:00
my.cnf書き換えてslow query logを出すように修正。最初にベンチ走らせてスコアが800ほど。あまり大きなslow queryはありませんでした。

##### 10:20
他の2名がリードしてくれてる状況なので、僕何からやろうかなという状態。とりあえずもう一度ドキュメント読んで注意点を確認しました。`--workload`これは重要なのでチームに周知しときました:) 他のチームでこれ忘れてる人結構ありましたね。

また、[rack-mini-profiler](http://miniprofiler.com/)を導入して遅いページを探しました。これ便利ですね。

変更点

* nginx導入。public_htmlをnginxで返すよう変更
* memo POST時にgem_markdown呼び出してmarkdownからHTMLに変換。表示時に都度HTMLコンバートするのをやめた
* N+1問題。`memos`テーブルだけで完結するようにするため、`memos`テーブルに`username`フィールドを追加することにした。
* 複合インデックスを入れてパフォーマンス改善

```
create index user_create_at_index on memos (user, created_at);
create index user_is_private_created_at_index on memos (user, is_private, created_at);
```

クエリの改善系は僕も対応しました。1つ、2つ改善できてホッとしました。

##### 13:30
コンビニ飯

#### 午後 - 伸び悩み

クエリを改善し、nginx + unicornの構成にしスコアは上がりましたが、午後はこの後どうしようか悩む時間でした。

前回isucon2ではVarnishを入れることで劇的にスコアアップできた事例がありましたので、Varnish対応を始めましたがVarnish作戦は結局失敗でした。recentページがキャッシュしにくい(olderとnewerのリンク)構成であったという点...と認識しています。あとセッションのバリデーションでベンチがコケたみたい。(このへんは僕やってないからもやっとしてる)

より詳細なプロファイリングのためNewRelicも入れてプロファイリング(by Spring_MTさん)。トップページとrecentが70ms程度かかっている状況で以下のクエリがある以上この程度かかるのかな....

```
SELECT id, first_sentence, username, created_at FROM memos WHERE is_private=0 ORDER BY id DESC LIMIT 100 OFFSET #{page * 100}
```

indexは効かせていたのでこのSELECTやめて別のアプローチをとればスコアアップ狙える、逆にいうとこれ改善しないと上位には入れないよね、というのがチームの午後の課題でしたが最後まで答えを出せずじまいで終わってしまいました。

その他改善したところは以下です。

* markdown生成のためフォークやめて[redcarpet](https://github.com/vmg/redcarpet)使った。でも+500くらい
* 毎回memoのcontentを`.split(/\r?\n/)`せず、`memos.first_sentence`フィールドを作ってmemo POST時に入れるようにした
* メモ数をカウントする`SELECT count(*) FROM memos`をmemdにキャッシュした
* sonotsスペシャル => 詳細はsonots blogで


最後はログ吐くのをやめてプロファイリングも切って`--workload=4`くらいにして測定して終了。

### 反省点とか所感

* memcachedみたいなものには気づかなかった...
* 8時間かっとなってコード釘付けになりがちですが、30分くらいはコーヒー飲みながらメンバでディスカッションしてもよかったかも
* githubにwebappを上げてpull req方式でコード改修しようとして、実機でコード変えて即ベンチ走らせたい場合もあってmasterがconflictしてしまった。どっちもどっちで難しい。他のチームどうやってるか気になる。

ちなみに、自分は普段高負荷環境のWebサービスを運用,開発してる訳ではなくて、Railsで管理系アプリ書いたり監視系ツール作ったりしてる系。始まる前は自分どれだけ対応できるか不安でした。周りのエンジニアや参加者も凄い人たちばかりですし。でも終わってみると参加してよかったです。しんどかったけど。反省会のビールがうまかったです。
