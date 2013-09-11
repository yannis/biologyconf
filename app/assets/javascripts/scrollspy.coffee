window.bio14 ||= {}
bio14.scroll =
  set: ->
    $("nav .nav a").on 'click', (event) ->
      target = $(@).attr('data-target')
      console.log 'target', target
      event.preventDefault()
      $('html, body').animate(
        scrollTop: $(target)
      , 300)


      # if $(@).data('target').length
      #   taget = @.data('target')
      #   console.log 'target', target


$ ->
  bio14.scroll.set()
