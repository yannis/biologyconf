# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.bio14 ||= {}
bio14.registration =
  abstractFieldset: $(".registration-form-abstract")
  abstract_disabled: ->
    $(@abstractFieldset).data('abstract-disabled')
  setDisabled: (value)->
    $(@abstractFieldset).data('abstract-disabled', value)
    @collapseForm()
  legend: ->
    $(@abstractFieldset).find('legend')
  setRadioButtons: ->
    hideInput = $("<input name='showAbstract' id='registration-form-abstract-hide' type='radio' value='false'>").attr('checked', @abstract_disabled()).click =>
        @setDisabled(true)
    hideField = $("<label class=''>no</label>").prepend hideInput

    showInput = $("<input name='showAbstract' id='registration-form-abstract-show' type='radio' value='true'>").attr('checked', !@abstract_disabled()).click =>
        @setDisabled(false)
    showField = $("<label class=''>yes</label>").prepend showInput

    @legend().html("Do you want to present a talk or a poster?").append(hideField).append(showField)

  collapseForm: ->
    console.log "abstract-disabled:", @abstract_disabled()
    $(@abstractFieldset).attr('abstract-disabled', @abstract_disabled())
    $(@abstractFieldset).find('.collapsible').toggleClass('collapse', @abstract_disabled())
  set: ->
    @setRadioButtons()
    @collapseForm()

$ ->
  bio14.registration.set()
