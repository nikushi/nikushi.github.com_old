---
title: "RubyでIPアドレスの正規表現を超簡単に書く"
slug: regex-for-ipv-address
date: 2013-08-06T09:14:00+09:00
comments: true
categories: 
  - 'Ruby'
---

正規表現自前で書かずとも、`Resolv::IPv4::Regex`を使う。

<!--more-->

~~~
require 'resolv'
Resolv::IPv4::Regex.class     
=> Regexp
~~~

IPv6の場合は、`Resolv::IPv6::Regex`を使いましょう。

