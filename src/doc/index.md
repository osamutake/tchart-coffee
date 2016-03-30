tchart-coffee
================

概要
----------------

このようなテキストを入力すると、

```nohighlight
aclk    ~_~_~_~_~_~_~_~_~_~_
awaddr  ==?X=A1==X=A2X=A3==X==?=X=A4X=?
awvalid __~~~~~~~~~~____~~__
awready ____[~~~~]__[~~]____[~~]__
wdata   ====?X=D1X=D2X=?X=D3X=?X=D4==X=?
wvalid  ____~~~~__~~__~~~~__
wready  ____~~~~__~~____~~__
bresp   ====00================
bvalid  ____~~~~__~~____~~__
bready  ~~~~~~~~~~~~~~~~~~1~~
```

こんなタイミングチャートを生成する javascript ライブラリとエディタを提供します。

```tchart2svg
aclk    ~_~_~_~_~_~_~_~_~_~_
awaddr  ==?X=A1==X=A2X=A3==X==?=X=A4X=?
awvalid __~~~~~~~~~~____~~__
awready ____[~~~~]__[~~]____[~~]__
wdata   ====?X=D1X=D2X=?X=D3X=?X=D4==X=?
wvalid  ____~~~~__~~__~~~~__
wready  ____~~~~__~~____~~__
bresp   ====00================
bvalid  ____~~~~__~~____~~__
bready  ~~~~~~~~~~~~~~~~~~1~~
```

ライブラリ
----------------

[![NPM](https://nodei.co/npm/tchart-coffee.png?downloads=true&downloadRank=true)](https://www.npmjs.com/package/tchart-coffee)

### Use with Node.js

    $ npm install tchart-coffee


```javascript
var TimingChart = require('tchart-coffee');
var svg = TimingChart.format(source);
```

### Use on the Web

```javascript
<script src="https://cdn.rawgit.com/osamutake/tchart-coffee/<%=version%>/lib/tchart-coffee.min.js"></script>
<script>
  var svg = TimingChart.format(source);
</script>
```

### API

未稿

エディタ
----------------

こちらからご利用いただけます。

<a href="https://rawgit.com/osamutake/tchart-coffee/master/bin/editor-offline.html" target="_blank">https://rawgit.com/osamutake/tchart-coffee/master/bin/editor-offline.html</a>

* 清書したタイミングチャートを SVG または PNG 形式で保存できます。
* 入力内容はサーバーに送られることなく、完全にブラウザ上だけで画像を生成しますので、守秘義務の問題も発生しません。心配であればリンク先の html を PC に保存して、そこから立ち上げれば、完全にオフラインの状態でも動作します。

### IE での不具合

[リンク先で議論されている問題](https://connect.microsoft.com/IE/feedback/details/809823/draw-svg-image-on-canvas-context)のため、[Save as PNG] および [Generate Images for Copy] のボタンが IE では正常に働きません。

代わりに、SVG 画像上で右クリックから [名前を付けて画像を保存] で形式を PNG にすれば保存できます。
同様に、右クリックから [コピー] で画像をクリップボードへ入れられるので、 Word などへ貼り付ける用途ではむしろ IE の方が便利かもしれません。

### IE 以外でクリップボードへのコピーの仕方

セキュリティ上の制限のため、javascript からクリップボードへ 自動的にコピーすることはできないようになっています。 そこで、手動で対応していただく必要があります。

まず [Generate Images for Copy] ボタンを押すと SVG ソースと PNG 画像が生成されます。

* SVG ソースをご入り用であれば、SVG ソースにフォーカスが当たっている状況でそのまま Ctrl+C すればコピー可能です
* PNG 画像がご入り用であれば、PNG 画像上で右クリックから [画像をコピー] します
  * なぜか空の HTML も一緒にコピーされてしまうようで、なおかつこの空の HTML が優先的に貼り付けられるようなので、Word などへ貼り付ける際には [形式を選択して貼り付け]-[ビットマップ(DIB)] などとして下さい（Office でのショートカットは Alt+E,S です）

チャート文法
----------------

[こちらをご覧下さい](syntax.html)

謝辞
----------------

熊谷正朗さんの "Timing chart formatter by kumagai" を大いに参考にさせていただきました。→
[http://www.mech.tohoku-gakuin.ac.jp/rde/contents/library/tchart/indexframe.html](http://www.mech.tohoku-gakuin.ac.jp/rde/contents/library/tchart/indexframe.html)

記述文法はほぼ熊谷さんの tchart を踏襲しています。

大変有用なツールをご提供くださったことに感謝いたします。
