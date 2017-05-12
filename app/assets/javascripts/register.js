// https://stripe.com/docs/elements

$(document).on("turbolinks:load", function() {
  var bind_all_event_listeners = function() {
    build_and_listen_to_stripe_elements_custom_form();
  };

  var build_and_listen_to_stripe_elements_custom_form = function() {
    var stripe = Stripe("pk_test_XE1erBgMvpP4zB7ivd066W8P");
    var elements = stripe.elements();
    var card = elements.create("card");
    if ($("#card-element").length ) {
      card.mount("#card-element");
      card.addEventListener("change", function(event) {
        var displayError = document.getElementById("card-errors");
        if (event.error) {
          displayError.textContent = event.error.message;
        } else {
          displayError.textContent = "";
        }
      });
      create_stripe_token(stripe, card);
    }
  };

  var create_stripe_token = function(stripe, card) {
    var form = document.getElementById("new_user");

    form.addEventListener("submit", function(event) {
      event.preventDefault();

      stripe.createToken(card).then(function(result) {
        if (result.error) {
          // Inform the user if there was an error
          var errorElement = document.getElementById("card-errors");
          errorElement.textContent = result.error.message;
        } else {
          // Send the token to your server
          stripeTokenHandler(result.token, form);
        }
      });
    });
  };

  var stripeTokenHandler = function(token, form) {
    // Insert the token ID into the form so it gets submitted to the server
    var hiddenTokenInput = document.createElement("input");
    hiddenTokenInput.setAttribute("type", "hidden");
    hiddenTokenInput.setAttribute("name", "stripeToken");
    hiddenTokenInput.setAttribute("value", token.id);
    form.appendChild(hiddenTokenInput);

    form.submit();
  };

  bind_all_event_listeners();
});
