---
layout: post
title: "Google Apps Scriptをつかってみた"
date: 2014-05-30 00:39
comments: true
categories: 
  - GAS
---

某案件でGoogle Spreadsheetを使う機会があって少しかじってみた。浅くメモ。

<!--more-->

### About Google Apps Script

Google Apps ScriptはGoogleプラットフォーム上で動くサーバサイドjavascript。spreadsheetに限らずGoogle Apps上のデータと連携してアイデア次第で何でもできる言語。例えばGmailでqueryをかけてbodyをパースしてspreadsheetにデータ貯めて、解析してPDF変換してGmailに送る、みたいなこともできる。

Google Apps内に限らず、外部のAPIサーバからデータを取ってきたり、逆に外のサーバにデータを送ることもできる。ただし、Google Platformで実行されるのでファイアウォールを超えてイントラネットに接続するという要件はセキュリティ的に難しい制約はある。

triggerを使うとイベント起因で関数を実行できる。ボタンクリックとかドキュメントを開いたときとか。

#### triggerの例

ドキュメントオープン時にメニューボタンを追加する例。

```
function onOpen() { // automatically run this on open a spreadsheet.
  var menuEntries = [ {name: "say hello", functionName: "sayHello"} ];
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  ss.addMenu("my menu", menuEntries);
}

function sayHello() {
  Logger.log('Hello World!');
}
```

時限式のtriggerでcron的なことも可能で、もちろんMac Bookを閉じた後もGoogleプラットフォーム上で実行される。triggerを使えば定期的にGmailをチェックして何かやるみたいなこともできる。

書いたスクリプトをWebアプリとして公開する設定をするとURLのエンドポイントがもらえる。triggerには`doGet()`というのもあってURLをGETしたトリガで何かできたりする。例えばGETトリガでスクリプトへcallbackされるのでURLのqueryのkey, valueをspreadsheetにためるといったこともできる(簡易WebAPI!)

### 制約

#### 実行遅い

結構実行遅い。APIのcallを少なくを心がける。ノウハウは [Best Practices](https://developers.google.com/apps-script/best_practices?hl=ja)を参照のこと。

```
//bad
for (..) {
    sh.getRange(n,1).setValue('Value');
}

//good
sh.getRange(1,1,100,1).setValue([['Value', 'Value'], ['Value', 'Value']]);
```

#### 1回の実行 5分まで

実行が5分過ぎるとスクリプトは終了する。

### リファレンス

自分はこの辺みてます。

* [何はともあれ公式サイト](https://developers.google.com/apps-script/?hl=ja)
* [stackoverflowのtagged/google-apps-script](http://stackoverflow.com/questions/tagged/google-apps-script) あまり見てないけど
* 本 僕はいま[Google Apps Script for Biginner](http://www.amazon.co.jp/gp/product/B00IM5UW1W/ref=oh_d__o00_details_o00__i00?ie=UTF8&psc=1)を読んでる

日本語でヒットするサイトはExcelっぽい雰囲気が漂っててあまり見ていない(笑) もちろん参考にさせていただいているけど。

### おもったところ

開発環境はブラウザ上のスクリプトエディタを使わざるおえないので、脳がブラウジング脳になるのが難点。viモードほしい。

他のOSSと組み合わせるとアイデア次第で面白いことできそう。[Fluentd Dashboard](http://qiita.com/kazunori279/items/6329df57635799405547) のデモはすごかった!

Viewを作らなくていいので楽!

カジュアルに初めてカジュアルに終えるのが良いかと。それなりの規模であればRailsとかで真面目に作ろう。
