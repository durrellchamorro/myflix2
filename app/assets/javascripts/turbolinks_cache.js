$(document).on("turbolinks:before-cache", function() {
  $("div.unobtrusive-flash-container").empty();
});
