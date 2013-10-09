window.bio14 ||= {}
bio14.parallax =
  start: ->
    $(window).scroll ->
      scrollTop = $(window).scrollTop()
      windowHeight = $(window).height()

      programOffset = $("#program").offset().top
      speakersOffset = $("#speakers").offset().top
      registrationOffset = $("#registration").offset().top
      venueOffset = $("#venue").offset().top
      pace14Offset = $("#pace14").offset().top

      if (scrollTop+windowHeight) > programOffset
        $("#program").css("background-position", "#{150-scrollTop/20}% #{-50+(scrollTop/20)}%")


      if (scrollTop+windowHeight) > speakersOffset
        $("#speakers").css("background-position", "#{-50+((scrollTop-speakersOffset)/20)}% #{200-((scrollTop-speakersOffset)/20)}%")

      if (scrollTop+windowHeight) > registrationOffset
        $("#registration").css("background-position", "#{150-((scrollTop-registrationOffset)/20)}% #{150-((scrollTop-registrationOffset)/20)}%")

      # console.log "scrollTop+windowHeight: #{scrollTop+windowHeight}; scrollTop: #{scrollTop}; venueOffset: #{venueOffset}; scrollTop+windowHeight-venueOffset: #{scrollTop+windowHeight-venueOffset}"
      if (scrollTop+windowHeight) > venueOffset
        # $("#venue").css("background-position", "#{50+((scrollTop-venueOffset)/10)}% #{scrollTop+windowHeight-venueOffset}px")

        $("#venue").css("background-position", "#{0}% #{-$(window).width()*0.7+(scrollTop+windowHeight-venueOffset)/1.5}px")

      if (scrollTop+windowHeight) > pace14Offset
        $("#pace14").css("background-position", "#{100-((scrollTop-pace14Offset)/10)}% #{windowHeight/2-(scrollTop-pace14Offset)}px")

$ ->
  bio14.parallax.start()
