window.bio14 ||= {}
bio14.navigation =
  set: ->
    $("nav .nav a, .jumbotron a").on 'click', (event) ->
      event.preventDefault()
      target = $(@).attr('data-target')
      console.log 'target', target
      targetPosition = $(target).position()
      $('html, body').animate({scrollTop: targetPosition.top-60}, "slow")
    @scrollSpy()

  scrollSpy: ->
    $('body').scrollspy
      target: "#application-navigation"
      offset: +100


      # if $(@).data('target').length
      #   taget = @.data('target')
      #   console.log 'target', target


$ ->
  bio14.navigation.set()
