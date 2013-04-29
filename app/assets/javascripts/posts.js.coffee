$ ->

  $(".post-row").hover (->
    $(this).find('.post_controls').show()
    $(this).find('.post_controls_hide').hide()
  ), ->
    $(this).find('.post_controls').hide()
    $(this).find('.post_controls_hide').show()

  $(".expand").on "click", ->
    $(this).closest(".post-row").find('.preview-div.expanded').toggle()
    $(this).closest(".post-row").find('.preview-div.collapsed').toggle()

