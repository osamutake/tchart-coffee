lastSource = ''
lastChart = null
update = ->
  source = $('#source').val()
  return if lastSource==source
  lastSource = source

  lastChart= new TimingChart()
  svg= lastChart.parse(source)
  $('#result').html(svg)

callbackWithCanvas = (f)->
    canvas = document.createElement('canvas')
    canvas.width = lastChart.width
    canvas.height = lastChart.height
    # http://nmi.jp/archives/223
    img = new Image()
    img.onload = ->
      ctx = canvas.getContext("2d")
      ctx.fillStyle = $('#background').val()
      ctx.fillRect(0, 0, canvas.width, canvas.height)
      ctx.drawImage(img, 0, 0, canvas.width, canvas.height)
      f(canvas)
    img.src = "data:image/svg+xml;base64," + btoa(lastChart.svg)

$ ->
  setInterval(update, 100)

  $('#as_svg').on 'click', ->
    update()
    blob = new Blob([lastChart.svg], {type: "image/svg+xml"});
    saveAs(blob, 'timing-chart.svg')

  $('#as_png').on 'click', ->
    update()
    callbackWithCanvas (canvas)->
      canvas.toBlob (blob)->
        saveAs(blob, "timing-chart.png")

  $('#for_copy').on 'click', ->
    $('#images>*').remove()
    update()

    $('#images').append $('<h2>').html('SVG Source')

    textarea = $('<textarea cols="60" rows="3">').val(lastChart.svg)
    $('#images').append textarea
    textarea.focus()
    textarea.select()

    $('#images').append $('<h2>').html('PNG Image')
    callbackWithCanvas (canvas)->
      $('#images').append $('<img>').attr('src', canvas.toDataURL())
