# I can test this locally with ngrok, but I can't figure out how to record the webhook response from Stripe with vcr
# since I'm listening for the webhook via ngrok. Since I can't record it and I can't integrate CircleCI with ngrok, this
# test won't pass on CircleCi. Nobody has answered this questino on SO either: http://stackoverflow.com/questions/39291769/webhook-test-with-circleci

# require 'spec_helper'
#
# feature "When the user unsubscribes he does not see the cancel service button and next billing date etc in his plan and billing page" do
#
#   background do
#     action_movie = create(:category, name: "Action")
#     create(:video, title: "The Matrix", category: action_movie)
#     visit register_path
#     fill_in_valid_user_info
#     fill_in_card_info("4242424242424242")
#     click_button("Sign Up")
#     wait_for_page(text: "You signed up successfully.")
#   end
#
#   scenario "user logs in and cancels his service; is redirected to the home page, then views his plan and billing and does not see the button to cancel his service again since it is already canceled", :js, :vcr do
#     neo = User.last
#     # We can't access neo's password via neo.password since it is encrypted and we aren't testing authentication so we just reset his password.
#     # We can't create neo via a factory in order to access his password easily because we need to get a stripe_id from Stripe.
#     neo.password = 'password'
#     sign_in(neo)
#     click_on "Welcome, Thomas Anderson"
#     click_on("Plan and Billing")
#     click_on("Cancel Service")
#     page.driver.browser.switch_to.alert.accept
#
#     expect_to_see("Your subscription has been set to cancel at the end of the billing period.")
#     expect_to_see("Action")
#
#     click_on("Welcome, Thomas Anderson")
#     click_on("Plan and Billing")
#
#     expect_not_to_see("Cancel Service")
#     expect_not_to_see("The All You Can Watch Plan")
#     expect_not_to_see("Next Billing Date")
#   end
# end
