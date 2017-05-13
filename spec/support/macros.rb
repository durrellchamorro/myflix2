def set_current_user(user = nil)
  session[:user_id] = (user || create(:user)).id
end

def set_current_admin(admin = nil)
  admin.update(admin: true) if admin
  session[:user_id] = (admin || create(:user, admin: true)).id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

# Feature Specs

def sign_in(user=nil)
  user ||= create(:user)
  visit login_path
  wait_for_text('Email Address')
  fill_in('Email Address', with: user.email)
  fill_in('Password', with: user.password)
  click_on("Sign In")
end

def sign_out(user)
  wait_for_text(user.full_name.to_s)
  click_on user.full_name.to_s
  click_on "Sign Out"
end

def expect_to_see(text)
  expect(page).to have_content(text)
end

def expect_to_see_either(text1, text2)
  expect_to_see(text1)
rescue RSpec::Expectations::ExpectationNotMetError => e
  expect_to_see(text2)
end

def expect_field_value(field:, value:)
  expect(find_field(field).value).to eq(value)
end

def expect_not_to_see(content)
  expect(page).not_to have_content(content)
end

def expect_not_to_see_either(text1, text2)
  expect_not_to_see(text1)
rescue RSpec::Expectations::ExpectationNotMetError => e
  expect_not_to_see(text2)
end

def click_video(video)
  find("a[href='/videos/#{video.slug}']").click
end

def expect_page_to_have_video_title(video)
  expect(page).to have_content(video.title)
end

def fill_in_card_info(card_number)
  stripe_iframe = all("iframe[name='__privateStripeFrame3']").first

  Capybara.within_frame stripe_iframe do
    page.find("input[name='cardnumber']").set(card_number)
    date = Date.today.year + 3
    page.find("input[name='exp-date']").set("01#{date.to_s.last(2)}")
    page.find("input[name='cvc']").set("123")

    wait_for_dom(dom_finder: "input[name='postal']")
    page.find("input[name='postal']").set("90210")
  end
end

def fill_in_valid_user_info
  fill_in("Email Address", with: "neo@matrix.io")
  fill_in("Password", with: "password")
  fill_in("Full Name", with: "Thomas Anderson")
end
