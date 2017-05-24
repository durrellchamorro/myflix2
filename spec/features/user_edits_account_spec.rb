require 'spec_helper'

feature "user edits account", :js do
  let(:neo) { create(:user, full_name: "Thomas Anderson", email: "neo@matrix.io", password: "password") }
  scenario "user successfully updates email address, password, and full name" do
    sign_in(neo)
    click_on("Welcome, Thomas Anderson")
    click_on("Account")

    expect_field_value(field: "Full Name", value: "Thomas Anderson")
    expect_field_value(field: "Email Address", value: "neo@matrix.io")

    fill_in("Email Address", with: "mr_anderson@matrix.io")
    fill_in("Password", with: "secret")
    fill_in("Confirm Password", with: "secret")
    fill_in("Full Name", with: "The Chosen One")
    click_on("Update Account")

    expect_to_see("Your account was successfully updated.")
    expect_to_see("Welcome, The Chosen One")
    expect_field_value(field: "Full Name", value: "The Chosen One")
    expect_field_value(field: "Email Address", value: "mr_anderson@matrix.io")

    click_on("Welcome, The Chosen One")
    click_on("Sign Out")
    sleep 1
    visit login_path
    fill_in('Email Address', with: "mr_anderson@matrix.io")
    fill_in('Password', with: "secret")
    click_on("Sign In")

    expect_to_see("Welcome, The Chosen One")
  end

  scenario "user unsuccessfully updates account with an email that is already taken" do
    create(:user, email: "morpheus@matrix.io", password: "password")
    sign_in(neo)
    click_on("Welcome, Thomas Anderson")
    click_on("Account")
    fill_in("Email Address", with: "morpheus@matrix.io")
    fill_in("Password", with: "secret")
    fill_in("Confirm Password", with: "secret")
    fill_in("Full Name", with: "The Chosen One")
    click_on("Update Account")

    expect_to_see("Please try again.")

    click_on("Welcome, Thomas Anderson")
    click_on("Sign Out")
    visit login_path
    sleep 4
    fill_in('Email Address', with: "morpheus@matrix.io")
    fill_in('Password', with: "secret")
    click_on("Sign In")

    expect_to_see("Invalid email or password")
  end

  scenario "user unsuccessfully updates account with password that doesn't match the password confirmation" do
    sign_in(neo)
    click_on("Welcome, Thomas Anderson")
    click_on("Account")
    fill_in("Password", with: "secret")


    page.should have_css("input[class='btn btn-primary disabled']")
    expect_to_see("passwords do not match")
  end

  scenario "user unsuccessfully updates account with password confirmation that doesn't match the password" do
    sign_in(neo)
    click_on("Welcome, Thomas Anderson")
    click_on("Account")
    fill_in("Confirm Password", with: "does not match")

    page.should have_css("input[class='btn btn-primary disabled']")
    expect_to_see("passwords do not match")
  end
end
