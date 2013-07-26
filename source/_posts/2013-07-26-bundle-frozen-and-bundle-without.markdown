---
layout: post
title: "BUNDLE_FROZENとかBUNDLE_WITHOUT"
date: 2013-07-26 16:37
comments: true
categories: 
  - 'Ruby'
---

bundlerに関するメモ。

### bundle install --deployment 
`--deployment`をつけ実行すると`vendor/bundle`以下にgemがインストールされます。deploymentの名の通り本番環境でインストールする場合を想定したコマンドです。

```
    $ bundle install --deployment
```

### BUNDLE_FROZEN

`--deployment`の名のとおり本番環境でインストールする場合を想定したコマンドですが、うっかり開発環境で実行してしまって少々はまってしまいました。

開発環境でGemfileに新しくgemを追加したので、`bundle install`しようとします。すると

```
$ bundle install
You are trying to install in deployment mode after changing
your Gemfile. Run `bundle install` elsewhere and add the
updated Gemfile.lock to version control.

If this is a development machine, remove the Gemfile freeze
by running `bundle install --no-deployment`.

You have added to the Gemfile:
* colorize
```

とエラーがでます。`bundle install --deployment`を1度でも実行すると`.bundle/config`が更新され`BUNDLE_FROZEN: 1`が付加されるようです。


これを解除するには、`bundle install --no-deployment`を1度実行するか、`.bundle/config`を直接編集して`BUNDLE_FROZEN: 1`の行を削除してしまうかする必要があります。


### BUNDLE_WITHOUT

`--without`というオプションがあります。以下のように使います。本番環境ではdevelopmentやtestグループのgemは不要なのでwithoutでinstall対象から除外することができます。

```
  $ bundle install --deployment --without development test
```

ただ、これも`--without`つきで実行すると`.bundle/config`に保存されてしまいます。

```
---
BUNDLE_WITHOUT: development test
```

うっかり開発環境で実行してしまうと、その後、`bundle exec rspec`などやろうとすると以下のエラーが発生します。rspec-coreはGemに含まれませんと。

```
$ bundle exec rpsec
/Users/name/.rbenv/versions/2.0.0-p195/lib/ruby/gems/2.0.0/gems/bundler-1.3.5/lib/bundler/rubygems_integration.rb:214:in `block in replace_gem': rspec-core is not part of the bundle. Add it to Gemfile. (Gem::LoadError)
```

この場合も、`.bundle/config`を編集してBUNDLE_WITHOUTの行を削除すれば良いです。


