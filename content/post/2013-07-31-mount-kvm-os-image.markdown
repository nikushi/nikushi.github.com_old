---
title: "KVMのrawフォーマットのイメージファイルをマウントする"
slug: mount-kvm-os-image
date: 2013-07-31T15:49:00+09:00
comments: true
categories: 
  - 'Linux'
---

rawフォーマット限定。

<!--more-->

マウント
~~~
# losetup /dev/loop0 /data/vm/myserver.img
# kpartx -av /dev/loop0 
# ls -alF /dev/mapper
# mount /dev/mapper/loop0p1 /mnt
~~~

アンマウント
~~~
# umount /mnt
# kpartx -dv /dev/loop0
# losetup -d /dev/loop0
~~~

参考: [KVMのイメージをマウントする その2](http://d.hatena.ne.jp/okinaka/20091210/1260445130)
