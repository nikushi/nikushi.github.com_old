---
layout: post
title: "Google Apps Scriptを速くするためのベストプラクティス"
date: 2014-05-30 18:23
comments: true
categories: 
  - GAS
---

Google Developersサイトの[Best Practices](https://developers.google.com/apps-script/best_practices?hl=ja)を要約してみた。

<!--more-->

### サービスのcallを最小限に

javascript内で閉じた処理の方がサービスをcallするよりも早い。サービスのcallとはspreadsheetのデータを読み出したり書き出したり、Docsを参照したり、SiteやTranslateやUrlFetchとか使ったり。

### バッチオペレーション

spreadsheetのreadとwriteの回数を最小化する。readとwriteは重い処理。1オペレーションでデータを配列にreadし、1オペレーションで配列にwriteすること。forreachの中で毎回callするのは遅いので、配列に溜めて最後に1回で書きだす。たとえば`setBackgroundColor(value)`をたくさん呼ぶのではなく`setBackgroundColors(values);`1回にする。


### Cache Class

[Cache](https://developers.google.com/apps-script/reference/cache/cache?hl=ja)というキャッシュクラスがあるので、頻繁に使うけど遅いデータはキャッシュしとく。key valueでキャッシュできる。

例

```
function getRssFeed() {
   var cache = CacheService.getPublicCache();
   var cached = cache.get("rss-feed-contents");
   if (cached != null) {
     return cached;
   }
   var result = UrlFetchApp.fetch("http://example.com/my-slow-rss-feed.xml"); // takes 20 seconds
   var contents = result.getContentText();
   cache.put("rss-feed-contents", contents, 1500); // cache for 25 minutes
   return contents;
}
```

### Using Client Handlers for More Responsive UIs

UI applicationを使う場合でイベントコールバック(たとえばボタンをクリックするとか)を使う場合、[ClientHandler](https://developers.google.com/apps-script/reference/ui/client-handler?hl=ja)を使うと高速化できる。サーバサイドでイベントキャッチするのではなく、クライアントサイド(ブラウザ)でhandleすることができるので。使う機会がいまのところ無いので詳しくはない。

以上!
