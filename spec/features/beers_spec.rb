require 'rails_helper'

describe "New Beer page" do

  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  it "should be possible to create a new beer with a valid name" do
    visit new_beer_path
    fill_in('beer[name]', with:'Olut')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "should not be possible to create a new beer with empty name" do
    visit new_beer_path
    click_button "Create Beer"
    expect(page).to have_content "New beer"
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end
