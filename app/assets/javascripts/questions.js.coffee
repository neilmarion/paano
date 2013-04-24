# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $(".text_field.comment").keyup (e) ->
    if e.which is 13    
      $(this).blur()
      form = $(this).closest("form")    
      $.ajax
        url: form.attr('action')
        type: "PUT"
        dataType: "json"
        data: form.serialize()
      e.preventDefault
      false

  $(".text_field.comment").autosize()
