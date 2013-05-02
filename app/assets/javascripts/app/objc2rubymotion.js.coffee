$().ready ->
  objc = $('.objc textarea')
  rubymotion = $('.rubymotion pre')

  convert = ()->
    converter = new Converter objc.val()
    rubymotion.html converter.result()

  convert()

  $('.objc textarea').bind 'input propertychange', ->
    convert()
