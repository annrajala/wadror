require 'rails_helper'

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, username:"Matti" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is listed on Ratings page and the page shows the number of ratings" do
    FactoryGirl.create :rating, beer:beer1, user:user
    visit ratings_path
    expect(page).to have_content "Number of ratings: 1"
    expect(page).to have_content "iso 3 10"
  end

  it "is listed on rater's own page but not on others'" do
    FactoryGirl.create :rating, beer:beer1, user:user
    FactoryGirl.create :rating, beer:beer2, user:user2
    visit user_path(user)
    expect(page).to have_content "Has 1 rating"
    expect(page).to have_content "iso 3 10"
    expect(page).not_to have_content "Karhu 10"
  end

  it "is not listed on user's page if it is removed by user" do
    FactoryGirl.create :rating, beer:beer1, user:user
    visit user_path(user)
    page.first(:link, "delete").click
    expect(page).to have_content "No ratings"
    expect(page).not_to have_content "iso 3 10"
  end

  it "rater's page shows favorite style and brewery correctly" do
    beer1.style = "Lager"
    FactoryGirl.create :rating, beer:beer1, user:user
    visit user_path(user)
    expect(page).to have_content "Favorite style: Lager"
    expect(page).to have_content "Favorite brewery: Koff"
  end
end