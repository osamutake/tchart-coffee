'strict'
spawnSync = require('child_process').spawnSync
fs = require('fs')

tchart2svg = (args, stdin = '')->
  child = spawnSync('src/tchart2svg', args, {
    input: stdin,
    timeout: 5000
  })

describe 'tchart2svg', ->

  for option in ['-v', '--version']
    do (option)->
      it "shows version with option #{option}", ->
        child = tchart2svg([option])
        expect(child.stderr.toString()).toBe('')
        expect(child.status).not.toBe(0)
        expect(child.stdout).toMatch(/v\d+\.\d+\.\d+/)

  for option in ['-h', '--help']
    do (option)->
      it "shows help with option #{option}", ->
        child = tchart2svg([option])
        expect(child.stderr.toString()).toBe('')
        expect(child.status).not.toBe(0)
        expect(child.stdout).toMatch(/^Usage/)

  it 'converts stdin to stdout', ->
    name = 'neglects comment line'
    input = fs.readFileSync("spec/fixture/#{name}.tchart").toString()
    expectation = fs.readFileSync("spec/expectation/#{name}.svg").toString()
    child = tchart2svg([], input)
    expect(child.stderr.toString()).toBe('')
    expect(child.status).toBe(0)
    expect(child.stdout.toString()).toBe(expectation)

  it 'converts file to stdout', ->
    name = 'neglects comment line'
    expectation = fs.readFileSync("spec/expectation/#{name}.svg").toString()
    child = tchart2svg(["spec/fixture/#{name}.tchart"])
    expect(child.stderr.toString()).toBe('')
    expect(child.status).toBe(0)
    expect(child.stdout.toString()).toBe(expectation)

  it 'converts files to stdout', ->
    srcs = fs.readdirSync('spec/fixture').
              filter( (s)-> /.*\.tchart$/.exec(s) ).
              sort( (a,b)-> if a<b then -1 else if b>a then 1 else 0 )
    child = tchart2svg(srcs.map( (s)-> 'spec/fixture/' + s))
    expect(child.stderr.toString()).toBe('')
    expect(child.status).toBe(0)

    expectation = srcs.map( (s)->
      name = 'spec/expectation/' + s.replace(/\.tchart$/, '.svg')
      fs.readFileSync(name).toString()
    )
    result = child.stdout.toString().split("</svg>\n").map((s) -> s + "</svg>\n")

    errors = (i for src, i in srcs when result[i] != expectation[i])

    html = fs.readFileSync('src/doc/test-result.html.src').toString()
    html = html.replace('<%=result%>',
      if errors.length == 0
        "<h1 class=\"success\">Test Passed!</h1>"
      else
        "<h1 class=\"fail\">Test Failed!</h1>\n" +
        "<p>If you don't see any problems below, " +
        "run 'rake test:expectation' to update the expected result.\n" +
        errors.map( (i)->
          title = srcs[i].replace(/\.tchart$/, '')
          tchart = fs.readFileSync('spec/fixture/' + srcs[i]).toString().replace(/\n/g, "<br>\n")
          "<h2>#{title}</h2>\n" +
          "<div class='row'><div>#{tchart}</div>" +
          "<div>#{expectation[i]}</div><div>#{result[i]}</div></div>\n"
        ).join('')
    )
    fs.writeFileSync 'doc/test-result.html', html

    if errors.length > 0
      message = errors.map((i)->"Difference detected for '#{srcs[i]}'\n").join('')
      throw new Error(message)

  for option in ['-o', '--output']
    do (option)->
      it "converts file to file with #{option}", ->
        name = 'neglects comment line'
        child = tchart2svg(["spec/fixture/#{name}.tchart", option, "tmp/#{name}.svg"])
        expect(child.stderr.toString()).toBe('')
        expect(child.status).toBe(0)

        expectation = fs.readFileSync("spec/expectation/#{name}.svg").toString()
        result = fs.readFileSync("tmp/#{name}.svg").toString()
        expect(result).toBe(expectation)

        fs.unlinkSync("tmp/#{name}.svg")

  for option in ['-o', '--output']
    do (option)->
      it "converts stdin to file with #{option}", ->
        name = 'neglects comment line'
        input = fs.readFileSync("spec/fixture/#{name}.tchart").toString()
        child = tchart2svg([option, "tmp/#{name}.svg"], input)
        expect(child.stderr.toString()).toBe('')
        expect(child.status).toBe(0)

        expectation = fs.readFileSync("spec/expectation/#{name}.svg").toString()
        result = fs.readFileSync("tmp/#{name}.svg").toString()
        expect(result).toBe(expectation)

        fs.unlinkSync("tmp/#{name}.svg")

  for option in ['-d', '--output-dir']
    do (option)->
      it "converts files to files with #{option}", ->
        name1 = 'neglects comment line'
        name2 = 'all combinations'
        child = tchart2svg([option, 'tmp', "spec/fixture/#{name1}.tchart", "spec/fixture/#{name2}.tchart"])
        expect(child.stderr.toString()).toBe('')
        expect(child.status).toBe(0)

        expectation = fs.readFileSync("spec/expectation/#{name1}.svg").toString()
        result = fs.readFileSync("tmp/#{name1}.svg").toString()
        expect(result).toBe(expectation)

        expectation = fs.readFileSync("spec/expectation/#{name2}.svg").toString()
        result = fs.readFileSync("tmp/#{name2}.svg").toString()
        expect(result).toBe(expectation)

        fs.unlinkSync("tmp/#{name1}.svg")
        fs.unlinkSync("tmp/#{name2}.svg")

  for option in ['-e', '--output-ext']
    do (option)->
      it "converts files to files with specified file extention by #{option}", ->
        name1 = 'neglects comment line'
        name2 = 'all combinations'
        child = tchart2svg([option, 'SVG', '-d', 'tmp', "spec/fixture/#{name1}.tchart", "spec/fixture/#{name2}.tchart"])
        expect(child.stderr.toString()).toBe('')
        expect(child.status).toBe(0)

        expectation = fs.readFileSync("spec/expectation/#{name1}.svg").toString()
        result = fs.readFileSync("tmp/#{name1}.SVG").toString()
        expect(result).toBe(expectation)

        expectation = fs.readFileSync("spec/expectation/#{name2}.svg").toString()
        result = fs.readFileSync("tmp/#{name2}.SVG").toString()
        expect(result).toBe(expectation)

        fs.unlinkSync("tmp/#{name1}.SVG")
        fs.unlinkSync("tmp/#{name2}.SVG")

  it 'draws grids with --grid', ->
    name = 'neglects comment line'
    input = fs.readFileSync("spec/fixture/#{name}.tchart").toString()
    child = tchart2svg(['--grid', 'on'], input)
    expect(child.stderr.toString()).toBe('')
    expect(child.status).toBe(0)

    expectation = fs.readFileSync("spec/expectation/#{name}.svg").toString()
    expect(child.stdout.toString()).not.toBe(expectation)

    expectation = fs.readFileSync("spec/expectation/#{name} --grid on.svg").toString()
    expect(child.stdout.toString()).toBe(expectation)
