require 'spec_helper'

feature "User interacts with social networking features" do
  def click_unfollow_button
    find("a[data-method='delete']").click
  end

  scenario "user follows and unfollows another user" do
    alex = create(:user)
    bob = create(:user)
    drama = create(:category)
    titans = create(:video, category_id: drama.id)
    create(:review, user: bob, video: titans)

    sign_in(alex)
    click_video(titans)
    click_on(bob.full_name)
    click_on('Follow')
    expect_to_see(bob.full_name)

    click_on(bob.full_name)
    expect_not_to_see('Follow')

    click_link('People')
    click_unfollow_button
    expect_to_see(bob.full_name)

    click_link('Videos')
    click_video(titans)
    click_link(bob.full_name)
    expect_to_see('Follow')
  end
end
