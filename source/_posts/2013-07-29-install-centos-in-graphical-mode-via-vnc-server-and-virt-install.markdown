---
layout: post
title: "virt-installでvncサーバを立ち上げてCentOSをグラフィカルインストール"
date: 2013-07-29 22:58
comments: true
categories: 
  - 'Linux'
---

やっつけ感ある手順であるがこんな感じ。

```
cd /data/vm
qemu-img create -f qcow2 server01.img 10G
virt-install -n server01 \
-r 1024 \
--disk path=/data/vm/server01.img,size=10,format=qcow2 \
--virt-type=kvm \
--vcpus=2 \
--os-type linux \
--os-variant=rhel6 \
--network bridge=br0 \
--graphics vnc,password=abc123,port=5910,keymap=us \ 
--cdrom=/var/tmp/CentOS-6.4-x86_64-minimal.iso
```

さらに、virsh consoleでコンソールを取れるようにする。

```
# vi /et/grub.conf

#splashimage=(hd0,0)/boot/grub/splash.xpm.gz  # この行は不要
serial --unit=0 --speed=115200 # 追加
terminal --timeout=5 serial console # 追加
```

```
# echo ttyS0 >> /etc/securetty
```

CentOS6の場合upstart経由で起動時にttyS0を自動起動してあげる必要がある。CentOS6.4最小インストール直後であればttyS0は自動起動してくれていた。以下のとおり確認しただけ。

起動しているか確認

```
# initctl list |grep serial
serial (ttyS0) start/running, process 5091
```

設定ファイル
```
# vi /etc/init/serial.conf
```

参考: [仮想マシンにシリアルコンソールで接続できるよ](http://lab.unicast.ne.jp/2013/02/15/%E4%BB%AE%E6%83%B3%E3%83%9E%E3%82%B7%E3%83%B3%E3%81%AB%E3%82%B7%E3%83%AA%E3%82%A2%E3%83%AB%E3%82%B3%E3%83%B3%E3%82%BD%E3%83%BC%E3%83%AB%E3%81%A7%E6%8E%A5%E7%B6%9A%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%88/)
