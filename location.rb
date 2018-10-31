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
  def display_findings(silver_found, gold_found)
    if silver_found.zero? && gold_found.zero?
      display_no_metals_found
    else
      print "\tFound "
      display_metal_found(gold_found, 'gold') if gold_found > 0
      print 'and ' if !silver_found.zero? && !gold_found.zero?
      display_metal_found(silver_found, 'silver') if silver_found > 0
      print "in #{@name}.\n"
    end
  end

  # Called by display_findings to display how much of a metal was found at a location for one iteration.
  def display_metal_found(amount, metal)
    return nil if amount <= 0

    print "#{get_units(amount)} of #{metal} "
  end

  # Called by display_findings if no silver or gold has been found at a location
  # to display that no metals have been found
  def display_no_metals_found
    puts "\tFound no precious metals in #{@name}."
  end

  # Returns the amount of gold or silver with appropiate units in ounces.
  def get_units(amount)
    raise 'Cannot get less than 0 units.' if amount < 0

    if amount == 1
      '1 ounce'
    else
      "#{amount} ounces"
    end
  end
end
