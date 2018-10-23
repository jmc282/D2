class Location

  # Initialization of location
  def initialize name, max_silver, max_gold, amt_neighbors
  	@name = name
  	@max_silver = max_silver
  	@max_gold = max_gold
    @amt_neighbors = amt_neighbors
  	@neighbors
  end

  def set_neighbors first_neighbor, second_neighbor, third_neighbor, fourth_neighbor
  	@neighbors = [first_neighbor, second_neighbor, third_neighbor, fourth_neighbor]
  end

  def amt_neighbors
    @amt_neighbors
  end

  def name
  	@name
  end

  def max_gold 
  	@max_gold
  end

  def max_silver
  	@max_silver
  end

  def neighbors
  	@neighbors
  end

end