require 'spec_helper'

feature "Admin adds a video" do
  scenario "admin adds a video successfully" do
    create(:category, name: "Drama")
    alex = create(:user, admin: true)
    sign_in(alex)
    visit new_admin_video_path
    fill_in("Title", with: "Edward Scissorhands")
    select "Drama", from: "Category"
    fill_in("Description", with: "A movie about a man with scissors for hands")
    attach_file "video_image", './spec/support/edward_scissorhands.jpg'
    fill_in("Youtube Token", with: 'GibiNy4d4gc')
    click_button("Add Video")

    sign_out(alex)
    sign_in

    scissorhands = Video.first
    click_video(scissorhands)

    expect_page_to_have_video_title(scissorhands)
    expect(page).to have_css("iframe[src='https://www.youtube.com/embed/GibiNy4d4gc']")
  end
end
