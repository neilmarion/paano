$ ->
  $(".vote-up").on "click", ->
    vote_up = $(this) 
    console.log 
    $.ajax
      url: vote_up.attr('href')
      type: "GET"
      success: (data) ->
        vote_up.closest(".reputation_with_vote_links").find(".vote-count").html(data['votes'])
        vote_up.closest(".vote-lnk").attr('class', 'voted-up')

  $(".vote-down").on "click", ->
    vote_down = $(this) 
    console.log 
    $.ajax
      url: vote_down.attr('href')
      type: "GET"
      success: (data) ->
        vote_down.closest(".reputation_with_vote_links").find(".vote-count").html(data['votes'])
        vote_down.closest(".vote-lnk").attr('class', 'voted-down')
