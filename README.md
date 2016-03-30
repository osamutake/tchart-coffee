# tchart-coffee

Online timing chart formatter that converts a source code of a timing chart into SVG graphics on browsers.  
テキストで書かれたタイミングチャートをブラウザ上でSVGに変換します。

It includes a javascript library and an online visual editor,
which convert a source text like the following:  
javascriptのライブラリとチャートソースエディタを含んでおり、次のようなソースコードを

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

into a timing chart like:  
次のようなチャートに変換できます。

![example.svg](https://rawgit.com/osamutake/tchart-coffee/master/doc/example.svg)


[The detailed description in Japanese is available.](https://rawgit.com/osamutake/tchart-coffee/master/doc/index.html)  
[日本語の詳しい説明はこちらです](https://rawgit.com/osamutake/tchart-coffee/master/doc/index.html)

# 謝辞

熊谷正朗さんの "Timing chart formatter by kumagai"  
[http://www.mech.tohoku-gakuin.ac.jp/rde/contents/library/tchart/indexframe.html](http://www.mech.tohoku-gakuin.ac.jp/rde/contents/library/tchart/indexframe.html)

を大いに参考にさせていただきました。

記述文法はほぼ熊谷さんの tchart を踏襲しています。

大変有用なツールをご提供くださったことに感謝いたします。

# ライセンス

MIT
