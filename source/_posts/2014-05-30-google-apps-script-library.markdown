---
layout: post
title: "Google Apps Scriptの共通関数をライブラリでまとめる"
date: 2014-05-30 14:53
comments: true
categories: 
  - GAS
---

[前回](/blog/2014/05/30/tried-google-apps-script/)に引き続きGoogle Apps Script。共通関数をライブラリにする方法。

<!--more-->

共通の処理をライブラリとして独立して管理できるのか調査した。Libraryの機能を使うとできることがわかったのでメモ。[公式のドキュメント](https://developers.google.com/apps-script/guide_libraries)。

spreadsheet -> スクリプトエディタ -> スクリプト作成 の順番でたどるとspreadsheetのバインドされたscriptができあがるが、このスクリプトはライブラリにはできない。ライブラリとして作るにはGoogle Apps Home -> スクリプト作成する必要がある点が最初分かりにくかった。

ライブラリ作成後、spreadsheetのスクリプトエディタ側でライブラリを指定してあげればOK。実際はライブラリにユニークに割り当てられるproject keyを使う側で指定する。

#### イメージ

{%img /images/20140530-script-lib.png %}

#### その他

* 利用ユーザへライブラリへのアクセス権限が必要
* project keyの伝達が必要
* ライブラリスクリプトは1個以上のバージョニングをつけて保存すること(インクルード側でバージョン指定ができる)
* インクルードライブラリの識別子(クラス名みたいなもの)は任意の文字列を指定できる。たとえば`MyPicasaApi `とか。プロジェクト内では`MyPicasaApi.doSomething()`で呼べる。もし既存のクラス(たとえば`UiApp`)と被ると既存クラスがオーバライドされる。
* privateなメソッドを作るには _ で終わる名前をつけるとautocompleteで出てこなくなる。 e.g. `myPrivateMethod_()`
* autocompleteで表示されるドキュメントを与えたいなら、関数の上に[JSDoc style documentation](https://developers.google.com/closure/compiler/docs/js-for-compiler)でコメントを書く。

```
/**
* Raises a number to the given power, and returns the result.
*
* @param {number} base the number we're raising to a power
* @param {number} exp the exponent we're raising the base to
* @return {number} the result of the exponential calculation
*/
function power(base, exp) { ... }
```

* デバッギングモードの選択。デバッギングモードをオンにすると、ライブラリでバージョニングされていない最新の修正を取り込んで動作各確認できる。

GAS力がさらに上がりました!以上!
