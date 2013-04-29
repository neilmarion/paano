$ ->

  $(".post-row").hover (->
    $(this).find('.post_controls').show()
    $(this).find('.post_controls_hide').hide()
  ), ->
    $(this).find('.post_controls').hide()
    $(this).find('.post_controls_hide').show()

