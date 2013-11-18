---
layout: post
title: "XCode 4.3とoctopress"
date: 2012-03-15 01:57
comments: true
categories: 
 - 'octopress'
tags:
 - 'octopress'
 - 'xcode'
---
[前回の記事](/blog/2012/03/15/install-rvm-and-ruby193-and-192-on-llvm-gcc-and-xcode431/)でXCode4.3.1環境でrvmを使ってRuby1.9.2をbuildしたので、その話をoctopressで書こうとおもい```rake new_post['hoge']```したら```bundle install```しろと怒られたので実行してみたら途中で止まってしまいはまった。

<!-- more -->

初めはXCodeまわりを疑ったが最終的にはoctopressのディレクトリのGemfileを修正して対応。

```
$ cd path/to/octopress/
$ bundle install
Fetching gem metadata from http://rubygems.org/.......
Using rake (0.9.2)
Using RedCloth (4.2.8)
Using posix-spawn (0.3.6)
Using albino (1.3.3)
Using blankslate (2.1.2.4)
Using chunky_png (1.2.1)
Using fast-stemmer (1.0.0)
Using classifier (1.3.3)
Using fssm (0.2.7)
Using sass (3.1.5)
Using compass (0.11.5)
Using directory_watcher (1.4.0)
Using ffi (1.0.9)
Using haml (3.1.2)
Using kramdown (0.13.3)
Using liquid (2.2.2)
Using syntax (1.0.0)
Using maruku (0.6.0)
Using jekyll (0.11.0)
Using rubypython (0.5.1)
Using pygments.rb (0.1.3)
Using rack (1.3.2)
Installing rb-fsevent (0.4.3.1) with native extensions Unfortunately, a fatal error has occurred. Please report this error to the Bundler issue tracker at https://github.com/carlhuda/bundler/issues so that we can fix it. Thanks!
/Users/nikushi/.rvm/rubies/ruby-1.9.2-p318/lib/ruby/site_ruby/1.9.1/rubygems/installer.rb:552:in `rescue in block in build_extensions': ERROR: Failed to build gem native extension. (Gem::Installer::ExtensionBuildError)

        /Users/nikushi/.rvm/rubies/ruby-1.9.2-p318/bin/ruby extconf.rb
        creating Makefile
        CFLAGS='-isysroot /Applications/Xcode.app/Contents/Developer/SDKs/MacOSX10.7.sdk -mmacosx-version-min=10.7 -mdynamic-no-pic -std=gnu99 -Os -pipe -Wmissing-prototypes -Wreturn-type -Wmissing-braces -Wparentheses -Wswitch -Wunused-function -Wunused-label -Wunused-parameter -Wunused-variable -Wunused-value -Wuninitialized -Wunknown-pragmas -Wshadow -Wfour-char-constants -Wsign-compare -Wnewline-eof -Wconversion -Wshorten-64-to-32 -Wglobal-constructors -pedantic' /usr/bin/clang -isysroot /Applications/Xcode.app/Contents/Developer/SDKs/MacOSX10.7.sdk -mmacosx-version-min=10.7 -mdynamic-no-pic -std=gnu99 -dead_strip -framework CoreServices -o '/Users/nikushi/.rvm/gems/ruby-1.9.2-p318/gems/rb-fsevent-0.4.3.1/bin/fsevent_watch' fsevent/fsevent_watch.c
        fsevent/fsevent_watch.c:1:10: fatal error: 'stdio.h' file not found
#include <stdio.h>
                 ^
                 1 error generated.
                 extconf.rb:59:in `<main>': Compilation of fsevent_watch failed (see README) (RuntimeError)

```
最初、stdio.shがfile not foundと言われて途方にくれた。XCodeをずっと疑ってたのだけど以下の記事を見つけた。

- [RVM and Xcode 4.3](http://zanshin.net/2012/02/17/rvm-and-xcode-4-dot-3/)
- ["[ruby][OSX]OS X で rb-fsevent のインストールに失敗するので pre-compiled 版に変更した"](http://d.karashi.org/20120303.html#p01)

rb-fseventが問題みたいで、オリジナルにはcommitされていないXCode4.3対応版をGemfileに指定して対応らしい。将来的には対応されるかな。

以下のようにGemfileを修正した。Gemfile.orgはオリジナルのバックアップ。-の行を+の記述に置き換える。
```
$ diff -u Gemfile.org Gemfile
--- Gemfile.org     2012-03-15 00:28:04.000000000 +0900
+++ Gemfile     2012-03-15 00:28:19.000000000 +0900
@@ -10,7 +10,7 @@
   gem 'haml', '>= 3.1'
   gem 'compass', '>= 0.11'
   gem 'rubypants'
-  gem 'rb-fsevent'
+  gem 'rb-fsevent', :git => 'git://github.com/ttilley/rb-fsevent.git', :branch => 'pre-compiled-gem-one-off'
   gem 'stringex'
   gem 'liquid', '2.2.2'
 end
```

変更後、```$ bundle install```。通った。rvmのインストールの下りからここに至るまで長かった。XCodeでどれだけの人がはまっるんだろう。
