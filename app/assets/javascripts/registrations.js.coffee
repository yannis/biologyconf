window.bio14 ||= {}
bio14.registration =
  # abstractFieldset: $(".registration-form-abstract")
  feeFieldset: $("#registration-fees")
  vegetarianInput: $("#registration-vegetarian")
  dinnerCategoryInput: $("#registration_dinner_category_name")
  # abstract_disabled: ->
  #   $(@abstractFieldset).data('abstract-disabled')
  # setDisabled: (value)->
  #   $(@abstractFieldset).data('abstract-disabled', value)
  #   @collapseForm()
  # legend: ->
  #   $(@abstractFieldset).find('legend')
  # setRadioButtons: ->
  #   hideInput = $("<input name='showAbstract' id='registration-form-abstract-hide' type='radio' value='false'>").attr('checked', @abstract_disabled()).click =>
  #       @setDisabled(true)
  #   hideField = $("<label class=''>no</label>").prepend hideInput

  #   showInput = $("<input name='showAbstract' id='registration-form-abstract-show' type='radio' value='true'>").attr('checked', !@abstract_disabled()).click =>
  #       @setDisabled(false)
  #   showField = $("<label class=''>yes</label>").prepend showInput

  #   @legend().html("Do you want to present a talk or a poster?").append(hideField).append(showField)

  # collapseForm: ->
  #   # console.log "abstract-disabled:", @abstract_disabled()
  #   $(@abstractFieldset).attr('abstract-disabled', @abstract_disabled())
  #   $(@abstractFieldset).find('.collapsible').toggleClass('collapse', @abstract_disabled())
  editor: new wysihtml5.Editor "registration_body", toolbar: "registration-body-toolbar", parserRules:  wysihtml5ParserRules

  disableVegetarianIfNoDinner: ->
    @vegetarianInput.attr("disabled", "disabled") if @dinnerCategoryInput.val() == ""

  observeDinner: ->
    zis = @
    @dinnerCategoryInput.on "change", ->
      zis.vegetarianInput.attr("disabled", $(@).val() == "")

  setVegetarianInput: ->
    @disableVegetarianIfNoDinner()
    @observeDinner()

  disablePosterAgreementIfNoTalk: ->
    value = $("input[name='registration[talk]']:checked").val()
    $("input[name='registration[poster_agreement]']").attr("disabled", "disabled") if value != "true"

  observeTalk: ->
    zis = @
    $("input[name='registration[talk]']").on "change", ->
      $("input[name='registration[poster_agreement]']").attr("disabled", $(@).val() == "false")

  setPosterAgreementInput: ->
    @disablePosterAgreementIfNoTalk()
    @observeTalk()

  calculateFee: ->
    fee = 0.00
    $(@feeFieldset).find(":selected, :checked").each (i, element) ->
      value = parseFloat($(element).data('fee'))
      fee += value if value > 0
    return fee

  setFee: ->
    zis = @
    $(@feeFieldset).on 'change', "input, select", (event) ->
      fee = zis.calculateFee()
      $("#registration-fees-total span").html(fee)

  set: ->
    @setFee()
    @setVegetarianInput()
    @setPosterAgreementInput()


$ ->
  bio14.registration.set()
