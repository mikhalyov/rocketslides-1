trackGoal = (yandexGoal) ->
  if yandexGoal
    try
      yaCounter24179341.reachGoal(yandexGoal)
    catch e

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

$("[href='#order-presentation']").click ->
  $("#order").addClass("visible")
  button = $(@).data("name")
  $("#order form h3").text($(@).text())
  $("#order [type=submit]").attr("data-name", button).data("name", button).data("event", $(@).data("event"))
  if $(@).data("event")
    trackGoal("open-" + $(@).data("event")) 
  no

$("[href='#order-call']").click ->
  $("#callme").addClass("visible")
  top = $(@).offset().top + $(@).height() + 35 - window.scrollY
  left = $(@).offset().left + Math.ceil($(@).width() / 2)
  width_2 = Math.ceil($("#callme .inner").width() / 2)
  left = left - width_2
  if left + 2 * (width_2) > $(window).width() - 36
    left = $(window).width() - width_2 * 2 - 36
  $("#callme .inner").css({
    top: top
    left: left
  });
  scrollDelta = $(window).height() - top - $("#callme .inner").height() - 12 - 35
  if /iPad/i.test(navigator.userAgent)
    scrollDelta = scrollDelta - 350
  if scrollDelta < 0
    $("html, body").animate({scrollTop: window.scrollY - scrollDelta}, 400)
    $("#callme .inner").animate({top: top + scrollDelta}, 400)
  button = $(@).data("name")
  $("#callme [type=submit]").attr("data-name", button).data("name", button).data("event", $(@).data("event"))
  if $(@).data("event")
    trackGoal("open-" + $(@).data("event")) 
  no

$("#callme .close, #callme .close-popup, #order .close, #order .close-popup").click ->
  popup = $(@).parents("#callme, #order")
  popup.removeClass("visible")
  popup.find("form").removeClass("submited").removeClass("submiting")
  popup.find("form")[0].reset()
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
      {name: "button", content: button},
      {name: "type", content: $.url().param("type")},
      {name: "source", content: $.url().param("source")},
      {name: "block", content: $.url().param("block")},
      {name: "pos", content: $.url().param("pos")},
      {name: "key", content: $.url().param("key")},
      {name: "campaign", content: $.url().param("campaign")},
      {name: "ad", content: $.url().param("ad")},
      {name: "phrase", content: $.url().param("phrase")},
      {name: "utm_source", content: $.url().param("utm_source")},
      {name: "utm_medium", content: $.url().param("utm_medium")},
      {name: "utm_term", content: $.url().param("utm_term")},
      {name: "utm_content", content: $.url().param("utm_content")},
      {name: "utm_campaign", content: $.url().param("utm_campaign")},
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
    trackGoal $(@).find("[type='submit']").data("event")
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

$("input").each ->
  if @getAttribute("required")
    @oninvalid = (e) ->
      e.target.setCustomValidity ""
      unless e.target.validity.valid
        e.target.setCustomValidity "Обязательное поле"
    @oninput = (e) ->
      e.target.setCustomValidity ""
