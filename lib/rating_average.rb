module RatingAverage

  def average_rating
    if ratings.empty?
      0
    else
      ratings.average(:score)
    end
  end

end
