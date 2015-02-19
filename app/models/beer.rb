class Beer < ActiveRecord::Base
  validates :name, presence: true
  validates :style_id, presence: true

  belongs_to :style
  belongs_to :brewery
  has_many :ratings,  dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  include RatingAverage
  extend Top

  def to_s
    self.name + " (" + self.brewery.name + ")"
  end

end
