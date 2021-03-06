require 'spec_helper'

feature "User registers", :js, :vcr do
  background do
    visit register_path
  end

  scenario "with valid user info and valid card" do
    fill_in_valid_user_info
    fill_in_card_info("4242424242424242")
    click_button("Sign Up")

    wait_for_page(text: "You signed up successfully.")
    expect_to_see("You signed up successfully.")
  end

  scenario "with valid user info and invalid card" do
    fill_in_valid_user_info
    fill_in_card_info("4242424242424241")
    click_button("Sign Up")

    expect(User.count).to eq(0)
    expect_to_see("Your card number is invalid.")
  end

  scenario "with valid user info and declined card" do
    fill_in_valid_user_info
    fill_in_card_info("4000000000000002")
    click_button("Sign Up")

    expect(User.count).to eq(0)
    wait_for_page(text: "Your card was declined.")
    expect_to_see("Your card was declined.")
  end

  scenario "with invalid user info and valid card info" do
    fill_in_invalid_user_info
    fill_in_card_info("4242424242424242")
    click_button("Sign Up")

    expect(User.count).to eq(0)
    wait_for_page(text: "can't be blank")
    expect_to_see("can't be blank")
  end

  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user_info
    fill_in_card_info("4242424242424241")
    click_button("Sign Up")

    expect(User.count).to eq(0)
    expect_to_see("Your card number is invalid.")
  end

  scenario "with invalid user info and declined card" do
    fill_in_invalid_user_info
    fill_in_card_info("4000000000000002")
    click_button("Sign Up")

    expect(User.count).to eq(0)
    wait_for_page(text: "can't be blank")
    expect_to_see("can't be blank")
  end

  def fill_in_invalid_user_info
    fill_in("Email Address", with: "neo@matrix.io")
    fill_in("Password", with: "")
    fill_in("Full Name", with: "Thomas Anderson")
  end
end
