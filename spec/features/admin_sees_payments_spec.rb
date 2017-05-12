require 'spec_helper'

feature "Admin sees payments" do
  background do
    neo = create(:user, full_name: "Thomas Anderson", email: "neo@matrix.io")
    create(:payment, user: neo)
  end

  scenario "admin can see payments" do
    sign_in(create(:user, admin: true, full_name: "Morpheus"))
    click_on "Welcome, Morpheus"
    expect_not_to_see("Plan and Billing")

    click_on "Recent Payments"
    expect_to_see("$9.99")
    expect_to_see("reference_id_string")
    expect_to_see("Thomas Anderson")
    expect_to_see("neo@matrix.io")
  end

  scenario "user cannot see payments", :js do
    sign_in(create(:user, admin: false, full_name: "Thomas Anderson"))
    click_on "Welcome, Thomas Anderson"
    expect_not_to_see "Recent Payments"

    visit admin_payments_path
    expect_to_see 'You must be an admin to do that.'
  end
end
