---
layout: post
title: "RubyでIPアドレスの正規表現を超簡単に書く"
date: 2013-08-06 09:14
comments: true
categories: 
  - 'Ruby'
---

正規表現自前で書かずとも、`Resolv::IPv4::Regex`を使う。

<!--more-->

```
require 'resolv'
Resolv::IPv4::Regex.class     
=> Regexp
```

IPv6の場合は、`Resolv::IPv6::Regex`を使いましょう。

