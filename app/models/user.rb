class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
            length: { minimum: 3, maximum: 15}
  validates :password, length: {minimum: 4}
  validate :password_must_contain_digit_and_caps

  has_many :ratings, dependent: :destroy   # käyttäjällä on monta ratingia
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

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

  def favorite_style
    return nil if ratings.empty?
    group_by_style = ratings.group_by { |r| r.beer.style }
    (average_ratings(group_by_style)).max_by{ |style, average| average }[0]
  end

  def favorite_brewery
    return nil if ratings.empty?
    group_by_brewery = ratings.group_by { |r| r.beer.brewery }
    (average_ratings(group_by_brewery)).max_by { |brewery, average| average }[0]
  end

  def average_ratings(hash)
    hash.keys.each do |key|
      sum = hash[key].inject(0.0) { |sum, rating| sum + rating.score }
      hash[key] = sum / hash[key].count
    end
    return hash
  end
end


