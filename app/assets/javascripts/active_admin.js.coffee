#= require active_admin/base
#=require jquery.ui.all
#=require jquery-ui-timepicker-addon

$ ->
  $('input.hasDatetimePicker').datetimepicker
    dateFormat: "dd/mm/yy"
    beforeShow: ->
      setTimeout (->
        $('#ui-datepicker-div').css("z-index", "3000")
      ), 100
