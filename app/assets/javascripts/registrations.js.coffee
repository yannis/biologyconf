# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.bio14 ||= {}
bio14.registration =
  abstractFieldset: $(".registration-form-abstract")
  disabled: ->
    $(@abstractFieldset).data('disabled')
  setDisabled: (value)->
    $(@abstractFieldset).data('disabled', value)
    @collapseForm()
  legend: ->
    $(@abstractFieldset).find('legend')
  setRadioButtons: ->
    hideInput = $("<input name='showAbstract' id='registration-form-abstract-hide' type='radio' value='false'>").attr('checked', @disabled()).click =>
        @setDisabled(true)
    hideField = $("<label class='radio-inline'>no</label>").prepend hideInput

    showInput = $("<input name='showAbstract' id='registration-form-abstract-show' type='radio' value='true'>").attr('checked', !@disabled()).click =>
        @setDisabled(false)
    showField = $("<label class='radio-inline'>yes</label>").prepend showInput

    @legend().html("Do you want to present a talk or a poster?").append(hideField).append(showField)

  collapseForm: ->
    console.log "disabled:", @disabled()
    $(@abstractFieldset).attr('disabled', @disabled())
    $(@abstractFieldset).find('.collapsible').toggleClass('collapse', @disabled())
  set: ->
    @setRadioButtons()
    @collapseForm()

$ ->
  bio14.registration.set()
