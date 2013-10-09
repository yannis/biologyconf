window.bio14 ||= {}
bio14.home =
  setSectionHeights: ->
    windowHeight = $(window).height()
    navHeight = $("#application-navigation").height()
    heightToSet = windowHeight-navHeight
    # console.log "windowHeight", windowHeight
    # console.log "navHeight", navHeight
    # console.log "heightToSet", heightToSet
    $(".home-section").css "min-height", heightToSet
    $('[data-spy="scroll"]').each ->
      $(@).scrollspy('refresh')


$ ->
  $(".carousel").carousel()
  bio14.home.setSectionHeights()
