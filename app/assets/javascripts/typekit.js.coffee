$ ->
  Modernizr.load
    test: Modernizr.fontface
    yep : 'http://use.typekit.com/vea3qwl.js'
    complete: ->
      try
        Typekit.load()
