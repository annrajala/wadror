require 'rails_helper'

describe "New Beer page" do

  let!(:user) { FactoryGirl.create :user }
  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
    FactoryGirl.create :brewery
    FactoryGirl.create :style
  end

  it "should be possible to create a new beer with a valid name" do
    visit new_beer_path
    fill_in('beer[name]', with:'Olut')
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "should not be possible to create a new beer with invalid name" do
    sign_in({username: "Pekka", password:"Foobar1"})
    visit new_beer_path
    fill_in('beer[name]', with:'')
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')
    expect{
      click_button "Create Beer"
    }.not_to change{Beer.count}.from(0)
    expect(brewery.beers.count).to eq(0)
    expect(page).to have_content "New beer"
    expect(page).to have_content "Name can't be blank"
    expect(current_path).to eq(beers_path)
  end

end
