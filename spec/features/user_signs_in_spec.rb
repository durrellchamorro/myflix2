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

  scenario "deactivated user signs in", :js do
    neo = create(:user, active: false)
    visit login_path
    fill_in('Email Address', with: neo.email)
    fill_in("Password", with: neo.password)
    click_on("Sign In")
    expect_not_to_see(neo.full_name)
    expect_to_see("Your account is not active. Only active users can sign in.")
  end
end
