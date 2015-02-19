class User < ActiveRecord::Base
  include RatingAverage
  extend Top

  has_secure_password

  validates :username, uniqueness: true,
            length: { minimum: 3, maximum: 15}
  validates :password, length: {minimum: 4}
  validate :password_must_contain_digit_and_caps

  has_many :ratings, dependent: :destroy   # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def self.active_raters
    User.all.sort_by{|user| -user.ratings.count}
  end

  def password_must_contain_digit_and_caps
    contains_digit = !password.match(/[\d{1,}]+/).nil? if not password.nil?
    contains_capital_letter = !password.match(/[A-Z]+/).nil? if not password.nil?
    if not contains_digit or not contains_capital_letter
      errors.add(:password, "Password must contain a capital letter and a number")
    end
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite_style
    favorite :style
  end

  def average_ratings(hash)
    hash.keys.each do |key|
      sum = hash[key].inject(0.0) { |sum, rating| sum + rating.score }
      hash[key] = sum / hash[key].count
    end
    return hash
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category) }.uniq
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end

  def favorite(category)
    return nil if ratings.empty?

    category_ratings = rated(category).inject([]) do |set, item|
      set << {
          item: item,
          rating: rating_of(category, item) }
    end

    category_ratings.sort_by { |item| item[:rating] }.last[:item]
  end
end


