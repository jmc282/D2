# Class defining location object
class Location
  attr_accessor  :max_silver
  attr_accessor  :name
  attr_accessor  :max_gold
  attr_accessor  :amt_neighbors
  attr_accessor  :neighbors

  # Initialization of location
  def initialize(name, max_silver, max_gold, amt_neighbors)
    @name = name
    @max_silver = max_silver
    @max_gold = max_gold
    @amt_neighbors = amt_neighbors
    @neighbors = NULL
  end

  def set_neighbors(first_neighbor, second_neighbor, third_neighbor, fourth_neighbor)
    @neighbors = [first_neighbor, second_neighbor, third_neighbor, fourth_neighbor]
  end
end