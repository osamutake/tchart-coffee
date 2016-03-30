class SvgPath
  constructor: (style)->
    @segments = []
    @style = style

  # we assume x1 <= x2
  draw: (x1, y1, x2, y2)->
    # drop empty segment
    @segments.push([x1,y1,x2,y2])

  connectSegments: ->
    for s1 in @segments
      s1[4]= null   # points next segment
      s1[5]= null   # points prev segment
      for s2 in @segments
        if s1[2]==s2[0] and s1[3]==s2[1]
          s1[4] = s2
          s2[5] = s1
          break

    # higher priority for non-ending segments
    for s1 in @segments
      # connected to an end segment
      if s1[4] and !s1[4][4]
        for s2 in @segiments
          if s1[2]==s2[0] and s1[3]==s2[1] and s2[4] and !s2[5]
            s1[4][5]=null
            s1[4]=s2
            s2[5]=s1
            break
      # connected from an end segment
      if s1[5] and !s1[5][5]
        for s2 in @segiments
          if s2[2]==s1[0] and s2[3]==s1[1] and s2[5] and !s2[4]
            s1[5][4]=null
            s1[5]=s2
            s2[4]=s1
            break

  svg: ->
    path = []
    for s1 in @segments
      continue if s1[5] # connected from other segment
      s = s1
      cx = s[0]
      cy = s[1]
      path.push "M#{cx},#{cy}"
      while s
        if cx == s[2] && cy == s[3]
          # should not occur
        else if cx == s[2]
          if path[path.length-1][0]=='V'
            path[path.length-1]= "V#{s[3]}"
          else
            path.push "V#{s[3]}"
        else if cy == s[3]
          if path[path.length-1][0]=='H'
            path[path.length-1]= "H#{s[2]}"
          else
            path.push "H#{s[2]}"
        else
          path.push "L#{s[2]},#{s[3]}"
        cx = s[2]
        cy = s[3]
        s = s[4]  # next segment

    """<path #{@style} d="#{path.join('')}" />\n"""

class TimeLine
  # lines for transitions from ? to ?
  # definitions for charactors are given
  # by @transitionLines
  #
  #  12 - ~ _ / ` X =
  #  43
  #
  #  : - ~ _ = from
  @transitions = [# to
    '          ', # :
    '  - 1 4 14', # -
    '  2 ~ / ~/', # ~
    '  3 ` _ _`', # _
    '  23`~/_= ', # =
    '  23`~/_=/', # /
    '  23`~/_=`', # \
    '  23`~/_X ', # X
    '  23`~/_=X', # *
  ]

  # all the numbers are y-coordinates ranging
  # from 0 (bottom) to 1 (top).
  @transitionLines =
    ' ' : []
    '~' : [[1,1]]
    '_' : [[0,0]]
    '=' : [[1,1],[0,0]]
    'X' : [[1,0],[0,1]]
    '`' : [[1,0]]
    '/' : [[0,1]]
    '1' : [[1,0.5]]
    '2' : [[0.5,1]]
    '3' : [[0.5,0]]
    '4' : [[0,0.5]]
    '-' : [[0.5,0.5]]

  # lines for hold part:
  # all the numbers are y-coordinates ranging
  # from 0 (bottom) to 1 (top).
  #
  #                :  -     ~   _   =
  @stateLines = [[],[0.5],[1],[0],[0,1]]

  #
  @codes = ':-~_=/\\X*'

  constructor: (config, y)->
    @config = config
    @x = config.w_caption
    @y = y
    @path = new SvgPath(config.signal_style)
    @current = 0
    @crosses = []
    @strings = []
    @grids   = []
    @highlights = []

  ys: (s)-> @y + (1-s) * @config.h_line
  y0: -> @ys(0)
  y1: -> @ys(1)
  yz: -> @ys(0.5)

  xh: -> @x + @config.w_transient/2.0
  xt: -> @x + @config.w_transient
  xr: -> @x + @config.w_transient + @config.w_hold

  parse: (line)->
    while line.length > 0
      if maches = /^\s+/.exec(line)
        ;
      else if maches = /^\|/.exec(line)
        @grids.push [@xh(), @config.grid_style]
      else if maches = /^\[/.exec(line)
        if @highlights.length==0 or Array.isArray(@highlights[@highlights.length-1])
          @highlights.push @xh()
      else if maches = /^\]/.exec(line)
        if @highlights.length>0 and not Array.isArray(@highlights[@highlights.length-1])
          @highlights[@highlights.length-1] =
            [@highlights[@highlights.length-1], @xh(), @config.highlight_style]
      else if matches = /^([:\-~_=\/\\X*])/.exec(line)
        @addState(matches[1])
      else if matches = /^"(([^"]|"")*)"/.exec(line)
        @addString(matches[1].replace(/""/g, '"').replace(/\ /g, '&nbsp;'))
      else if matches = /^'(([^']|'')*)'/.exec(line)
        @addString(matches[1].replace(/''/g, "'").replace(/\ /g, '&nbsp;'))
      else if matches = /([^:\-~_=\/\\X*\|\]\[]+)/.exec(line)
        @addString(matches[1])
      line = line.substr(matches[0].length, line.length-matches[0].length)

    @processStrings() + @path.svg()

  addState: (c)->
    s = TimeLine.codes.indexOf(c)
    crosses = @drawTransition(s)
    s = 4 if s > 4
    @drawState(s)
    @crosses.push([@x, crosses]) if crosses!=''
    if (@current == 0 and s != 0) or (@current != 0 and s == 0) or
       (@crosses.length==0 and s == 0)
      @crosses.push([@x, '|'])
    @current = s
    @x = @xr()

  addString: (s)->
    @strings.push [@crosses.length, s.replace(/^\s+|\s+$/g, '')]

  drawTransition: (s)->
    crosses = ''
    transitions = TimeLine.transitions[s].substr(2*@current,2)
    for i in [0..transitions.length-1]
      crosses += @drawTransitionSub(transitions[i])
    crosses

  drawTransitionSub: (c)->
    crosses = ''
    for line in TimeLine.transitionLines[c]
      @path.draw(@x,  @ys(line[0]), @xt(), @ys(line[1]))
      crosses += c if line[0] != line[1]
    crosses

  drawState: (s)->
    for line in TimeLine.stateLines[s]
      @path.draw(@xt(), @ys(line), @xr(), @ys(line))

  processStrings: ->
    svg = []
    @crosses.push [@x,'|']
    for string in @strings
      y0 = @ys(0)
      y1 = @ys(1)
      yz = @ys(0.5)
      x1 = @crosses[string[0]-1][0]
      x1t = x1 + @config.w_transient
      x1h = x1 + @config.w_transient/2.0
      x1r = x1t + @config.w_hold
      x2 = @crosses[string[0]  ][0]
      x2t = x2 + @config.w_transient
      x2h = x2 + @config.w_transient/2.0
      x2r = x2t + @config.w_hold

      if string[1]=='?'
        path= ["M#{x1t},#{y1}H#{x2}"]
        path.push switch @crosses[string[0]][1]
          when '|'  then ""
          when 'XX' then "L#{x2h},#{yz}"
          when '/'  then "H#{x2t}"
          when '`'  then "L#{x2t},#{y0}"
          when '23' then "H#{x2t}L#{x2},#{yz}L#{x2t},#{y0}"
          when '14' then "L#{x2t},#{yz}"
          when '1'  then "L#{x2t},#{yz}V#{y0}"
          when '2'  then "H#{x2t}L#{x2},#{yz}"
          when '3'  then "V#{yz}L#{x2t},#{y0}"
          when '4'  then "H#{x2t}V#{yz}"
        path.push "L#{x2},#{y0}H#{x1t}"
        path.push switch @crosses[string[0]-1][1]
          when '|'  then ""
          when 'XX' then "L#{x1h},#{yz}"
          when '/'  then "H#{x1}"
          when '`'  then "L#{x1},#{y1}"
          when '23' then "L#{x1},#{yz}"
          when '14' then "H#{x1}L#{x1t},#{yz}L#{x1},#{y1}"
          when '1'  then "V#{yz}L#{x1},#{y1}"
          when '2'  then "H#{x1}V#{yz}"
          when '3'  then "L#{x1},#{yz}V{y1}"
          when '4'  then "H#{x1}L#{xt},#{yz}"
        path.push "Z"
        svg.push """\n<path stroke="none" d="#{path.join('')}" #{@config.notcare_style}/>"""

      sanitized = string[1].replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
      if string[1].substr(0,3)=='_<_'
        x = x1t
        anchor = 'start'
        sanitized = sanitized.substring(6)
      else if string[1].substr(0,3)=='_>_'
        x = x2
        anchor = 'end'
        sanitized = sanitized.substring(6)
      else
        x = (x1h+x2h)/2.0
        anchor = 'middle'

      svg.push """<text x="#{x}" y="#{@ys(0)-1.5}" text-anchor="#{anchor}" """ +
               """font-size="#{@config.h_line}" #{@config.signal_font}>#{sanitized}</text>\n"""

    svg.join("")

class TimingChart
  @config:
    scale:          1.0
    margin:         10
    w_caption:      40
    w_hold:         10
    w_transient:    2
    h_line:         10
    h_space:        10
    signal_style:   'stroke-linecap="round" stroke-width="0.6" stroke="black" fill="none"'
    grid_style:     'stroke-linecap="round" stroke-width="0.6" stroke="red" fill="none"'
    highlight_style:'stroke="none" fill="#ff8"'
    notcare_style:  'fill="#ccc"'
    rotate:         0
    caption_font:   'fill="black" font-family="Helvetica"'
    signal_font:    'fill="black" font-family="Helvetica"'

  @format = (source, config= {}) ->
    (new TimingChart(config)).parse(source)

  constructor: (config= {})->
    @config= {}
    @setConfig(TimingChart.config)
    @setConfig(config)

  setConfig: (config)->
    @config[k]= v for own k,v of config

  parse: (source)->
    @svg= []
    @grids= []
    @highlights= []
    @y= -1
    @x_max= @config.w_caption
    source= source.replace(/^\n+/, '')
    source= source.replace(/\n+$/, '')
    for line in source.split("\n")
      @parseLine(line)
    @processGrids()
    @processHighlights()
    @formatSVG(source)

  formatSVG: (source)->
    m= @config.margin
    w= (@x_max + 2 * m) * @config.scale * 1.3
    h= (@y     + 2 * m) * @config.scale * 1.3
    @width = w
    @height = h
    @svg = """
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
      width="#{w}px" height="#{h}px" viewBox="#{-m} #{-m} #{@x_max+2*m} #{@y+2*m}" version="1.1">
    <![CDATA[
    #{source.replace(/\]\]\>/g, ']]&gt;')}
    ]]>
    <g>
    #{@svg.join("\n")}
    </g>
    </svg>
    """

  parseLine: (line)->
    return if line[0] == '#'  #### comment

  	isNumeric = (obj)->
  		type = typeof obj
  		( type == "number" or type == "string" ) and
  			     !isNaN( obj - parseFloat( obj ) )

    if line[0]=='@'           #### configuration
      if !(matches = /^@([^\s]+)[\s]+([^\s].*)$/.exec(line))
        throw new SyntaxError("Illegal Line: #{line}")
      if isNumeric(@config[matches[1]])
        @config[matches[1]] = Number(matches[2])
      else
        @config[matches[1]] = matches[2]
      return

    if line[0] == '%'         #### free string
      if !(matches = /^%(-?[\d\.]+)\s+(-?[\d\.]+)\s+?(.*)$/.exec(line))
        throw new SyntaxError("Illegal Line: #{line}")
      @svg.push("""<text x="#{matches[1]}" y="#{matches[2]}" text-anchor="middle" """ +
                """font-size="#{@config.h_line}" #{@config.signal_font}>#{matches[3]}</text>""")
      return

    if @y<0
      @y= 0
    else
      @y+= @config.h_space

    line= line.replace(/\s*$/, '')
    return if line==''        #### empty line

    if !(matches = /^([^\s]+)[\s]+([^\s].*)$/.exec(line))
      throw new SyntaxError("Illegal Line: #{line}")

    @formatCaption(matches[1])
    @formatTimeline(matches[2])
    @y+= @config.h_line

  formatCaption: (caption)->
    sanitized = caption.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
    @svg.push(
      """<text x="#{@config.w_caption-5}" y="#{@y+@config.h_line-1.5}" text-anchor="end" """+
      """font-size="#{@config.h_line}" #{@config.caption_font}>#{sanitized}</text>"""
    )

  formatTimeline: (line)->
    tline= new TimeLine(@config, @y)
    @svg.push tline.parse(line)
    @x_max= tline.x if tline.x > @x_max
    for g in tline.grids
      @grids.push g
    for h in tline.highlights
      @highlights.push h

  processGrids: ->
    t = -@config.margin/2.0
    b = @y+@config.margin/2.0
    for g in @grids
      @svg.push """<path d="M#{g[0]},#{t}V#{b}" #{g[1]} />"""

  processHighlights: ->
    t = -@config.margin/2.0
    b = @y+@config.margin/2.0
    for h in @highlights
      if Array.isArray(h)
        @svg.unshift """<path d="M#{h[0]},#{t}V#{b}H#{h[1]}V#{t}Z" #{h[2]} />"""

if module?.exports?
  module.exports = TimingChart
else
  this.TimingChart = TimingChart
