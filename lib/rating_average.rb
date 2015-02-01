module RatingAverage

  def average_rating
    ratings.average(:score).round(2).to_s
  end

end
