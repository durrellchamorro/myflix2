require 'spec_helper'

feature "User signs in" do
  given(:user) { create(:user, password: "password") }

  scenario "the user signs in successfully" do
    sign_in(user)
    expect_to_see("Welcome, #{user.full_name}")
  end

  scenario "user signs in with wrong password", js: true do
    visit login_path
    fill_in('Email Address', with: user.email)
    fill_in("Password", with: "wrong password")
    click_on("Sign In")

    expect_to_see("Invalid email or password")
  end
end
