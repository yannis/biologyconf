window.bio14 ||= {}
bio14.parallax =
  start: ->
    $(window).scroll ->
      scrollTop = $(window).scrollTop()
      windowHeight = $(window).height()

      if $("#program").length
        programOffset = $("#program").offset().top
        speakersOffset = $("#speakers").offset().top
        registrationOffset = $("#registration").offset().top
        venueOffset = $("#venue").offset().top
        pace14Offset = $("#pace14").offset().top

        if (scrollTop+windowHeight) > programOffset
          $("#program").css("background-position", "#{150-scrollTop/20}% #{-50+(scrollTop/20)}%")
        if (scrollTop+windowHeight) > speakersOffset
          $("#speakers").css("background-position", "#{10+((scrollTop-speakersOffset)/20)}% #{windowHeight-$(window).width()*0.7+(scrollTop+windowHeight-speakersOffset)/1.5}px")
        if (scrollTop+windowHeight) > venueOffset
          $("#venue").css("background-position", "#{10+((scrollTop-venueOffset)/20)}% #{windowHeight-$(window).width()*0.7+(scrollTop+windowHeight-venueOffset)/1.5}px")
          $("#venue").css("background-size", "#{60+((scrollTop-venueOffset)/100)}%")
        if (scrollTop+windowHeight) > registrationOffset
          $("#registration").css("background-position", "0 #{-$(window).width()*0.7+(scrollTop+windowHeight-registrationOffset)/1.5}px")
        if (scrollTop+windowHeight) > pace14Offset
          $("#pace14").css("background-position", "#{100-((scrollTop-pace14Offset)/10)}% #{windowHeight/2-(scrollTop-pace14Offset)}px")

$ ->
  bio14.parallax.start() if $("html").hasClass("no-overflowscrolling")
