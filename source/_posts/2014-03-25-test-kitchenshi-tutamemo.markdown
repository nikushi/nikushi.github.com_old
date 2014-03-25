---
layout: post
title: "test-kitchen使ったメモ"
date: 2014-03-25 11:46
comments: true
categories: 
  - Chef
---

最近はImmutable Infrastracture盛り上がりでChefやPuppetが語られる機会が少なくなって気がしますが、それはChef/Puppetが成熟してきた証拠? test-kitchenを使ってみたメモです。

<!--more-->

[GETTING STARTED GUIDE](http://kitchen.ci/docs/getting-started) を写経。詳細はリンク先の原文を参照してください。

拙作の[rbenv-cookbook](https://github.com/niku4i/rbenv-cookbook)をtest-kitchenをつかってVagrant上の仮想マシンでテストするところまで進めました。なお、Vagrantのバージョンは1.5.1を使いました。

### インストール

```
$ gem install test-kitchen
$ kitchen -v
Test Kitchen version 1.2.1
```

また、あらかじめcookbookをgit cloneしておきます

```
$ git clone git@github.com:niku4i/rbenv-cookbook.git
$ cd rbenv-cookbook
```

### kitchen init

```
$ kitchen init --driver=kitchen-vagrant
      create  .kitchen.yml
      create  test/integration/default
      create  .gitignore
      append  .gitignore
      append  .gitignore
         run  gem install kitchen-vagrant from "."
Fetching: kitchen-vagrant-0.14.0.gem (100%)
Successfully installed kitchen-vagrant-0.14.0
Parsing documentation for kitchen-vagrant-0.14.0
Installing ri documentation for kitchen-vagrant-0.14.0
1 gem installed
```

.kitchen.ymlが作られた。中身は以下のとおり。ubuntuはひとまず不要なのでplatformから削除。またinitで作成されたyamlに登録されているcentos-6.4ではkitchen createしたときにvagrant upできなくてエラーになってしまったので、boxイメージが悪いのかなと判断して6.5を使うように変更した。

```
---
driver:
  name: vagrant

provisioner:
  name: chef_solo

platforms:
#  - name: ubuntu-12.04
#  - name: centos-6.4
  - name: centos-65

suites:
  - name: default
    run_list:
      - recipe[rbenv-cookbook::default]
    attributes:
```

kitchen listコマンドで確認できた。

```
$ kitchen list
Instance           Driver   Provisioner  Last Action
default-centos-64  Vagrant  ChefSolo     <Not Created>
```

### kitchen create

kitchen createでインスタンスをアップ


```
 $ kitchen create default-centos-65
-----> Starting Kitchen (v1.2.1)
-----> Creating <default-centos-65>...
       Bringing machine 'default' up with 'virtualbox' provider...
       ==> default: Box 'opscode-centos-6.5' could not be found. Attempting to find and install...
           default: Box Provider: virtualbox
           default: Box Version: >= 0
       ==> default: Adding box 'opscode-centos-6.5' (v0) for provider: virtualbox
           default: Downloading: https://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box
       ==> default: Successfully added box 'opscode-centos-6.5' (v0) for 'virtualbox'!
       ==> default: Importing base box 'opscode-centos-6.5'...
       ==> default: Matching MAC address for NAT networking...
       ==> default: Setting the name of the VM: default-centos-65_default_1395719095721_73691
       ==> default: Fixed port collision for 22 => 2222. Now on port 2201.
       ==> default: Clearing any previously set network interfaces...
       ==> default: Preparing network interfaces based on configuration...
           default: Adapter 1: nat
       ==> default: Forwarding ports...
           default: 22 => 2201 (adapter 1)
       ==> default: Running 'pre-boot' VM customizations...
       ==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...           default: SSH address: 127.0.0.1:2201
           default: SSH username: vagrant
           default: SSH auth method: private key
           default: Error: Connection timeout. Retrying...
       ==> default: Machine booted and ready!
       ==> default: Checking for guest additions in VM...
           default: The guest additions on this VM do not match the installed version of
           default: VirtualBox! In most cases this is fine, but in rare cases it can
           default: prevent things such as shared folders from working properly. If you see
           default: shared folder errors, please make sure the guest additions within the
           default: virtual machine match the version of VirtualBox you have installed on
           default: your host and reload your VM.
           default:
           default: Guest Additions Version: 4.3.8
           default: VirtualBox Version: 4.2
       ==> default: Setting hostname...
       Vagrant instance <default-centos-65> created.
       Finished creating <default-centos-65> (11m27.39s).
-----> Kitchen is finished. (11m27.70s)
```

- vagrantでインスタンスを起動する
- boxが登録されてなければネットワークから探してくる


```
$ kitchen list
Instance           Driver   Provisioner  Last Action
default-centos-65  Vagrant  ChefSolo     Created
```

### kitchen converge

レシピをインスタンスに適用する

```
$ kitchen converge default-centos-65
-----> Starting Kitchen (v1.2.1)
-----> Converging <default-centos-65>...
       Preparing files for transfer
       Preparing current project directory as a cookbook
       Removing non-cookbook files before transfer
-----> Installing Chef Omnibus (true)
       downloading https://www.getchef.com/chef/install.sh
         to file /tmp/install.sh
       trying wget...
       Downloading Chef  for el...
       downloading https://www.getchef.com/chef/metadata?v=&prerelease=false&p=el&pv=6&m=x86_64
         to file /tmp/install.sh.1851/metadata.txt
       trying wget...
       url      https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-11.10.4-1.el6.x86_64.rpm
       md5      3fe6dd8e19301b6c66032496a89097db
       sha256   edd5d2bcc174f67e5e5136fd7e5fffd9414c5f4949c68b28055b124185904d9f
       downloaded metadata file looks valid...
       downloading https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-11.10.4-1.el6.x86_64.rpm
         to file /tmp/install.sh.1851/chef-11.10.4-1.el6.x86_64.rpm
       trying wget...
       Comparing checksum with sha256sum...
       Installing Chef
       installing with rpm...
       warning: /tmp/install.sh.1851/chef-11.10.4-1.el6.x86_64.rpm: Header V4 DSA/SHA1 Signature, key ID 83ef826a: NOKEY
Preparing...                #####  ########################################### [100%]
   1:chef                          ########################################### [100%]
       Thank you for installing Chef!
       Transfering files to <default-centos-65>
       [2014-03-25T03:51:33+00:00] INFO: Forking chef instance to converge...
       Starting Chef Client, version 11.10.4
       [2014-03-25T03:51:33+00:00] INFO: *** Chef 11.10.4 ***
       [2014-03-25T03:51:33+00:00] INFO: Chef-client pid: 1948
       [2014-03-25T03:51:34+00:00] INFO: Setting the run_list to ["recipe[rbenv-cookbook::default]"] from JSON
       [2014-03-25T03:51:34+00:00] INFO: Run List is [recipe[rbenv-cookbook::default]]
       [2014-03-25T03:51:34+00:00] INFO: Run List expands to [rbenv-cookbook::default]
       [2014-03-25T03:51:34+00:00] INFO: Starting Chef Run for default-centos-65
       [2014-03-25T03:51:34+00:00] INFO: Running start handlers
       [2014-03-25T03:51:34+00:00] INFO: Start handlers complete.
       Compiling Cookbooks...

       Running handlers:
       [2014-03-25T03:51:34+00:00] ERROR: Running exception handlers
       Running handlers complete

       [2014-03-25T03:51:34+00:00] ERROR: Exception handlers complete
       [2014-03-25T03:51:34+00:00] FATAL: Stacktrace dumped to /tmp/kitchen/cache/chef-stacktrace.out
       Chef Client failed. 0 resources updated in 0.458583313 seconds
       [2014-03-25T03:51:34+00:00] ERROR: Cookbook yum-epel not found. If you're loading yum-epel from another cookbook, make sure you configure the dependency in your metadata
       [2014-03-25T03:51:34+00:00] FATAL: Chef::Exceptions::ChildConvergeError: Chef run process exited unsuccessfully (exit code 1)
>>>>>> Converge failed on instance <default-centos-65>.
>>>>>> Please see .kitchen/logs/default-centos-65.log for more details
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: SSH exited (1) for command: [sudo -E chef-solo --config /tmp/kitchen/solo.rb --json-attributes /tmp/kitchen/dna.json  --log_level info]
```

エラーでこけた... 。rbenv-cookbookはyum-epelに依存してるせい? metadata.rbは既に作ってるのでBerkshelfファイルを作成しmetadataを読み込むようにしたらエラーをパスできた!

```text Berksfile
source "https://api.berkshelf.com"

metadata
```

再実行。gitが無いので止まった。これはレシピが悪い。

```ruby recipes/default.rb
...snip...
+ package "git"
...snip...
```

再実行!無事終了!

kitchen convergeでやること

- インスタンスにChefをインストール
- 依存関係のレシピをインストール
- .kitchen.ymlのrun_listを実行

### 手動で確認する

ここまででレシピをエラー無くインスタンスに適用できることを確認した。手動でログインし確認する。

```
$ kitchen login default-centos-65
Last login: Tue Mar 25 03:59:38 2014 from 10.0.2.2
[vagrant@default-centos-65 ~]$
```

ログインできた。rbenvインストールされている。

```
$ rbenv
rbenv 0.4.0-95-gf71e227
Usage: rbenv <command> [<args>]
```

### テストを書く

ServerSpecを使いたいところではあるが、ここではチュートリアルに従ってBusserというテストフレームワークでテストを書く。

テスト用のディレクトリを作成

```
mkdir -p test/integration/default/bats
```

今回は実行ファイルが存在するかどうかだけチェックした。

```text test/integration/default/bats/rbenv_installed.bats    
#!/usr/bin/env bats

@test "executable rbenv command is found" {
  run test -x /usr/local/rbenv/bin/rbenv
  [ "$status" -eq 0 ]
}

```

テストを流す

```
$ kitchen veryfy default-centos-65  

-----> Starting Kitchen (v1.2.1)
-----> Verifying <default-centos-65>...
       Removing /tmp/busser/suites/bats
       Uploading /tmp/busser/suites/bats/rbenv_installed.bats (mode=0644)
-----> Running bats test suite
 ✓ executable rbenv command is found

       1 test, 0 failures
       Finished verifying <default-centos-65> (0m1.30s).
-----> Kitchen is finished. (0m2.12s)
```

### kitchen test

いままでやってきたことを全工程流す。

```
$ kitchen veryfy default-centos-65  
```

- 既存のインスタンスがあれば廃棄する
- インスタンス作成
- Chefのインストール
- レシピのインストール
- テストの実行
- インスタンスの廃棄

### 感想

test kitchenよい。でも初回遅い。boxが最初ないと更に遅い。この辺はVagrantをDockerに変えるというアプローチがあるとおもうが気軽ではない感じかも。しばらく使ってみる!


