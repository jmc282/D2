require_relative 'location.rb'
# Class defining Player object
class Player
  attr_accessor  :name
  attr_accessor  :current_location
  attr_accessor  :silver
  attr_accessor  :gold
  attr_accessor  :visits
  attr_accessor  :days

  # Player class constants
  SUTTER_CREEK = Location.new 'Sutter Creek', 0, 2, 2
  COLOMA = Location.new 'Coloma', 0, 3, 2
  ANGELS_CAMP = Location.new "Angel's Camp", 0, 4, 3
  NEVADA_CITY = Location.new 'Nevada City', 0, 5, 1
  VIRGINIA_CITY = Location.new 'Virginia City', 3, 3, 2
  MIDAS = Location.new 'Midas', 5, 0, 2
  EL_DORADO = Location.new 'El Dorado Canyon', 10, 0, 4

  # Set neighbor locations of each location
  SUTTER_CREEK.set_neighbors COLOMA, ANGELS_CAMP, nil, nil
  COLOMA.set_neighbors SUTTER_CREEK, VIRGINIA_CITY, nil, nil
  ANGELS_CAMP.set_neighbors SUTTER_CREEK, NEVADA_CITY, VIRGINIA_CITY, nil
  NEVADA_CITY.set_neighbors ANGELS_CAMP, nil, nil, nil
  VIRGINIA_CITY.set_neighbors ANGELS_CAMP, COLOMA, MIDAS, EL_DORADO
  MIDAS.set_neighbors VIRGINIA_CITY, EL_DORADO, nil, nil
  EL_DORADO.set_neighbors VIRGINIA_CITY, MIDAS, nil, nil

  # Initialization of Player
  def initialize(silver, gold)
    @name = nil
    @current_location = SUTTER_CREEK
    @silver = silver
    @gold = gold
    @visits = 0
    @days = 0
  end

  # Reset players variables to 0
  def reset
    @gold = 0
    @silver = 0
    @visits = 0
    @days = 0
  end

  # Set Player name
  def player_name(name)
    @name = name
  end

  # Increment days by 1
  def add_day
    @days += 1
  end

  # Increment visits by 1
  def add_visit
    @visits += 1
  end

  # Update total amount of silver
  def add_silver(silver_found)
    @silver += silver_found
  end

  # Update total amount of gold
  def add_gold(gold_found)
    @gold += gold_found
  end

  # Sets the location of the gold miner
  def location(location)
    @current_location = location
  end

  #
  # HELPER FUNCTIONS
  #

  # Converts currency to dollars
  def convert_currency(silver, gold)
    raise 'Currency cannot be negative.' if gold < 0 || silver < 0

    gold_currency = gold * 20.67
    silver_currency = silver * 1.31
    total_currency = gold_currency + silver_currency
    '$' + total_currency.round(2).to_s
  end

  #
  # PROSPECTING
  #

  # Returns the minimum amount of metal the miner must find at a location to continue prospecting.
  # If the player is at their first, second, or third site, returns (min gold) 0, and (min silver) 0.
  # If the player is at their fourth or fifth site, returns (min gold) 2, and (min silver) 3.  def prospect_min
  def prospect_min
    raise 'Cannot have a minimum less than zero.' if @visits < 0

    return [0, 0] if @visits <= 2
    [1, 2]
  end

  # Returns the amount of gold and silver found in one iteration at a given location
  # 'Prospects' at a given location by generating pseudorandom integers for gold and silver
  # between 0 and the location's maximum gold and silver values respectively.
  def prospect(location)
    gold = random_int(0, location.max_gold)
    silver = random_int(0, location.max_silver)
    [gold, silver]
  end

  # Searches for gold in a given location. Prospects at the location until the miner finds
  # less than the minimum gold and silver. Adds 1 day to the total.
  def search(location, player)
    player.add_day
    gold_found, silver_found = prospect(location)
    display_findings(silver_found, gold_found, location.name)
    !stop_search?(silver_found, gold_found)
  end

  # Determines if the miner should stop searching at the current location.
  # Returns true if the miner finds no silver and no gold.
  # Saves the amount of precious metals found to player data.
  def stop_search?(silver, gold, player)
    return true if silver.zero? && gold.zero?

    min_gold, min_silver = player.prospect_min
    return true if gold < min_gold && silver < min_silver

    save(silver, gold)
    false
  end

  #
  # MOVEMENT/LOCATION FUNCTIONS
  #

  # Displays which location the player is coming from, and where they are heading to.
  def display_move_from(last_location)
    print "Heading from #{last_location} to #{@current_location.name}, "
    puts "holding #{get_units(@gold)} of gold and #{get_units(@silver)} of silver."
  end

  # Finds which location the miner heads to next, given the current location.
  # Pseudorandomly generates an integer and returns the neighboring location at that index.
  def next_location
    n = random_int(0, @location.amt_neighbors - 1)
    @location.neighbors[n]
  end

  # Move player to new location
  def move_from(location)
    add_visit
    return if @visits >= 5

    last_location = @location.name
    @location(next_location(@current_location))
    display_move_from(last_location)
  end

  #
  # PLAYER STATS
  #

  # Resets player data by setting the values of gold, silver, days, and visits to 0.
  # Sets the player's location to Sutter Creek.
  def player_reset
    reset
    set_location SUTTER_CREEK
  end

  # Saves the amount of silver and gold found in one iteration to player data.
  def save(silver_found, gold_found)
    PLAYER.add_silver(silver_found)
    PLAYER.add_gold(gold_found)
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

  # Displays the result of the game for one player:
  # Includes the total number of days, name of the prospector,
  # amount of gold, amount of silver, and the total money's worth of the metals.
  def results
    puts "After #{@days} days, Prospector ##{@name} returned to San Francisco with:"
    puts "\t#{get_units(@gold)} of gold."
    puts "\t#{get_units(@silver)} of silver."
    puts "\tHeading home with #{convert_currency(@silver, @gold)}\n\n"
  end
end
