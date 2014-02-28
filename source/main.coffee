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

$("a[href='#order-presentation']").click ->
  $("#order").addClass("visible")
  button = $(@).data("name")
  $("#order [type=submit]").attr("data-name", button).data("name", button)
  no

$("#order .close, #order .close-popup").click ->
  $("#order").removeClass("visible")
  $("#order form").removeClass("submited").removeClass("submiting")
  $("#order form")[0].reset()
  no

$("#header nav a").click ->
  scrollTop = $($(@).attr("href")).offset().top
  duration = Math.abs(window.scrollY - scrollTop)
  $("html, body").bind "mousewheel DOMMouseScroll", -> no
  $("html, body").animate {scrollTop},
    duration: duration
    complete: ->
      $("html, body").unbind "mousewheel DOMMouseScroll"
  no


Mandrill = new mandrill.Mandrill("eryR6LS4JOYJiGZpkOjECw")

sendMail = ({name, phone, email, message, button}, complete) ->

  params =
    template_name: "request_presentation"
    template_content: [
      {name: "name", content: name},
      {name: "phone", content: phone},
      {name: "email", content: email},
      {name: "message", content: message},
      {name: "button", content: button}
    ]
    message:
      to: [{email: "barbuzaster@gmail.com"}, {email: "launch@rocketslides.ru"}]

  Mandrill.messages.sendTemplate params, ->
    complete() if complete

$("form").submit ->
  name = $(@).find("[name='name']").val() or ""
  phone = $(@).find("[name='phone']").val() or ""
  email = $(@).find("[name='email']").val() or ""
  message = $(@).find("[name='message']").val() or ""
  button = $(@).find("[data-name]").data("name") or ""
  $(@).addClass("submiting")
  # setTimeout (=>
  #   $(@).removeClass("submiting").addClass("submited")
  # ), 2000
  sendMail {name, phone, email, message, button}, =>
    $(@).removeClass("submiting").addClass("submited")
  no

$(window).scroll $.throttle 100, ->
  found = null
  $("#header nav a").each ->
    if window.scrollY > $($(@).attr("href")).offset().top - 100
      $(@).siblings().removeClass("active")
      $(@).addClass("active")
      found = true
  unless found
    $("#header nav a").removeClass("active")
  if window.scrollY > 100
    $("#header").addClass "small"
  else
    $("#header").removeClass "small"

# $("input").each ->
#   if @getAttribute("required")
#     @oninvalid = (e) ->
#       e.target.setCustomValidity ""
#       unless e.target.validity.valid
#         e.target.setCustomValidity "Обязательное поле"
#     @oninput = (e) ->
#       e.target.setCustomValidity ""
