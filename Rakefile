require 'rake/clean'

task :default => [:obj, 'lib/tchart.min.js', 'bin/editor.html', 'bin/editor-offline.html']

directory 'obj'

uglify = "node_modules/.bin/uglifyjs"

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
