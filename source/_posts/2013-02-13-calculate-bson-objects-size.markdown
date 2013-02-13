---
layout: post
title: "BSONオブジェクトのデータサイズを確認する方法(Ruby)"
date: 2013-02-13 15:06
comments: true
categories: 
  - 'Ruby'
tags:
  - 'Ruby'
  - 'MongoDB'
  - 'Mongoid'
---

BSON Objectのサイズを求める方法。

    # parson.as_document => Moped::BSON::Document
      
    person = Person.first
    puts Moped::BSON::Document.serialize(parson.as_document).size

PersonクラスはMongoid::Documentクラスをincludeしています。MongoDBにおいて1オブジェクトの最大サイズは16MBらしいので、10万個くらいのデータセットをembedして持たせた場合に、embed元オブジェクトサイズがどの程度になる(16MBに収まるか)調べたときのメモ。

