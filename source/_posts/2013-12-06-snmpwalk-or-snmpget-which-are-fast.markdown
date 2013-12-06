---
layout: post
title: "SNMPのindexキャッシュによる取得時間短縮の検証"
date: 2013-12-06 14:47
comments: true
categories: 
  - SNMP
---
ルータやサーバのインタフェースのbpsを測定する場合、SNMPのifDescr, ifHCInOctets, ifHCOutOctetsこの3つのMIBを取得すれば良いわけですが、ifDescrを毎回取得するの無駄だなとおもったので測定してみました。

<!--more-->

ifDescr, ifHCInOctets, ifHCOutOctetsをsnmpwalkする場合と、ifDescr(ifIndex)をキャッシュしifHCInOctets, ifHCOutOctetsをsnmpgetする場合で比較します。

### ベンチスクリプト
``` ruby
require 'snmp'
require 'benchmark'

puts "creating cache"
indexes = []
SNMP::Manager.open(host: 'localhost', community: 'public') do |manager|
  manager.walk(%w(ifIndex)) { |row| indexes << row[0].value.to_i }
end

Benchmark.bm do |x|
  puts "walk"
  x.report {
    SNMP::Manager.open(host: 'localhost', community: 'public') do |manager|
      manager.walk(%w(ifDescr ifHCInOctets ifHCOutOctets)) { |row| nil }
    end
  }

  sleep 3
  puts "cache with get"
  x.report {
    SNMP::Manager.open(host: 'localhost', community: 'public') do |manager|
      indexes.each do |i|
        manager.get_value(["ifHCInOctets.#{i}", "ifHCOutOctets.#{i}"])
      end
    end
  }
end
```

実際はlocalhostではなくNICをたくさん持った機器を指定。またベンチスクリプトでは簡略してifIndexだけキャッシュしてます。

### 結果
当然といえば当然ですがbind variablesの数がwalk=3個、get=2個なのでgetが早い。26%早くなりました。
```
       user     system      total        real
walk
   0.850000   0.210000   1.060000 ( 11.343248)
index cached get
   0.710000   0.210000   0.920000 (  8.387955)
```

### デメリット
キャッシュのデメリットもあります。インデックス番号は主キーになりますが、主キーに対する実態が変わってしまう場合がありえます。Linuxでインタフェースを増やしたり減らしたり、リブートしたりしてみたところ、主キーに対する実態が変わることが分かりました。

```
こういう状態で
$ snmpwalk -c public -v 2c localhost:10161 ifDesc
IF-MIB::ifDescr.1 = STRING: lo
IF-MIB::ifDescr.2 = STRING: eth0
IF-MIB::ifDescr.3 = STRING: eth1
IF-MIB::ifDescr.4 = STRING: veth0
IF-MIB::ifDescr.5 = STRING: veth1
IF-MIB::ifDescr.6 = STRING: eth1.100

veth0,veth0を消した
$ snmpwalk -c public -v 2c localhost:10161 ifDesc
IF-MIB::ifDescr.1 = STRING: lo
IF-MIB::ifDescr.2 = STRING: eth0
IF-MIB::ifDescr.3 = STRING: eth1
IF-MIB::ifDescr.6 = STRING: eth1.100

eth1.200を追加した(4ではなく7が選ばれた)
$ snmpwalk -c public -v 2c localhost:10161 ifDesc
IF-MIB::ifDescr.1 = STRING: lo
IF-MIB::ifDescr.2 = STRING: eth0
IF-MIB::ifDescr.3 = STRING: eth1
IF-MIB::ifDescr.6 = STRING: eth1.100
IF-MIB::ifDescr.7 = STRING: eth1.200

リブートした後
IF-MIB::ifDescr.1 = STRING: lo
IF-MIB::ifDescr.2 = STRING: eth0
IF-MIB::ifDescr.3 = STRING: eth1
IF-MIB::ifDescr.4 = STRING: eth1.100   # 以前は 4 は veth0 だった!!!!!
IF-MIB::ifDescr.5 = STRING: eth1.200   # 以前は 5 は veth1 だった!!!!!
```

Ciscoなどではindex値を固定化するオプションが有効という情報もありますので、ベンダによるみたい。

ちなみに、Cactiではindexキャッシュを動的にリフレッシュする仕組みがあって[こちら](http://www.cacti.net/downloads/docs/html/cli_poller_reindex_hosts.html)のドキュメントによると、

* アップタイム(sysUptime)が小さくなった(再起動)ら強制的にindexキャッシュを更新
* indexの総数が変わった場合(たとえばifIndexの中の個数が変わった場合)。インタフェースなどのケース。
* 全フィールドを検証する(?) Macアドレスなどがこのケース。エントリに変化があればキャッシュ削除ってことですかね。

インタフェースにに限ればCactiをまねてアップタイムとインデックスの個数を見て判定すれば上手くいきますね。

しかしSNMP、何十年前の技術をいつまで使うんだ!!と毎度おもってしまいます。snmpwalk時間かかるし....。

以上です!!
