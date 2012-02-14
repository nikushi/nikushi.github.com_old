---
layout: post
title: Perl::条件演算子
tags:
- perl
- 未分類
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
条件演算子を覚えた。
<pre lang="perl">#my $a = "abc\n";
my $a = "";
print test( $a );

sub test {
    my $t = shift;
    return $t ? $t : "no data\n";
}</pre>
条件式 ? 条件式が真の時 : 偽の時

上の例だと、$aに値があれば$aを、undefなら"no data¥n"を返す。
