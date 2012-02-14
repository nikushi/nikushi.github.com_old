---
layout: post
title: ! '[Perl] colored logging by log4perl'
tags:
- Log::Log4perl
- logging
- perl
- programming
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
Log::Log4perlモジュールはロギングのための高機能なAPIを提供してくれて便利。log4perlにはtrace, debug, info, warn, error, fatalというログレベルが標準で用意してくれるけど、普通にlog4perlの設定を書くと味気ない色なしの出力なので、これを色づけする方法のメモ。

&nbsp;

warnだったら黄色、fatalだったら赤、infoは緑といった感じで色づけされると幸せ。
<pre>log4perl.category = DEBUG, Screen
log4perl.appender.Screen = Log::Log4perl::Appender::ScreenColoredLevels</pre>

たったこれだけです。loglevelに応じて標準出力を色付けしてくれます。
