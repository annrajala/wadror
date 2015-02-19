class Style < ActiveRecord::Base
  has_many :beers, :dependent => :destroy
  has_many :ratings, through: :beers

  include RatingAverage
  extend Top

  def to_s
    name
  end
end
