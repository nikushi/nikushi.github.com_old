---
layout: post
title: "Chefでtd-agentをインストールしたメモ + knife solo cook実行時エラーにはまったメモ"
date: 2014-01-08 21:37
comments: true
categories: 
  - td-agent
  - chef
---

td-agentを[treasure-data/chef-td-agent](https://github.com/treasure-data/chef-td-agent/)のChefレシピを使ってVagrantの仮想マシンに適用したメモです。

<!-- more -->

### 準備 

chefとknife-soloをインストール

    $ gem install chef
    $ gem install knife-solo


### Chefレポジトリ作成

    $ knife solo init chef-test-repo
    $ cd chef-test-repo/

### chef-td-agentをBerkshelfでインストール

Berkshelf = gemでいうところのbundler(とrubygems)みたいなもの。

berkshelfコマンドのインストール。bundler経由でインストールした。

``` text Gemfile
source 'https://rubygems.org'
gem 'berkshelf'
```

インストール

    $ bundle install

Berksfileにインストールするクックブックを定義

    site :opscode
    cookbook 'td-agent', git: 'https://github.com/treasure-data/chef-td-agent.git'

berks installでクックブックをインストール。`--path`で`cookbooks`以下に。

    $ bundle exec berks --path cookbooks

### knifeコマンドで対象マシンの定義を作る

knifeコマンドで対象マシンへchef soloをインストールしつつ、定義ファイル(json)を作る。

    $ knife solo prepare chef-test.local
      => chef-test.local に chef solo がインストールされる
      => nodes/chef-test.local.json が作られる

nodes/chef-test.local.jsonのrun_listにtd-agentを加える

``` text nodes/chef-test.local.json
{"run_list":["td-agent"]}
```

### レシピ適用!!!

以下を実行することで、td-agent実行ユーザ、グループの作成、td-agentのインストール、設定ファイル配置、起動登録、起動といったことをやってくれます。

    $ knife solo coook chef-test.local

...とここで楽勝終わる予定だったのですが、途中でエラーが出て止まってしまいました。

### package td-agent が途中で止まる

```
knife solo cook cheftest.local
Running Chef on cheftest.local...
Checking Chef version...
Installing Berkshelf cookbooks to 'cookbooks'...
Installing td-agent (0.0.1) from git: 'https://github.com/treasure-data/chef-td-agent.git' with branch: 'master' at ref: 'd29d3f78bc2ffe991c63d56cbf8521eda6fdeb35'

(..snip..)

Recipe: td-agent::default
  * template[/etc/td-agent/td-agent.conf] action create (up to date)
  * package[td-agent] action upgrade

================================================================================
Error executing action `upgrade` on resource 'package[td-agent]'
================================================================================


Chef::Exceptions::Exec
----------------------
 returned 1, expected 0


Resource Declaration:
---------------------
# In /home/vagrant/chef-solo/cookbooks-2/td-agent/recipes/default.rb

 60: package "td-agent" do
 61:   options value_for_platform(
 62:     ["ubuntu", "debian"] => {"default" => "-f --force-yes"},
 63:     "default" => nil
 64:   )
 65:   action :upgrade
 66: end
 67:



Compiled Resource:
------------------
# Declared in /home/vagrant/chef-solo/cookbooks-2/td-agent/recipes/default.rb:60:in `from_file'

package("td-agent") do
  action [:upgrade]
  retries 0
  retry_delay 2
  package_name "td-agent"
  version "1.1.18-0"
  cookbook_name :"td-agent"
  recipe_name "default"
end



[2014-01-08T12:23:00+00:00] ERROR: Running exception handlers
[2014-01-08T12:23:00+00:00] ERROR: Exception handlers complete
[2014-01-08T12:23:00+00:00] FATAL: Stacktrace dumped to /var/chef/cache/chef-stacktrace.out
Chef Client failed. 4 resources updated
[2014-01-08T12:23:00+00:00] ERROR: package[td-agent] (td-agent::default line 60) had an error: Chef::Exceptions::Exec:  returned 1, expected 0
[2014-01-08T12:23:00+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
ERROR: RuntimeError: chef-solo failed. See output above.gg
```

調べたところ、`yum install td-agent`がgpgcheckで失敗していた。

    $ yum -d0 -e0 -y install td-agent-1.1.18-0
    Package td-libyaml-0.1.4-1.x86_64.rpm is not signed

お、バグかな?とおもったらKnown Issueでした。[Apply signature to rpm /deb](https://github.com/treasure-data/td-agent/issues/43)。**(2013/01/15 追記) rpmが更新されて問題は解消しました**



