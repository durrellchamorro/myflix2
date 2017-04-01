require 'spec_helper'

feature "User resets password" do
  scenario "user successfully resets the password" do
    clear_emails
    bob = create(:user, password: "old_password")
    visit root_path
    click_link "Sign In"
    click_link "Forgot Password?"
    fill_in("Email Address", with: bob.email)
    click_button 'Send Email'
    open_email(bob.email)

    current_email.click_link 'Please reset your password'
    expect_to_see('Reset Your Password')

    fill_in("New Password", with: "new_password")
    click_button "Reset Password"
    expect_to_see("Sign in")

    fill_in("Email Address", with: bob.email)
    fill_in("Password", with: "new_password")
    click_button "Sign In"
    expect_to_see("Welcome, #{bob.full_name}")

    clear_emails
  end
end
