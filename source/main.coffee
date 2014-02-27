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

$("a[href='#order-presentation']").click ->
  $("#order").addClass("visible")
  $("#order [type=submit]").attr("data-name", $(@).data("name")).data("name", $(@).data("name"))
  no

$("#order .close").click ->
  $("#order").removeClass("visible")
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
    alert "Запрос отправлен!"
    $("#order").removeClass("visible")
    complete() if complete

$("form").submit ->
  name = $(@).find("[name='name']").val() or ""
  phone = $(@).find("[name='phone']").val() or ""
  email = $(@).find("[name='email']").val() or ""
  message = $(@).find("[name='message']").val() or ""
  button = $(@).find("[data-name]").data("name") or ""
  sendMail {name, phone, email, message, button}
  no

$(window).scroll $.throttle 100, ->
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
