# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(".text_field.comment").keypress (e) ->
  if e.which is 13    
    form = $(this).closest("form")    

    $.ajax
      url: form.attr('action')
      type: "PUT"
      dataType: "json"
      data: form.serialize()

    false
