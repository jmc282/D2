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
    @neighbors = nil

  end

  def set_neighbors(first_neighbor, second_neighbor, third_neighbor, fourth_neighbor)
    @neighbors = [first_neighbor, second_neighbor, third_neighbor, fourth_neighbor]
  end

  # Displays the amount of silver or gold found in a single iteration.
  def display_findings(silver_found, gold_found, location)
    if silver_found.zero? && gold_found.zero?
      display_no_metals_found(location)
    else
      print "\tFound "
      display_metal_found(gold_found, 'gold') if gold_found > 0
      print 'and ' if !silver_found.zero? && !gold_found.zero?
      display_metal_found(silver_found, 'silver') if silver_found > 0
      print "in #{location}\n"
    end
  end

  # Called by display_findings to display how much of a metal was found at a location for one iteration.

  def display_metal_found(amount, metal)
    return if amount <= 0

    print "#{get_units(amount)} of #{metal} "
  end

  # Returns the amount of gold and silver found in one iteration at a given location
  # 'Prospects' at a given location by generating pseudorandom integers for gold and silver
  # between 0 and the location's maximum gold and silver values respectively.
  def prospect(location)
    gold = random_int(0, location.max_gold)
    silver = random_int(0, location.max_silver)
    [gold, silver]
  end

  # Finds which location the miner heads to next, given the current location.
  # Pseudorandomly generates an integer and returns the neighboring location at that index.
  def next_location(location)
    n = random_int(0, location.amt_neighbors - 1)
    location.neighbors[n]
  end

  # Called by display_findings if no silver or gold has been found at a location
  # to display that no metals have been found
  def display_no_metals_found(location)
    puts "\tFound no precious metals in #{location}."
  end
end
