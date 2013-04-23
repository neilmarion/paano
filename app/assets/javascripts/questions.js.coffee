# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(".text_field.comment").keypress (e) ->
  if e.which is 13
    alert "hello"
    $(this).closest("form").submit ->
      $.post this.attr("action"), this.serialize(), ((json) ->
        alert json
      ), "json"    
    false #<---- Add this line

