jQuery ->
  $("#query").focus(->
    $(this).attr "data-default", $(this).width()
    $(this).animate
      width: 500 
    , "fast"
  ).blur ->
    
    # lookup the original width 
    w = $(this).attr("data-default")
    $(this).animate
      width: w
    , "fast"

