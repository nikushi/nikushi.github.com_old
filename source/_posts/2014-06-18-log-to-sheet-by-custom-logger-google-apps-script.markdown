---
layout: post
title: "Google Apps Script カスタムLoggerでログをspreadsheetに書き出す"
date: 2014-06-18 20:05
comments: true
categories: 
  - GAS
---

Google Apps Scriptの中でLoggerで吐くログをシートに書き出すカスタムLoggerを作ってみた。

<!--more-->

こういうシートができあがる。

{% img /images/20140618-mylogger.png %}

`Logger.log()`ではなくて恒久的に保存するためのロガーを作る。例えばTriggerで時限式実行するスクリプトのログを保存しておきたいとかの用途。

いつものとおりライブラリ化する。`MyLogger`という名前で。

```javascript
function log_sheet_() {
  var sheet_name = 'log';
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sh = ss.getSheetByName(sheet_name);
  if (sh == null) {
    var active_sh = ss.getActiveSheet(); // memorize current active sheet;
    sheet_num = ss.getSheets().length;
    sh = ss.insertSheet(sheet_name, sheet_num);
    sh.getRange('A1:C1').setValues([['timestamp', 'level', 'message']]).setBackground('#cfe2f3').setFontWeight('bold');
    sh.getRange('A2:C2').setValues([[new Date(), 'info', sheet_name + ' has been created.']]).clearFormat();
    
    // .insertSheet()を呼ぶと"log"シートがアクティブになるので、元々アクティブだったシートにフォーカスを戻す
    ss.setActiveSheet(active_sh);
  } 
  return sh;
}

function log_(level, message) {
  var sh = log_sheet_();
  var now = new Date();
  var last_row = sh.getLastRow();
  sh.insertRowAfter(last_row).getRange(last_row+1, 1, 1, 3).setValues([[now, level, message]]);
  return sh;
}

function debug(message) {
  log_('debug', message);
}

function info(message) {
  log_('info', message);
}

function warn(message) {
  log_('warn', message);
}

function error(message) {
  log_('error', message);
}

function fatal(message) {
  log_('fatal', message);
}
```

呼び出す側のプロジェクトでは、先ほど作った`MyLogger`のプロジェクトキーを登録して、こうやって呼び出す。初回呼び出し時に"log"という名前でシートを作成し以降は末尾の行にログが追加される。

```javascript
MyLogger.info('works!');
```


