require 'spec_helper'

feature "User successfully invites a friend" do
  scenario "user invites a friend and the friend signs up", :js, :vcr do
    bob = create(:user, full_name: "bob")
    sign_in(bob)
    invite_a_friend
    sign_out(bob)
    sleep 4
    friend_signs_up
    friend_signs_in
    friend_should_follow_inviter

    friend_signs_out
    sleep 1
    sign_in(bob)

    inviter_should_follow_friend
    clear_emails
  end

  def invite_a_friend
    click_on "Welcome, bob"
    click_link 'Invite a Friend'
    fill_in("Friend's Name", with: "ralph")
    fill_in("Friend's Email Address", with: "ralph@gmail.com")
    fill_in("Invitation Message", with: "Please join MyFlix!")
    click_button "Send Invitation"
  end

  def friend_signs_up
    open_email("ralph@gmail.com")
    current_email.click_link 'Accept this invitation'
    fill_in("Password", with: "password")
    fill_in("Full Name", with: "ralph")
    fill_in_card_info("4242424242424242")
    click_button("Sign Up")
  end

  def friend_signs_in
    wait_for_button("Sign In")
    fill_in "Email Address", with: "ralph@gmail.com"
    fill_in 'Password', with: 'password'
    click_button 'Sign In'
  end

  def friend_signs_out
    click_on "ralph"
    click_on "Sign Out"
  end

  def friend_should_follow_inviter
    friend = User.find_by(email: "ralph@gmail.com")
    wait_for_page(text: "PEOPLE")
    click_link("People")
    expect_to_see("Welcome, #{friend.full_name}")
    expect_to_see("bob")
  end

  def inviter_should_follow_friend
    click_link("People")
    expect_to_see("Welcome, bob")
    expect_to_see("ralph")
  end
end
