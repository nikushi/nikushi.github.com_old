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

<!--more-->

``` ruby
class Person
  include Mongoid::Document
  field :name, type: String
end

Person.create name: 'a'

person = Person.first
puts Moped::BSON::Document.serialize(parson.as_document).size
```

MongoDBにおける1BSONオブジェクトの最大サイズは16MB。ある件でembedしてデータをたくさん持たせた場合、サイズが制限内で妥当かどうか検証したときのメモ。

蛇足ならが、ちなみ結論的にはデータ構造がネストされて大きくなる場合はembededではなくreferencedを使うべきであった。

``` ruby
class Person
  include Mongoid::Document
  field :name, type: String
  embeds_many :children
end

class Child
  include Mongoid::Document
  embeded_in :person
  field :age
end
  
Person.create name: 'a'
person = Person.first
person.children << たくさんデータ入れる
 
Person.first   # loadに時間がかかる!
```

relationにした場合、子供はloadされないので時間がかかりません。
