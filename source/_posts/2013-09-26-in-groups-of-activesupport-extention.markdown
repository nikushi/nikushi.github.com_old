---
layout: post
title: "ActiveSupportのin_groups_ofメソッドでビューが捗る!"
date: 2013-09-26 19:21
comments: true
categories: 
  - Rails
tags:
  - Rails
  - Ruby
---
ActiveSupportの`inc_groups_of`メソッドを使ってみたらビューが捗った。

<!--more-->

Arrayクラス拡張であるin_groups_ofメソッドとin_groupsメソッドを使うと簡単に配列をグルーピング化することができます。


例えば、以下の配列データ
``` ruby
%w(1, 2, 3, 4, 5, 6, 7, 8)
```

in_groups_ofメソッドをつけて呼び出すと引数指定の数の要素数の小配列をメンバにした配列を返してくれます。また第2引数で空部分に埋める要素指定もできます。デフォルトはnilです。falseを与えるとnilの代わりに要素数を切り詰めます。

``` ruby
irb> %w(1 2 3 4 5 6 7 8).in_groups_of(2)
=> [["1", "2"], ["3", "4"], ["5", "6"], ["7", "8"]]

irb> %w(1 2 3 4 5 6 7 8).in_groups_of(5)
=> [["1", "2", "3", "4", "5"], ["6", "7", "8", nil, nil]]

irb> %w(1 2 3 4 5 6 7 8).in_groups_of(5, 'none')
=> [["1", "2", "3", "4", "5"], ["6", "7", "8", "none", "none"]]

irb> %w(1 2 3 4 5 6 7 8).in_groups_of(5, false)
=> [["1", "2", "3", "4", "5"], ["6", "7", "8"]]
```

使うシーンとしては、ビュー上で指定個数毎でグルーピングして表示したいときに便利です。

``` html
<div id="group0">
  <ul>
    <li>1</li>
    <li>2</li>
    <li>3</li>
  </ul>
</div>
<div id="group1">
  <ul>
    <li>4</li>
    <li>5</li>
    <li>6</li>
  </ul>
</div>
<div id="group2">
  <ul>
    <li>7</li>
    <li>8</li>
    <li>9</li>
  </ul>
</div>
```

似たような名前でin_groupsというメソッドもあります。こちらは配列を指定グループ数に分割してくれるメソッドです。

``` ruby
irb> %w(1 2 3 4 5 6 7 8).in_groups(2)
=> [["1", "2", "3", "4"], ["5", "6", "7", "8"]]

irb> %w(1 2 3 4 5 6 7 8).in_groups(3)
=> [["1", "2", "3"], ["4", "5", "6"], ["7", "8", nil]]

irb> %w(1 2 3 4 5 6 7 8).in_groups(5)
=> [["1", "2"], ["3", "4"], ["5", "6"], ["7", nil], ["8", nil]]

irb> %w(1 2 3 4 5 6 7 8).in_groups(5, "none")
=> [["1", "2"], ["3", "4"], ["5", "6"], ["7", "none"], ["8", "none"]]

irb> %w(1 2 3 4 5 6 7 8).in_groups(5, false)
=> [["1", "2"], ["3", "4"], ["5", "6"], ["7"], ["8"]]
```

普段Railsやってる人には当たり前かもしれない内容でした。いざ使いたかったときにメソッド名を忘れていたので、以上、自分メモでした!

他にもActiveSupportの拡張は便利なものがあるので[Active Support Core Extensions](http://edgeguides.rubyonrails.org/active_support_core_extensions.html)の一読おすすめです!
