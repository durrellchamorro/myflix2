def set_current_user(user = nil)
  session[:user_id] = (user || create(:user)).id
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
  fill_in('Email Address', with: user.email)
  fill_in('Password', with: user.password)
  click_on("Sign In")
end

def sign_out(user)
  click_on "#{user.full_name}"
  click_on "Sign Out"
end

def expect_to_see(text)
  expect(page).to have_content(text)
end

def expect_not_to_see(content)
  expect(page).not_to have_content(content)
end

def click_video(video)
  find("a[href='/videos/#{video.id}']").click
end

def expect_page_to_have_video_title(video)
  expect(page).to have_content(video.title)
end
