require 'spec_helper'

feature "User interacts with social networking features" do
  def click_unfollow_button
    find("a[data-method='delete']").click
  end

  scenario "user follows and unfollows another user" do
    neo = create(:user, full_name: "Neo")
    bob = create(:user, full_name: "Morpheus")
    drama = create(:category)
    titans = create(:video, category_id: drama.id)
    create(:photo, video: titans)
    create(:review, user: bob, video: titans, content: "This is a very short review!")

    sign_in(neo)
    click_video(titans)
    click_on("Morpheus")
    click_on('Follow')
    expect_to_see("Morpheus")

    click_on("Morpheus")
    expect_not_to_see('Follow')

    click_link('People')
    click_unfollow_button
    expect_not_to_see("Morpheus")

    click_on('Videos')
    click_video(titans)
    click_on("Morpheus")
    expect_to_see('Follow')
  end
end
