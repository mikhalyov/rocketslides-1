$("#clients a").each ->
  a = $(@)
  url = "images/clients/#{a.data('client')}.png"
  a.append "<img src='#{url}'>"
  a.attr("data-client", null)

$("#reviews ul li").each ->
  li = $(@)
  photoUrl = "images/reviews/#{li.data('client')}-photo.jpg"
  logoUrl = "images/reviews/#{li.data('client')}-logo.png"
  li.css("background-image", "url(#{photoUrl})")
  li.find(".person").css("background-image", "url(#{logoUrl})")

$("#reviews ol li").each ->
  idx = $(@).index()
  $(@).click ->
    $(@).siblings().removeClass("active")
    $(@).addClass("active")
    slide = $("#reviews ul li").get(idx)
    $(slide).prevAll().removeClass("right").addClass("left")
    $(slide).nextAll().removeClass("left").addClass("right")
    $(slide).removeClass("left").removeClass("right")

$("input").each ->
  if @getAttribute("required")
    @oninvalid = (e) ->
      e.target.setCustomValidity ""
      unless e.target.validity.valid
        e.target.setCustomValidity "Обязательное поле"
    @oninput = (e) ->
      e.target.setCustomValidity ""
