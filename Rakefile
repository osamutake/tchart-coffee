require 'rake/clean'

uglify = "node_modules/.bin/uglifyjs"

# =========================================== :default = :all

task :default => :all

task :all => [
    :preparation,
    :lib,
    :editor,
    :doc,
    :test
]

# =========================================== :preparation

task :preparation => ['.git/hooks/pre-commit', :obj]

file '.git/hooks/pre-commit' do
  sh 'echo "#!/bin/sh\\nrake\\n" > .git/hooks/pre-commit'
  sh 'chmod u+x .git/hooks/pre-commit'
end

directory 'obj'

# =========================================== :lib

task :lib => 'lib/tchart.min.js'

file 'lib/tchart.min.js' => 'lib/tchart.js' do |t|
  src = t.prerequisites[0]
  out = t.name
  out_name = out.sub(/^[^\/]*\//, '')
  sh "#{uglify} #{src} -c " +
        "--in-source-map #{src}.map " +
        "--source-map #{out}.map " +
        "--source-map-url #{out_name}.map " +
        "-o #{out} --mangle all --comments"

  # why is the following replacement required?
  sh %q(sed -i -E 's/"sources":\\["\\.\\.\\//"sources":["/' ) +
      "#{out}.map"
end

file 'lib/tchart.js' => 'src/tchart.coffee' do |t|
  src = t.prerequisites[0]
  out = t.name
  sh "coffee -cm -o lib #{src}"
end

# =========================================== :editor

task :editor => [:lib, 'bin/editor.html', 'bin/editor-offline.html']

file 'bin/editor.html' => [
  'src/editor/editor.html.src', 'bin/editor.css', 'bin/editor.js'] do |t|
    src = t.prerequisites[0]
    scss = t.prerequisites[1]
    coffee = t.prerequisites[2]
    sh "(cat #{src};" +
      %q(echo '<link rel="stylesheet" type="text/css" href="editor.css">';) +
      %q(echo '<script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>';) +
      %q(echo '<script src="https://rawgit.com/eligrey/FileSaver.js/master/FileSaver.min.js"></script>';) +
      %q(echo '<script src="https://rawgit.com/eligrey/canvas-toBlob.js/master/canvas-toBlob.js"></script>';) +
      %q(echo '<script src="../lib/tchart.min.js"></script>';) +
      %q(echo '<script src="editor.js"></script>') +
      ")>bin/editor.html"
end

file 'bin/editor-offline.html' => [
          'src/editor/editor.html.src', 'bin/editor.css', 'obj/editor.min.js', 'lib/tchart.min.js',
          'obj/jquery.min.js', 'obj/FileSaver.min.js', 'obj/canvas-toBlob.min.js'] do |t|
  src = t.prerequisites[0]
  scss = t.prerequisites[1]
  coffee = t.prerequisites[2]
  sh "(cat #{src};" +
    "echo '<style>'; cat bin/editor.css; echo '</style>';" +
    "echo '<script>'; cat obj/jquery.min.js; echo '</script>';" +
    "echo '<script>'; cat obj/FileSaver.min.js; echo '</script>';" +
    "echo '<script>'; cat obj/canvas-toBlob.min.js; echo '</script>';" +
    "echo '<script>'; cat lib/tchart.min.js; echo '</script>';" +
    "echo '<script>'; cat obj/editor.min.js; echo '</script>') " +
    ">bin/editor-offline.html"
end

file 'bin/editor.css' => 'src/editor/editor.scss' do
  sh 'scss --compass src/editor/editor.scss bin/editor.css'
end

file 'bin/editor.js' => 'src/editor/editor.coffee' do
  sh "coffee -c -o bin src/editor/editor.coffee"
end

file 'obj/editor.min.js' => 'bin/editor.js' do
  sh "#{uglify} bin/editor.js -o obj/editor.min.js --mangle all"
end

file 'obj/jquery.min.js' do
  sh "wget https://code.jquery.com/jquery-2.1.4.min.js -O obj/jquery.min.js"
end

file 'obj/FileSaver.min.js' do
  sh "wget https://rawgit.com/eligrey/FileSaver.js/master/FileSaver.min.js -O obj/FileSaver.min.js"
end

file 'obj/canvas-toBlob.min.js' => 'obj/canvas-toBlob.js' do
  sh "#{uglify} obj/canvas-toBlob.js -o obj/canvas-toBlob.min.js --mangle all"
end

file 'obj/canvas-toBlob.js' do
  sh "wget https://rawgit.com/eligrey/canvas-toBlob.js/master/canvas-toBlob.js -O obj/canvas-toBlob.js"
end

# =========================================== :doc

DOCS = FileList['src/doc/*.md'].pathmap('doc/%n.html')
task :doc => DOCS + ['doc/example.svg']

file 'doc/example.svg' => 'src/doc/example.svg' do
  sh 'cp src/doc/example.svg doc/example.svg'
end

require 'json'
version = 'v' + JSON.load(File.read 'package.json')['version']

require 'erb'
require 'redcarpet'
DOCS.each do |doc|
  file doc => [doc.pathmap('src/doc/%n.md'), 'src/doc/layout.html.erb', 'package.json'] do |t|
    puts "generating #{t.name} from #{t.prerequisites[0]}"
    src = File.read t.prerequisites[0]
    toc = Redcarpet::Markdown.new(
            Redcarpet::Render::HTML_TOC).render(src)
    document = Redcarpet::Markdown.new(
            Redcarpet::Render::HTML.new,
            fenced_code_blocks: true).render(src)
    document.gsub!('&lt;%=version%&gt;', version)
    html = ERB.new(File.read t.prerequisites[1]).result(binding)
    File.write t.name, html
  end
end

# =========================================== :test

task :test => 'doc/test-result.html'

file 'doc/test-result.html' => 'lib/tchart.min.js' do
  RED_COLOR="\033[31m"
  GREEN_COLOR="\033[32m"
  RST_COLOR="\033[0m"

  result = ''
  success = 0
  fail = 0
  Dir.glob "spec/fixture/*.tchart" do |file|
    src = File.read file
    svg = `node -e "console.log(require('./lib/tchart.min.js').format(require('fs').readFileSync('#{file}').toString()))"`
    expect_file = file.pathmap('spec/expectation/%n.svg')
    unless File.exist? expect_file
      puts "#{RED_COLOR}File not found: '#{expect_file}'"
      puts
      puts "You may need to run 'rake test:expectation'.#{RST_COLOR}"
      exit 1
    end
    expect = File.read file.pathmap('spec/expectation/%n.svg')
    if svg == expect
      success += 1
    else
      fail += 1
      result += "<h2>#{file.pathmap('%n')}</h2>\n" +
                "<div class='row'><div>#{src.gsub(/\n/,'<br>')}</div>" +
                "<div>#{expect}</div><div>#{svg}</div></div>\n"
      puts "#{RED_COLOR}Test failed:#{RST_COLOR} '#{file}'"
    end
  end
  puts "#{fail==0 ? GREEN_COLOR : RED_COLOR}#{success+fail} tests, #{fail} failures#{RST_COLOR}"

  html = File.read 'src/doc/test-result.html.src'
  if fail == 0
    File.write 'doc/test-result.html', html.sub('<%=result%>', '<h1 class="success">Test Passed!</h1>')
  else
    File.write 'doc/test-result.html',
      '<h1 class="fail">Test Failed!</h1>' +
      "<p>If you don't see any problems below, run 'rake test:expectation' to update the expected result." +
      html.sub('<%=result%>', result)
    puts
    puts "#{RED_COLOR}Check result in 'doc/test-result.html'."
    puts "If you don't see any problems there, run 'rake test:expectation' to update the expected result.\n#{RST_COLOR}"
    exit 1
  end

  sh 'node_modules/.bin/jasmine-node --coffee spec'
end

# =========================================== 'test:expectation'

task 'test:expectation' => 'doc/expectations.html'

task 'doc/expectations.html' => 'spec/expectation' do
  result = ''
  Dir.glob "spec/fixture/*.tchart" do |file|
    src = File.read file
    svg = `node -e "console.log(require('./lib/tchart.js').format(require('fs').readFileSync('#{file}').toString()))"`
    File.write file.pathmap('spec/expectation/%n.svg'), svg
    result += "<h2>#{file.pathmap('%n')}</h2>\n" +
              "<div class='row'><div>#{src.gsub(/\n/,'<br>')}</div>" +
              "<div>#{svg}</div></div>\n"
  end

  html = File.read 'src/doc/expectations.html.src'
  File.write 'doc/expectations.html', html.sub('<%=result%>', result)
end

directory 'spec/expectation'
