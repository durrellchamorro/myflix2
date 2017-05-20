$(document).on("turbolinks:load", function() {
  $(".search_input").autocomplete({
    source:"/videos/autocomplete",
    minlength: 2
  });
});
