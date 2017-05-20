require 'spec_helper'
feature "User interacts with advanced search", :search do
  background do
    star_wars_1 = create(:video, :reindex, title: "Star Wars: Episode 1", description: "a description")
    star_wars_2 = create(:video, :reindex, title: "Star Wars: Episode 2", description: "star")
    star_trek = create(:video, :reindex, title: "Star Trek", description: "a description")
    bride_wars = create(:video, :reindex, title: "Bride Wars", description: "some wedding movie!")
    create(:review, video: bride_wars, content: "This movie has a star in it.")
    create(:review, video: star_wars_1, rating: 5, content: "awesome movie!!!")
    create(:review, video: star_wars_2, rating: 3)
    create(:review, video: star_trek,  rating: 4)
    create(:review, video: star_trek,  rating: 5)
    Video.reindex

    sign_in
    click_on "Advanced Search"
  end

  scenario "user searches with title" do
    expect_not_to_see("videos found")

    within(".advanced_search") do
      fill_in "query", with: "Star Wars"
      click_button "Search"
    end

    expect_to_see("2 videos found")
    expect_to_see("Star Wars: Episode 1")
    expect_to_see("Star Wars: Episode 2")
    expect_not_to_see("Star Trek")
  end

  scenario "user searches with string that matches only a video description" do
    within(".advanced_search") do
      fill_in "query", with: "wedding movie"
      click_button "Search"
    end

    expect_to_see("Bride Wars")
    expect_not_to_see("Star")
  end

  scenario "user searches for a video that has no matches" do
    within(".advanced_search") do
      fill_in "query", with: "no match"
      click_button "Search"
    end

    expect_to_see("0 videos found")
  end

  scenario "user searches with a string that matches the title, description and review content of different movies" do
    within(".advanced_search") do
      fill_in "query", with: "star"
      check "Include Reviews"
      click_button "Search"
    end

    video_rows = all("article[class='video row']")
    expect(video_rows[0].find("h3").text).to eql("Star Wars: Episode 2")
    expect(video_rows[1].find("h3").text).to eql("Star Trek")
    expect(video_rows[2].find("h3").text).to eql("Star Wars: Episode 1")
    expect(video_rows[3].find("h3").text).to eql("Bride Wars")
  end

  scenario "user filters search results with average rating" do
    within(".advanced_search") do
      fill_in "query", with: "Star"
      check "Include Reviews"
      select "4.4", from: "rating_from"
      select "4.6", from: "rating_to"
      click_button "Search"
    end

    expect(page).to have_content "Star Trek"
    expect(page).to have_no_content "Star Wars: Episode 1"
    expect(page).to have_no_content "Star Wars: Episode 2"
  end
end
