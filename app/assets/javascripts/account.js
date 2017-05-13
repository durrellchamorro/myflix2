$(document).on("turbolinks:load", function() {

  var bind_all_event_listeners = function() {
    verify_password_confirmation_matches_password();
    verify_password_matches_password_confirmation();
  };

  var show_error = function() {
    $("#verifynote").removeClass("hidden");
    $("input[id='user_password_match']").closest(".form-group").css("margin-bottom", "5px");
  };

  var hide_error = function() {
    $("#verifynote").addClass("hidden");
    $("input[id='user_password_match']").closest(".form-group").css("margin-bottom", "15px");
  };

  var enable_submit = function() {
    $("input[value='Update Account']").removeClass("disabled");
  };

  var disable_submit = function() {
    $("input[value='Update Account']").addClass("disabled");
  };

  var verify_password_confirmation_matches_password = function() {
    $("input[id='user_password_match']").keyup(function() {
      if($(this).val() === $("input[id='user_password']").val()) {
        hide_error();
        enable_submit();
      } else {
        show_error();
        disable_submit();
      }
    });
  };

  var verify_password_matches_password_confirmation = function() {
    $("input[id='user_password']").keyup(function() {
      if($(this).val() === $("input[id='user_password_match']").val()) {
        hide_error();
        enable_submit();
      } else {
        show_error();
        disable_submit();
      }
    });
  };

  bind_all_event_listeners();
});
