class Brewery < ActiveRecord::Base
  has_many :beers,  dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :name, length: {minimum: 1}
  validates :year, presence: true
  validates :year, numericality: {greater_than_or_equal_to: 1042,
                                  only_integer: true}
  validate :year_cant_be_in_the_future

  include RatingAverage

  def year_cant_be_in_the_future
    if not year.nil? and year > Date.today.year
      errors.add(:year, "can't be in the future.")
    end
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end

end
