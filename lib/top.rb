module Top

  def top(n)
    return all.sort_by{ |b| -(b.average_rating) }.first(n)
  end

end