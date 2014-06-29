---
layout: post
title: "Google Apps Scriptで行データを連想配列として扱う"
date: 2014-06-17 18:12
comments: true
categories: 
  - GAS
---

Goolge Apps Scriptでspreadsheetの各列にアクセスするときに、列番号を指定してアクセスするコードを書いてると列追加するとスクリプトが壊れる。そこで1行目(ヘッダ行)をキーにアクセスするコードをライブラリにまとめてみた。普通なんだけどぐぐっても出てこなかったので。

<!-- more -->

以下をUtilsというプロジェクト名で保存。

```javascript
/**
* returns keys located at top of spreadsheet 
*
* @param {sheet} sh Sheet class
* @return {array} array of keys
*/
function headerKeys(sh) {
  return sh.getRange(1,1,1, sh.getLastColumn()).getValues()[0];
}

/**
* Convert a row to key-value hash according to keys input parameter
*
* @param {array} array
* @param {array} keys
* @return {array} key-value mapped
*/
function rowToHash(array, keys) {
  var hash = {};
  array.forEach(function(value, i) {
    hash[keys[i]] = value;
  })
  return hash;
}
```

参照側のプロジェクトにて、ライブラリ機能を使ってincludeすると以下のようにキーで行配列を扱える。

```javascript
// 住所録 名前から住所を取得
function getAddressByFullName(fullName) {
  var sh = SpreadsheetApp.getActive().getSheetByName('addresses');
  keys = Utils.headerKeys(sh);                                                       // ヘッダ行を取得
  var values = sh.getRange(2, 1, sh.getLastRow()-1, sh.getLastColumn()).getValues(); // データ部分(2行目以降)取得
  for (var i = 0; i < values.length; i++) {
    var row = values[i];
    row = Utils.rowToHash(row, keys); 
    if (row['full_name'] == fullName) {
      return row['address'];
    }
  }
}
```

さあこれで列が追加されても大丈夫。RDBMSだと普通なことGAS何でこんなに大変なの!とか考えたら負けです。


早く卒業したいGASおじさん。つっこみありましたらお手柔らかによろしくお願いします!!
