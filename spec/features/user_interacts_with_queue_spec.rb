require 'spec_helper'

feature "user interacts with queue" do
  def set_video_position_in_queue(video, position)
    find("input[data-video-slug='#{video.slug}']").set(position)
  end

  def expect_video_in_correct_position(video, position)
    expect(find("input[data-video-slug='#{video.slug}']").value).to eq(position.to_s)
  end

  def add_video_to_queue(video)
    visit home_path
    click_video(video)
    click_link '+ My Queue'
  end

  scenario "user adds and reorders videos in the queue" do
    drama = create(:category)
    monk = create(:video, title: "Monk", category: drama)
    create(:photo, video: monk)
    jurassic = create(:video, title: "Jurassic", category: drama)
    create(:photo, video: jurassic)
    titans = create(:video, title: "Titans", category: drama)
    create(:photo, video: titans)

    sign_in
    click_video(monk)
    expect_page_to_have_video_title(monk)

    click_on '+ My Queue'
    expect_page_to_have_video_title(monk)

    visit video_path(monk)
    expect_not_to_see("+ My Queue")

    add_video_to_queue(jurassic)
    add_video_to_queue(titans)
    set_video_position_in_queue(monk, 3)
    set_video_position_in_queue(jurassic, 1)
    set_video_position_in_queue(titans, 2)
    click_button "Update Instant Queue"

    expect_video_in_correct_position(monk, 3)
    expect_video_in_correct_position(jurassic, 1)
    expect_video_in_correct_position(titans, 2)
  end
end
