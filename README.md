# tchart-coffee

Online timing chart formatter that converts a source code of a timing chart into SVG graphics on browsers.

It includes a javascript library and an online visual editor,
which convert a source text like the following

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

![example.svg](https://cdn.rawgit.com/osamutake/tchart-coffee/master/doc/example.svg)


[The detailed description in Japanese is available.](https://cdn.rawgit.com/osamutake/tchart-coffee/master/doc/index.html)
