require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if password is too short" do
    user = User.create username:"Pekka", password: "3A", password_confirmation:"3A"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if password does not contain numbers" do
    user = User.create username:"Pekka", password: "Autooo", password_confirmation:"Autooo"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }
    let(:style1){FactoryGirl.create(:style)}

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user, style1)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user, style1)
      best = create_beer_with_rating(25, user, style1)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }
    let(:style1){FactoryGirl.create(:style)}
    let(:style2){FactoryGirl.create(:style2)}

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user, style1)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the the only rated style if only one style has ratings" do
      beer1 = create_beer_with_rating(10, user, style1)
      create_beers_with_ratings(10, 12, 14, user, style1)

      expect(user.favorite_style).to eq(beer1.style)
    end

    it "is the style with the highest average rating if several styles have ratings" do
      create_beers_with_ratings(9, 17, user, style1)
      beer3 = FactoryGirl.create(:beer2, :style=>style2)
      beer4 = FactoryGirl.create(:beer2, :style=>style2)
      FactoryGirl.create(:rating, score:38, beer:beer3, user:user)
      FactoryGirl.create(:rating, score:12, beer:beer4, user:user)

      expect(user.favorite_style).to eq(beer4.style)
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }
    let(:style1){FactoryGirl.create(:style)}

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user, style1)

      expect(user.favorite_brewery.name).to eq(beer.brewery.name)
    end

    it "is the the only rated brewery if only one brewery has ratings" do
      beer1 = create_beer_with_rating(10, user, style1)
      create_beers_with_ratings(10, 20, 30, user, style1)

      expect(user.favorite_brewery.name).to eq(beer1.brewery.name)
    end

    it "is the brewery with the highest average rating if several breweries have ratings" do
      create_beers_with_ratings(20, 21, user, style1)
      brewery2 = FactoryGirl.create(:brewery2)
      beer3 = FactoryGirl.create(:beer2, brewery:brewery2)
      FactoryGirl.create(:rating, score:30, beer:beer3, user:user)

      expect(user.favorite_brewery.name).to eq(beer3.brewery.name)
    end
  end
end

def create_beer_with_rating(score, user, style)
  beer = FactoryGirl.create(:beer, :style => style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user, style)
  scores.each do |score|
    create_beer_with_rating(score, user, style)
  end

end

#simplecovin raporttia varten
ApplicationController
BeerClubsController
BeersController
BreweriesController
MembershipsController
RatingsController
SessionsController
UsersController

Beer
BeerClub
Brewery
Membership
Rating
User

RatingAverage

