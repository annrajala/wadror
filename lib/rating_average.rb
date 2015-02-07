module RatingAverage

  def average_rating
    ratings.average(:score).round(2)
  end

end
