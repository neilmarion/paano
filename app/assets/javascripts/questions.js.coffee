# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $(".text_field.new_comment").keyup (e) ->
    if e.which is 13    
      text_field = $(this)
      text_field.css('height', '28px')
      val = text_field.val()
      $(this).blur()
      form = $(this).closest("form")    
      $.ajax
        url: form.attr('action')
        type: "PUT"
        dataType: "json"
        data: form.serialize()
        success: (data) ->
          text_field.closest(".span9.offset3.small-grey-text").
            find(".comments").append "<div class='comment'>"+val+"</div>"
      $(this).val('')
      e.preventDefault
      false

  $(".text_field.new_comment").autosize()
