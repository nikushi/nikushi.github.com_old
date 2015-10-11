---
date: 2015-10-06T22:47:17+09:00
title: 英語学習 x コマンドラインツール
---

最近Skypeで英会話レッスンを受けてレッスン後には復習をさっとやるのですが、辞書を引く、単語の発音確認などの作業をささっとコマンドラインツールで出来たらとおもいまとめてみました。ほぼMac限定です。

<!-- more -->

### 辞書

`open dict://WORD`でターミナルからMac付属のDictionaly.app(辞書.app)を開ける

```
$ open dict://Hello
```

.bashrc, .zshrcなどにエイリアス登録しとくと`$ dict Hello`で使えて便利。

```sh
function dict {
  if [ $# -eq 0 ]; then
    echo "Usage: dict WORD" 1>&2
    return 1
  fi
  open dict://$@
}
```

あらかじめDictionaly.appの設定で必要な辞書(英英、英和、和英などなど)好みの設定にしておくとよい。

**UPDATE 2015/10/12**

はてブコメント経由で辞書引いた結果をターミナル内で完結しないのか、というのがあり調べてみた。

[jakwings/macdict](https://github.com/jakwings/macdict])というのが良さそう。CLIオプションで辞書を選択できるようになってた。また[sekimura/lookup](https://github.com/sekimura/lookup)というのも見つけたがこちらは任意の辞書選択は出来ないみたい。

ただ文字列を整形して(例えばmanみたいに)出してくれる訳ではないのでやはり読みやすくはないので、個人的な意見としてはopen dict://で辞書アプリに飛ぶ方が良いかなー。

### 発音確認

sayコマンドでMacが喋り出す。

```
$ say "Bob’s mother became sick three month ago"
```

`-r NUMBER`オプションで1分間のワードレートを変更できる。-r 100くらいにするとゆっくり喋ってくれる。

```
$ say -r 100 Please speak slowly
```


### 自分の発音を録音し即時再生

soxコマンド付属のコマンドを使うとコマンドラインで録音、オーディオファイル再生ができる。

インストール。sox, rec, playコマンドがインストールされる。

```
$ brew install sox
```

以下のコマンドで録音 -> Ctrl-cで録音終了 -> 即時再生となる。簡易ボイスレコーダになって便利。

```
$ rec /tmp/a.wav; play /tmp/a.wav; rm /tmp/a.wav

Input File     : 'default' (coreaudio)
Channels       : 2
Sample Rate    : 44100
Precision      : 32-bit
Sample Encoding: 32-bit Signed Integer PCM

In:0.00% 00:00:01.83 [00:00:00.00] Out:79.9k [   ===|===   ]  Clip:0
...
```

.zshrc, .bashrcなどに`alias rec-play='rec /tmp/a.wav; play /tmp/a.wav; rm /tmp/a.wav'`としておくと便利。

いろいろ便利。
