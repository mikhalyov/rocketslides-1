(function() {
  $("#clients a").each(function() {
    var a, url;
    a = $(this);
    url = "images/clients/" + (a.data('client')) + ".png";
    a.append("<img src='" + url + "'>");
    return a.attr("data-client", null);
  });

  $("#reviews ul li").each(function() {
    var li, logoUrl, photoUrl;
    li = $(this);
    photoUrl = "images/reviews/" + (li.data('client')) + "-photo.jpg";
    logoUrl = "images/reviews/" + (li.data('client')) + "-logo.png";
    li.css("background-image", "url(" + photoUrl + ")");
    return li.find(".person").css("background-image", "url(" + logoUrl + ")");
  });

  $("#reviews ol li").each(function() {
    var idx;
    idx = $(this).index();
    return $(this).click(function() {
      var slide;
      $(this).siblings().removeClass("active");
      $(this).addClass("active");
      slide = $("#reviews ul li").get(idx);
      $(slide).prevAll().removeClass("right").addClass("left");
      $(slide).nextAll().removeClass("left").addClass("right");
      return $(slide).removeClass("left").removeClass("right");
    });
  });

}).call(this);
