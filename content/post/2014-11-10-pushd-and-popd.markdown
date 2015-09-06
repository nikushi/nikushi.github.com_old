---
title: "pushd and popd"
slug: pushd-and-popd
date: 2014-11-10T22:42:00+09:00
comments: true
categories: 
  - Linux
---

pushd と popd を使い始めた。

<!--more-->

ほんとうに今更感があるが。学生の時に知っていつの間にか使わなくなり、社会人数年目で再度使うようにして使わなくなってしまった歴史が個人的にある。

使わなくなってしまった理由はタイプ数だと考えているので、タイプ数を少なくすべく以下のようにした。Dan Kogai氏の[tips - 君はpushd|popdを知っているか?](http://blog.livedoor.jp/dankogai/archives/51527066.html)を参考にさせていただいた。

~~~bash
#~/.bashrc
function mycd {
  if [ -n "$1" ]; then
    pushd $1
  else
    pushd ~/
  fi
}
alias cd=mycd
alias po='popd'
alias  p='popd'
~~~

`cd` で別ディレクトリに移動すると同時にカレントディレクトリが保存され `p` で元のディレクトリに戻る。`mycd` 経由なのは `pushd` 引数無しでも `~/` に帰れるようにするため。

今のところいい感じ。しかしこういう小さい改善系はすぐ忘れてしまって残念な感じになるので、小さなネタでもブログに書いておこう。
