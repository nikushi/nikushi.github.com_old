---
title: "ActiveRecordのtypeフィールドについて"
slug: type-column-of-activerecord
date: 2013-07-29T16:26:00+09:00
comments: true
categories: 
  - 'Ruby'
---

ActiveRecordのtypeフィールドについて。

<!--more-->

ActiveRecord::Baseを継承したモデルクラスで"type"という名前のフィールドを使おうとすると、

~~~
ActiveRecord::SubclassNotFound: The single-table inheritance mechanism failed to locate the subclass: 'abc123'. This error is raised because the column 'type' is reserved for storing the class in case of inheritance. Please rename this column if you didn't intend it to be used for storing the inheritance class or overwrite Graph.inheritance_column to use another column for that information.
~~~

という例外に遭遇します。ActiveRecordでは"type"フィールドはSTIという機能により予約されています。 [ActiveRecordのSTIの説明](http://api.rubyonrails.org/classes/ActiveRecord/Base.html)にtypeフィールドは継承関係にあるクラス名を保存するフィールドであることが書かれています。

> Active Record allows inheritance by storing the name of the class in a column
> that by default is named “type” (can be changed by overwriting 
> Base.inheritance_column). 

このエラーを回避するには以下どちらかで対応します。

1. typeというフィールド名を使うのをやめて別の名前を使う。
2. もしくは、STIで使うフィールド名を変えてしまう。

2のケースでは以下のようにします。

~~~ruby
#app/models/campany.rb
class Company < ActiveRecord::Base; end
  self.inheritance_column = 'sti_type'
end
~~~

ケースバイケースですが、ある案件ではtypeフィールドをどうしても使いたかったので2の方法を取りました。type名以外の選択が可能であれば1のケースが良いとおもいます。

