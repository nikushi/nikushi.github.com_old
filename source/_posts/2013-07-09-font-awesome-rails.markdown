---
layout: post
title: "Font AwesomeをRailsで使ってみた"
date: 2013-07-09 00:42
comments: true
categories: 
  - 'Rails'
tags:
  - 'Ruby'
  - 'Rails'
  - 'Bootstrap'
---

[Font Awesome](http://fortawesome.github.io/Font-Awesome/)

Bootstrap向けのicon系Webフォントを提供するライブラリ。

Railsで使うには [font-awesome-rails](https://github.com/bokmann/font-awesome-rails)をGemfileに書いて適切にimportすればOKです。

使い方1 - iタグ使う

    <i class="icon-thumbs-up"></i> icon-thumbs-up

TwitterBootstrapであらかじめ用意されているアイコンの使い方と同じです。ただFont Awesomeの場合、画像ではなくフォントとして扱われるのでfont-colorで色を調整したり出来ます。

使い方2 - CSSのcontentマークアップにユニコードを埋め込む

    .thumbs-up:before {
      font-size: 20px;
      font-family: FontAwesome;
      content: '\F164';
    }

contentの値にユニコードをセットします。ユニコードの値は各アイコンの説明ページに小さく書かれてあります。たとえば[thumbs-up](http://fortawesome.github.io/Font-Awesome/icon/thumbs-up/)であればF164をcontentの値にすればOK。また、font-familyにFontAwesomeを指定します。contentで埋め込めるので:beforeなどの疑似要素と組み合わせることでスタイルシートからアイコンをHTMLに埋め込むことも可能です!

という感じで簡単ながらFont Awesomeの紹介でした。
