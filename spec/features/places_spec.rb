require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
                                 [ Place.new( name:"Oljenkorsi", id: 1 ) ]
                             )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if there are two returned by the API, both are shown on the page" do
    BeermappingApi.stub(:places_in).with("töölö").and_return(
        [ Place.new(:id => 1, :name => "Bhangra"), Place.new(:id => 2, :name => "Janoinen lohi") ]
    )
    visit places_path
    fill_in('city', with: 'töölö')
    click_button "Search"
    expect(page).to have_content "Bhangra"
    expect(page).to have_content "Janoinen lohi"
  end

  it "if none are returned by the API, it is shown on page" do
    BeermappingApi.stub(:places_in).with("vantaa").and_return(
        []
    )
    visit places_path
    fill_in('city', with: 'vantaa')
    click_button "Search"
    expect(page).to have_content "No locations in vantaa"
  end
end