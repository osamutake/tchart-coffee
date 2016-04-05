Path = require('path')
fs = require('fs')
TimingChart = require('./tchart')

try
  util = require('util')
catch
  util = require('sys')

optionAliases = {
  '-o': '--output',
  '-v': '--version',
  '-h': '--help',
  '-e': '--output-ext',
  '-d': '--output-dir'
}

# =====================

options = {}
inputs = []
output = null
outputDir = null
outputExt = 'svg'

main = ->
  return unless processArgs()

  if inputs.length == 0
    source = ''
    stdin = process.openStdin()
    stdin.on 'data', (chunk)->
      source += chunk if chunk
    stdin.on 'end', ->
      svg = format source
      unless output
        process.stdout.write svg
      else
        output = Path.join(outputDir, output) if outputDir
        fs.writeFileSync output, svg
  else if output
    output = Path.join(outputDir, output) if outputDir
    ws = fs.createWriteStream(output)
    for input in inputs
      ws.write format(fs.readFileSync(input).toString())
  else if outputDir
    for input in inputs
      output = Path.parse(input).name + '.' + outputExt
      output = Path.join(outputDir, output)
      svg = format fs.readFileSync(input).toString()
      fs.writeFileSync output, svg
  else
    for input in inputs
      svg = format fs.readFileSync(input).toString()
      process.stdout.write svg

# =====================

processArgs = ->
  tchart = new TimingChart()

  args = process.argv.slice(2);
  while (arg = args.shift())?
    # alias
    if optionAliases[arg]
      arg = optionAliases[arg]

    if arg.substr(0,2)=='--'
      # options
      name = arg.substr(2).replace('_', '-')
      if name == 'help'
        showHelp()
      else if name == 'version'
        showVersion()

      unless args.length
        throw new Error("No value is given to option '#{arg}'")
      value = args.shift()

      if name == 'output'
        output = value
      else if name == 'output-dir'
        outputDir = value
      else if name == 'output-ext'
        outputExt = value
      else if tchart.config[name.replace('-', '_')]
        options[name.replace('-', '_')] = value
      else
        throw new Error("Irregal option '--#{name}' is specified.")
    else
      # input
      inputs.push arg
  return true


format = (source)->
  TimingChart.format(source, options) + "\n"


showHelp = ->
  process.stdout.write """
  Usage: tchart2svg [options] source1 [source2, ...]

  options:
    -o, --output     - file name to store the result
    -d, --output-dir - directory to store the result
    -e, --output-ext - output file extention (default 'svg')
    -v, --version    - show the current version
    -h, --help       - display this help and exit

    --scale
    --margin
    --w-caption
    --w-hold
    --w-transient
    --h-line
    --h-space
    --signal-style
    --grid
    --grid-offset
    --grid-step
    --grid-style
    --guide-style
    --highlight_style
    --notcare-style
    --caption-font
    --signal-font

  example:
    tchart2svg sample.tchart -o sample.svg
    tchart2svg sample.tchart -ext svg
    tchart2svg *.tchart --output-dir svg
    tchart2svg sample.tchart --grid on -o sample.svg\n
  """
  process.exit(-1)


showVersion = ->
  version = JSON.parse(fs.readFileSync Path.join(__dirname, '../package.json')).version
  process.stdout.write "v#{version}\n"
  process.exit(-1)

# =====================

if exports?
  exports.run = main
else
  main()
