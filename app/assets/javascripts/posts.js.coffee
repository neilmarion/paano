$ ->

  $(".post-row").hover (->
    $(this).find('.post_controls').show()
    $(this).find('.post_controls_hide').hide()
  ), ->
    $(this).find('.post_controls').hide()
    $(this).find('.post_controls_hide').show()

  $(".preview_expand").on "click", ->
    $(this).closest(".post-row").find('.preview_collapse').toggle()
    $(this).closest(".post-row").find('.preview_expand').toggle()
    $(this).closest(".post-row").find('.preview-div.expanded').toggle()
    $(this).closest(".post-row").find('.preview-div.collapsed').toggle()
    false

  $(".preview_collapse").on "click", ->
    $(this).closest(".post-row").find('.preview_expand').toggle()
    $(this).closest(".post-row").find('.preview_collapse').toggle()
    $(this).closest(".post-row").find('.preview-div.expanded').toggle()
    $(this).closest(".post-row").find('.preview-div.collapsed').toggle()
    false
