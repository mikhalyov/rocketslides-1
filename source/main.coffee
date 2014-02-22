loadImage = (url, callback) ->
  img = document.createElement "img"
  img.src = url
  img.onload = ->
    $(img).css("visibility", "hidden")
    $(img).css("position", "absolute")
    document.body.appendChild img
    width = $(img).width()
    height = $(img).height()
    document.body.removeChild img
    callback img, width, height

$("#clients a").each ->
  a = $(@)
  url = "images/clients/#{a.data('client')}.png"
  loadImage url, (_, width, height) ->
    a.css
      width: width
      height: height
      "background-image": "url(#{url})"
    a.attr("data-client", null)

$("input").each ->
  if @getAttribute("required")
    @oninvalid = (e) ->
      e.target.setCustomValidity ""
      unless e.target.validity.valid
        e.target.setCustomValidity "Обязательное поле"
    @oninput = (e) ->
      e.target.setCustomValidity ""
