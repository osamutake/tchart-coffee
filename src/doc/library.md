[tchart-coffee の説明に戻る](index.html)

# tchart-coffee ライブラリの使い方

[tchart-coffee の説明に戻る](index.html)

## 使用例１：html 中に書いたソースコードを SVG に直して表示する

タイミングチャートのソースコードを次のように html に埋め込んでおき、

```html
<p>このタイミング図が見えますか？</p>

<script type="text/tchart">
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
</script>
```

```</body>``` の後ろに以下のコードを追加すれば、
自動的に SVG に変換して表示できます。

```html
<script src='https://cdn.rawgit.com/osamutake/tchart-coffee/<%=version%>/lib/tchart.min.js'></script>
<script>
(function(){
  var codes = document.getElementsByTagName('script');
  for (var i = codes.length-1; i >= 0; i--){
    var code = codes[i];
    if(code.getAttribute('type')!=='text/tchart')
      continue;
    var svg = TimingChart.format(code.textContent);
    var div = document.createElement('div');
    div.className = 'tchart';
    div.innerHTML = svg;
    code.parentNode.replaceChild(div, code);
  }
})();
</script>
```

### 実行例

[http://jsbin.com/nukico/edit?html,output](http://jsbin.com/nukico/edit?html,output)

## 使用例２：Markdown 中に書いたソースコードを SVG に直して表示する

次のような形で markdown 中にソースコードを埋め込んだ物が、

   ```tchart2svg
   clock  _~_~_~_~_~
   signal ___~~~~___
   ```

html に直したときに次のように変換されるのであれば、

 ```html
 <pre><code class="lang-tchart2svg">
clock  _~_~_~_~_~
signal ___~~~~___
</code></pre>
```

レイアウトファイルの ```</body>``` の直後に以下のコードを記述すると、
自動的に SVG に変換して表示できます。

```html
<script src='https://cdn.rawgit.com/osamutake/tchart-coffee/v1.1.0/lib/tchart.min.js'></script>
<script>
(function(){
  var codes = document.getElementsByClassName('lang-tchart2svg');
  for (var i = codes.length-1; i >= 0; i--){
    var code = codes[i];
    var svg = TimingChart.format(code.textContent);
    var div = document.createElement('div');
    div.className = 'tchart';
    div.innerHTML = svg;
    var pre = code.parentNode
    pre.parentNode.replaceChild(div, pre);
  }
})();
</script>
```

### 実行例

[http://jsbin.com/wecayu/edit?html,output](http://jsbin.com/wecayu/edit?html,output)

## ライブラリの API

### 基本事項

Node.jp で使う場合には、

```bash
$ npm install tchart-coffee
```

としてパッケージをインストールした後、

```javascript
var TimingChart = require('tchart-coffee');
```

のようにして TimingChart オブジェクトを得ます。

ブラウザ上で使う場合には、

```html
<script src="https://cdn.rawgit.com/osamutake/tchart-coffee/v1.1.0/lib/tchart-coffee.min.js"></script>
```

とすれば ```this.TimingChart``` が利用可能になります。

### svg = TimingChart.format(source [, config])

source にタイミングチャートのソースコードを渡すと、文字列として SVG を返します。

config に連想配列を渡すことで、設定値のデフォルトを変更できます。

```javascript
// someElement の直下に SVG を表示する
var svg = TimingChart.format(source);
someElement.innerHTML = svg
```

```javascript
// @grid on を指定して変換する
var svg = TimingChart.format(source, {grid: 'on'});
```

作成した SVG の縦横サイズが必要にならない限り、
以下の API は必要ありません。

### tchart = TimingChart.new([config])

新しい TimingChart インスタンスを作成して返します。

config に連想配列を渡すことで、設定値のデフォルトを変更できます。

### svg = TimingChart.prototype.parse(source)

source にタイミングチャートのソースコードを渡すと、文字列として SVG を返します。

その際、width, height, svg の各変数を適切に設定します。

```javascript
// @grid on を指定して tchart を作成
var tchart = TimingChart.new({grid: 'on'});

// ソースコードを SVG に変換し、その縦横幅を得る
tchart.parse(source);
var svg = tchart.svg;
var width = tchart.width;
var height = tchart.height;
```


### TimingChart.prototype.width

作成した SVG の幅を返します。

### TimingChart.prototype.height

作成した SVG の高さを返します。

### TimingChart.prototype.svg

作成した SVG をテキストとして取得します。

[tchart-coffee の説明に戻る](index.html)
