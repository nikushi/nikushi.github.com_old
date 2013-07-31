---
layout: post
title: "KVMのrawフォーマットのイメージファイルをマウントする"
date: 2013-07-31 15:49
comments: true
categories: 
  - 'Linux'
---

rawフォーマット限定。

マウント
```
# losetup /dev/loop0 /data/vm/myserver.img
# kpartx -av /dev/loop0 
# ls -alF /dev/mapper
# mount /dev/mapper/loop0p1 /mnt
```

アンマウント
```
# umount /mnt
# kpartx -dv /dev/loop0
# losetup -d /dev/loop0
```

参考: [KVMのイメージをマウントする その2](http://d.hatena.ne.jp/okinaka/20091210/1260445130)
