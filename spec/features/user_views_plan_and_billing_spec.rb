require 'spec_helper'

feature "User sees plan and billing" do
  let(:neo) { create(:user, full_name: "Thomas Anderson") }
  let(:morpheus) { create(:user, full_name: "Morpheus") }

  background do
    create(:subscription,
           user: neo,
           current_period_start: 1483228800,
           current_period_end: 1485907200)
    create(:subscription,
           user: morpheus,
           current_period_start: 922838400,
           current_period_end: 925516800)
  end

  scenario "neo can see his plan and billing, but morpheus's plan and billing" do
    sign_in(neo)
    click_on "Welcome, Thomas Anderson"
    expect_not_to_see("Recent Payments")

    click_on("Plan and Billing")

    expect_to_see("$9.99 per month")
    expect_to_see("12/31/2016 - 01/31/2017")
    expect_not_to_see("03/30/1999 - 04/30/1999")
  end

  scenario "morpheus can see his plan and billing, but not neo's plan and billing" do
    sign_in(morpheus)
    click_on "Welcome, Morpheus"
    expect_not_to_see("Recent Payments")

    click_on("Plan and Billing")

    expect_to_see("$9.99 per month")
    expect_to_see("03/30/1999 - 04/30/1999")
    expect_not_to_see("12/31/2016 - 01/31/2017")
  end

  scenario "an unauthenticated user cannot view the plan and billing", :js do
    visit subscriptions_path

    expect_to_see("You must be signed in to do that.")
  end
end
