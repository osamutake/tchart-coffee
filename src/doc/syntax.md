tchart-coffee 文法
================

[tchart の説明へ戻る](index.html)

チャート文法(概要)
----------------

### # から始まる行はコメント行です

```nohighlight
# This line will not appear in the chart
clk    _~_~_~_~_~
signal ___~~~~___
```

```tchart2svg
# This line will not appear in the chart
clk    _~_~_~_~_~
signal ___~~~~___
```

### @ から始まる行で設定を変更できます

形式は次の通りです。

```nohighlight
@[設定値の名称][スペース][設定値]
```

[設定可能な値としてどんな物があるかについてはこちらです。](#1-3)

```nohighlight
@signal_style stroke-linecap="round" stroke-width="2" stroke="green" fill="none"
clk    _~_~_~_~_~
signal ___~~~~___
```

```tchart2svg
@signal_style stroke-linecap="round" stroke-width="2" stroke="green" fill="none"
clk    _~_~_~_~_~
signal ___~~~~___
```

### % から始まる行で自由な位置に文字列を追加できます

与えるパラメータは、次の通りです。

```nohighlight
%[x座標][スペース][y座標][スペース][文字列]
```

```nohighlight
@margin 20
%100 -7 test!
clk    _~_~_~_~_~
signal ___~~~~___
```

```tchart2svg
@margin 20
%100 -7 test!
clk    _~_~_~_~_~
signal ___~~~~___
```

### 空行があれば１行分だけ空白が空きます

```nohighlight
clk1   _~_~_~_~_~
clk2   __~~__~~__
signal ___~~_____
```

```tchart2svg
clk1   _~_~_~_~_~
clk2   __~~__~~__

signal ___~~_____
```

### その他の文字から始まる行が信号定義になります

フォーマットは

```nohighlight
信号名 [空白] タイミング定義
```

の形です。

チャート文法(タイミング定義)
----------------

### _ と ~ で 0 と 1 を表します。

~~ が上に寄らず中央に来るフォントだとちょっと見にくいですね。。。

### - がハイインピーダンス状態です。

```nohighlight
clk    _~_~_~_~_~_~_~_~_~
data   ___~~~~__~~____~~_
enable ___~~~~~~~~~~_____
output ---~~~~__~~__-----
```

```tchart2svg
clk    _~_~_~_~_~_~_~_~_~
data   ___~~~~__~~____~~_
enable ___~~~~~~~~~~_____
output ---~~~~__~~__-----
```

### バス信号や不定値を表すのに = を使えます。

### X で値の切り替えを表せます。

X は時間が進みます。イメージ的には X= のように働きます。

```nohighlight
clk  _~_~_~_~_~
data =X=X=X=X=X
```

```tchart2svg
clk  _~_~_~_~_~
data =X=X=X=X=X
```

### 信号定義に文字列を書き入れることができます。

文字列を書いても時間は進みません。

```nohighlight
clk    _~_~_~_~_~_~_~_~_~
enable ___~~~~~~~~~~_____
output ---=D0=X=D1X=D2X=D3X=D4-----
```

```tchart2svg
clk    _~_~_~_~_~_~_~_~_~
enable ___~~~~~~~~~~_____
output ---=D0=X=D1X=D2X=D3X=D4-----
```

### 文字列に特殊文字を含めたい場合には " " でくくります
### " を含めたければ "" のように重ねます

スペースも入れられます

```nohighlight
"="   -======"A = B"-
"     -======" ""A"" = ""B"" "-
A     -======A-
space -======"A      "-
```

```tchart2svg
"="   -======"A = B"-
"     -======" ""A"" = ""B"" "-
A     -======A-
space -======"A      "-
```

### 右寄せ、左寄せ

文字列は通常センタリングされますが、_<_ あるいは _>_ から始めることで
左寄せ、右寄せにできます

```nohighlight
left   -======"_<_DATA"-
middle -======DATA-
right  -======"_>_DATA"-
```

```tchart2svg
left   -======"_<_DATA"-
middle -======DATA-
right  -======"_>_DATA"-
```

### ? を一文字だけ書くと不定値を表すために色が付きます。

```nohighlight
clk    _~_~_~_~_~_~
data   =?==XDATA=====X=?=
valid  ___~~~~~~___
```

```tchart2svg
clk    _~_~_~_~_~_~
data   =?==XDATA=====X=?=
valid  ___~~~~~~___
```

### : を入れると空白を入れ、途切れさせることができます。

```nohighlight
clk    _~_~_~_:...:~_~_~_~_~
data   ___~~~~:...:~~____~~_
```

```tchart2svg
clk    _~_~_~_:...:~_~_~_~_~
data   ___~~~~:...:~~____~~_
```

### 不定値部分を表すのに、/ \ * が使えます。

```nohighlight
clk        _~_~_~_~_~_~_~
rising     ___==/=/=~~~~~
falling    ~~~==\=\=_____
transition ___=D0=*=D1*=D2*=D3___
```

```tchart2svg
clk        _~_~_~_~_~_~_~
rising     ___==/=/=~~~~~
falling    ~~~==\=\=_____
transition ___=D0=*=D1*=D2*=D3___
```

### | を入れるとグリッド線を引けます。

###

```nohighlight
clk    _~_~_~_~_~_~_~_~_~
data   ___~~~~~~~~|____~~_
enable ___[~~~~~~~~~~]_____
output ---~~~~~~~~__-----
```

```tchart2svg
clk    _~_~_~_~_~_~_~_~_~
data   ___~~~~~~~~|____~~_
enable ___[~~~~~~~~~~]_____
output ---~~~~~~~~__-----
```

### 全ての組み合わせを試してみます

```nohighlight
# :-~_=/\X*
0 _~_~_~_~_~_~_[~_~_]~_

1 :::-:~:_:=:/:\:X:*:
2 -:---~-_-=-/-\-X-*-
3 ~:~-~~~_~=~/~\~X~*~
4 _:_-_~___=_/_\_X_*_
5 =:=-=|~=_===/=\=X=*=
6 /:/-/~/_/=///\/X/*/
7 \:\-\~\_\=\/\\\X\*\
8 X:X-X~X_X=X/X\XXX*X
9 *:*-*~*_*=*/*\*X***
```

```tchart2svg
# :-~_=/\X*
0 _~_~_~_~_~_~_[~_~_]~_

1 :::-:~:_:=:/:\:X:*:
2 -:---~-_-=-/-\-X-*-
3 ~:~-~~~_~=~/~\~X~*~
4 _:_-_~___=_/_\_X_*_
5 =:=-=|~=_===/=\=X=*=
6 /:/-/~/_/=///\/X/*/
7 \:\-\~\_\=\/\\\X\*\
8 X:X-X~X_X=X/X\XXX*X
9 *:*-*~*_*=*/*\*X***
```

### 不定値の塗り分けをテスト。

```nohighlight
@h_line 30
@h_skip 20
@w_transient 5
@w_caption 60
test =/=?\=\=?/=X=?X=*?=*=X=?-=?= =?X
```

```tchart2svg
@h_line 30
@h_skip 20
@w_transient 5
@w_caption 60
test =/=?\=\=?/=X=?X=*?=*=X=?-=?= =?X
```

### 遷移の傾きをなくすには @w_transient 0 とします

```nohighlight
@w_transient 0
clk _~_~_~_~_~_~_~
data ___|~~~~|_______
```

```tchart2svg
@w_transient 0
clk _~_~_~_~_~_~_~
data ___|~~~~|_______
```

### svg の特殊文字も正しくエスケープされます

```nohighlight
clk _~_~_~_~_~_~_~
data ---|===<D1>=X=<D2>==|---
```

```tchart2svg
clk _~_~_~_~_~_~_~
data ---|===<D1>=X=<D2>==|---
```

### 生成された svg には変換元のソースコードが埋め込まれます。

下記の CDATA の部分です。ソースコードに CDATA の終了を示す ]]> が現れる場合には、
]]&amp;gt; にエンコードされます。

```xml
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
     width="240pt" height="60pt" viewBox="-10 -10 220 40" version="1.1">
<![CDATA[
clk _~_~_~_~_~_~_~
data ---|===<D1>=X=<D2>==|---
]]>
<g>
<text x="35" y="8.5" text-anchor="end" font-size="10" fill="black" font-family="Helvetica">clk</text>
<path stroke-linecap="round" stroke-width="0.6" stroke="black" fill="none" d="M42,10H52L54,0H64L66,10H76L78,0H88L90,10H100L102,0H112L114,10H124L126,0H136L138,10H148L150,0H160L162,10H172L174,0H184L186,10H196L198,0H208" />
<text x="35" y="28.5" text-anchor="end" font-size="10" fill="black" font-family="Helvetica">data</text>
<text x="101.0" y="28.5" text-anchor="middle" font-size="10" fill="black" font-family="Helvetica">&lt;D1&gt;</text>
<text x="149.0" y="28.5" text-anchor="middle" font-size="10" fill="black" font-family="Helvetica">&lt;D2&gt;</text><path stroke-linecap="round" stroke-width="0.6" stroke="black" fill="none" d="M42,25H52H54H64H66H76L78,20H88H90H100H102H112H114H124L126,30H136H138H148H150H160H162H172L174,25H184H186H196H198H208M76,25L78,30H88H90H100H102H112H114H124L126,20H136H138H148H150H160H162H172L174,25" />
<path d="M77,-10V40" stroke-linecap="round" stroke-width="0.6" stroke="red" fill="none" />
<path d="M173,-10V40" stroke-linecap="round" stroke-width="0.6" stroke="red" fill="none" />
</g>
</svg>
```

設定値
----------------

括弧内が何も指定しないときの既定値です。

### scale (= 1.0)

図のサイズを拡大・縮小します。
複数指定した場合、最後の値だけが意味を持ちます。

```nohighlight
@scale 1.4
clk     _~_~_~_~_~_~_~_~
data	==?=X=D0X=D1X=D2X=D3X=?===
```

```tchart2svg
@scale 1.4
clk     _~_~_~_~_~_~_~_~
data	==?=X=D0X=D1X=D2X=D3X=?===
```

```nohighlight
@scale 0.7
clk     _~_~_~_~_~_~_~_~
data	==?=X=D0X=D1X=D2X=D3X=?===
```

```tchart2svg
@scale 0.7
clk     _~_~_~_~_~_~_~_~
data	==?=X=D0X=D1X=D2X=D3X=?===
```

### margin (= 10)
チャートの周囲の余白の幅を指定します。

### w_caption (= 40)
信号名称部分の幅を指定します。

```nohighlight
long_signal_name	_~~~~__~~~~______~~___
```

```tchart2svg
long_signal_name	_~~~~__~~~~______~~___
```

```nohighlight
@w_caption 100
long_signal_name	_~~~~__~~~~______~~___
```

```tchart2svg
@w_caption 100
long_signal_name	_~~~~__~~~~______~~___
```

### w_hold (= 10)

信号の単位時間から遷移時間を引いた部分の幅を指定します。
途中で変更すれば異なるクロックドメインを表したりできます。

```nohighlight
@w_hold 10
clock	_~_~_~_~_~_~_~_~_~_~_~
@w_hold 22
clock	~_~_~_~_~_~
@w_hold 16
clock	_~_~_~_~_~_~_~_
```

```tchart2svg
@w_hold 10
clock	_~_~_~_~_~_~_~_~_~_~_~
@w_hold 22
clock	~_~_~_~_~_~
@w_hold 16
clock	_~_~_~_~_~_~_~_
```

### w_transient (= 2)

信号の遷移時間の幅を指定します。
ゼロを指定すると、遷移のエッジは垂直になります。

```nohighlight
@w_transient 0
clock	_~_~_~_~_~_~_~_~_~_~_~
@w_transient 2
clock	_~_~_~_~_~_~_~_~_~_~_~
@w_transient 4
clock	_~_~_~_~_~_~_~_~_~_~_~
```

```tchart2svg
@w_transient 0
clock	_~_~_~_~_~_~_~_~_~_~_~
@w_transient 2
clock	_~_~_~_~_~_~_~_~_~_~_~
@w_transient 4
clock	_~_~_~_~_~_~_~_~_~_~_~
```

### h_line (= 10)
１行の高さを指定します。信号名のフォントサイズもこの値に等しくなります。

```nohighlight
@h_line 10
clock	_~_~_~_~_~_~_~_~_~_~_~
@h_line 16
clock	_~_~_~_~_~_~_~_~_~_~_~
```

```tchart2svg
@h_line 10
clock	_~_~_~_~_~_~_~_~_~_~_~
@h_line 16
clock	_~_~_~_~_~_~_~_~_~_~_~
```

### h_space (= 10)

行間のスペースを指定します。

```nohighlight
clock	_~_~_~_~_~_~_~_~_~_~_~
data1	_~~~~__~~~~______~~___
@h_space 20
data2	_~~~~__~~~~______~~___
data3	_~~~~__~~~~______~~___
```

```tchart2svg
clock	_~_~_~_~_~_~_~_~_~_~_~
data1	_~~~~__~~~~______~~___
@h_space 20
data2	_~~~~__~~~~______~~___
data3	_~~~~__~~~~______~~___
```

### signal_style

信号線のスタイルを svg の path の属性値の形で与えます。
規定値は次の通りです。

```nohighlight
stroke-linecap="round" stroke-width="0.6" stroke="black" fill="none"

data1	_~~~~__~~~~______~~___
@signal_style stroke-linecap="round" stroke-width="2" stroke="green" fill="none"
data2	_~~~~__~~~~______~~___
```

```tchart2svg
data1	_~~~~__~~~~______~~___
@signal_style stroke-linecap="round" stroke-width="2" stroke="green" fill="none"
data2	_~~~~__~~~~______~~___
```

### grid_style
グリッド線のスタイルを svg の path の属性値の形で与えます。
規定値は次の通りです。

```nohighlight
stroke-linecap="round" stroke-width="0.6" stroke="red" fill="none"
```

```nohighlight
 @grid_style stroke-linecap="round" stroke-width="0.6" stroke="black" fill="none"
 data1	_~~~~__|~~~~______~~___
 @grid_style stroke-linecap="round" stroke-width="0.6" stroke="#0CC" fill="none"
 data2	_~~~~__~~~~______|~~___
```

```tchart2svg
@grid_style stroke-linecap="round" stroke-width="0.6" stroke="black" fill="none"
data1	_~~~~__|~~~~______~~___
@grid_style stroke-linecap="round" stroke-width="0.6" stroke="#0CC" fill="none"
data2	_~~~~__~~~~______|~~___
```

### highlight_style
ハイライト部分のスタイルを指定します。

規定値は次の通りです。

```nohighlight
stroke="none" fill="#ff8"
```

```nohighlight
 data1	_~~~~__[~~~~]______~~___
 @highlight_style stroke="green" fill="#8f8" stroke-width="1"
 data2	_~~~~__~~~~______[~~]___
```

```tchart2svg
data1	_~~~~__[~~~~]______~~___
@highlight_style stroke="green" fill="#8f8" stroke-width="1"
data2	_~~~~__~~~~______[~~]___
```

### notcare_style

不定値部分のスタイルを指定します。

規定値は次の通りです。

```nohighlight
fill="#ccc"
```

```nohighlight
clk     _~_~_~_~_~_~_~_~_~_~_~
data1	====?=*========*=?======
@notcare_style stroke="none" fill="#8f8"
data1	====?=*========*=?======
```

```tchart2svg
clk     _~_~_~_~_~_~_~_~_~_~_~
data1	====?=*========*=?======
@notcare_style stroke="none" fill="#8f8"
data1	====?=*========*=?======
```

### caption_font

信号名のフォントを指定します。

規定値は次の通りです。

```nohighlight
fill="black" font-family="Helvetica"
```

```nohighlight
clk     _~_~_~_~_~_~_~_~_~_~_~
@caption_font fill="red" font-family="Helvetica"
@signal_style stroke="red" fill="none"
data	_~~~~______~~____~~~~~
```

```tchart2svg
clk     _~_~_~_~_~_~_~_~_~_~_~
@caption_font fill="red" font-family="Helvetica"
@signal_style stroke="red" fill="none"
data	_~~~~______~~____~~~~~
```

### signal_font

信号部分で用いるフォントを指定します。

規定値は次の通りです。

```nohighlight
fill="black" font-family="Helvetica"
```

```nohighlight
clk     _~_~_~_~_~_~_~_~
@signal_font fill="red" font-family="Helvetica"
data	==?=X=D0X=D1X=D2X=D3X=?===
```

```tchart2svg
clk     _~_~_~_~_~_~_~_~
@signal_font fill="red" font-family="Helvetica"
data	==?=X=D0X=D1X=D2X=D3X=?===
```

### rotate (= 0)

未実装
