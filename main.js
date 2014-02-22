(function() {
  var loadImage;

  loadImage = function(url, callback) {
    var img;
    img = document.createElement("img");
    img.src = url;
    return img.onload = function() {
      var height, width;
      $(img).css("visibility", "hidden");
      $(img).css("position", "absolute");
      document.body.appendChild(img);
      width = $(img).width();
      height = $(img).height();
      document.body.removeChild(img);
      return callback(img, width, height);
    };
  };

  $("#clients a").each(function() {
    var a, url;
    a = $(this);
    url = "images/clients/" + (a.data('client')) + ".png";
    return loadImage(url, function(_, width, height) {
      a.css({
        width: width,
        height: height,
        "background-image": "url(" + url + ")"
      });
      return a.attr("data-client", null);
    });
  });

  $("input").each(function() {
    if (this.getAttribute("required")) {
      this.oninvalid = function(e) {
        e.target.setCustomValidity("");
        if (!e.target.validity.valid) {
          return e.target.setCustomValidity("Обязательное поле");
        }
      };
      return this.oninput = function(e) {
        return e.target.setCustomValidity("");
      };
    }
  });

}).call(this);
