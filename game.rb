require_relative 'location.rb'
require_relative 'player.rb'

# This is the game class for the gold_rush game
class Game < Location
  # Game class constants
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

  # Set Player
  PLAYER = Player.new SUTTER_CREEK, 0, 0

  # Initialization of game
  def initialize(seed)
    @seed = seed                # seed value for the game
    @prng = Random.new(seed)    # pseudorandom number generator using argument seed value
  end

  # Generates a pseudorandom integer between given max and min values
  def random_int(min, max)
    @prng.rand(min..max)
  end

  # Displays the starting location of the player upon starting the game.
  def display_starting_message
    puts "Prospector #{PLAYER.name} starting in #{PLAYER.current_location.name}."
  end

  # Displays which location the player is coming from, and where they are heading to.
  def display_move_from(last_location)
    print "Heading from #{last_location} to #{PLAYER.current_location.name}, "
    puts "holding #{get_units(PLAYER.gold)} of gold and #{get_units(PLAYER.silver)} of silver."
  end

  # Returns the amount of gold or silver with appropiate units in ounces.
  def get_units(amount)
    raise 'Cannot get less than 1 unit.' if amount < 1

    if amount == 1
      '1 ounce'
    else
      "#{amount} ounces"
    end
  end

  # Displays the amount of silver or gold found in a single iteration.
  def display_findings(silver_found, gold_found, location)
    if silver_found.zero? && gold_found.zero?
      display_no_metals_found(location)
    else
      display_metal_found(gold_found, 'gold', location)
      display_metal_found(silver_found, 'silver', location)
    end
  end

  # Called by display_findings to display how much of a metal was found at a location for one iteration.

  def display_metal_found(amount, metal, location)
    return if amount < 0

    puts "\tFound #{get_units(amount)} of #{metal} in #{location}"
  end

  # Called by display_findings if no silver or gold has been found at a location
  # to display that no metals have been found

  def display_no_metals_found(location)
    puts "\tFound no precious metals in #{location}."
  end

  # Displays the result of the game for one player:
  # Includes the total number of days, name of the prospector,
  # amount of gold, amount of silver, and the total money's worth of the metals.
  def display_results
    puts "After #{PLAYER.days} days, Prospector ##{PLAYER.name} returned to San Francisco with:"
    puts "\t#{get_units(PLAYER.gold)} of gold."
    puts "\t#{get_units(PLAYER.silver)} of silver."
    puts "\tHeading home with #{convert_currency}"
  end

  # Converts currency to dollars
  def convert_currency(gold, silver)
    raise NegativeCurrencyError if gold < 0 || silver < 0

    gold_currency = gold * 20.67
    silver_currency = silver * 1.31
    total_currency = gold_currency + silver_currency
    '$' + total_currency.round(2).to_str
  end

  # Finds which location the miner heads to next, given the current location.
  # Pseudorandomly generates an integer and returns the neighboring location at that index.
  def next_location(location)
    n = random_int(0, location.amt_neighbors - 1)
    location.neighbors[n]
  end

  # Returns the amount of gold and silver found in one iteration at a given location
  # 'Prospects' at a given location by generating pseudorandom integers for gold and silver
  # between 0 and the location's maximum gold and silver values respectively.
  def prospect(location)
    gold = random_int(0, location.max_gold)
    silver = random_int(0, location.max_silver)
    [gold, silver]
  end

  # Determines if the miner should stop searching at the current location.
  # Returns true if the miner finds no silver and no gold.
  def stop_search?(silver, gold)
    silver.zero? && gold.zero?
  end

  # Searches for gold in a given location. Prospects at the location until the miner finds
  # less than the minimum gold and silver. Saves the amount of precious metals found to player data.
  def search(location)
    gold_found, silver_found = prospect(location)
    save(silver_found, gold_found)
    display_findings(silver_found, gold_found, location.name)
    !stop_search?(silver_found, gold_found)
  end

  # Saves the amount of silver and gold found in one iteration to player data.
  # Adds 1 day to the total.
  def save(silver_found, gold_found)
    PLAYER.add_silver(silver_found)
    PLAYER.add_gold(gold_found)
    PLAYER.add_day
  end

  # Increment the number of locations the miner has visited. If the miner has visited
  # less than 5 locations, set the player's current location to one of the location's
  # neighbors. Display the old and new locations.
  def move_from(location)
    return Player.add_visit if Player.visits < 5

    PLAYER.add_visit
    last_location = location.name
    PLAYER.set_location(next_location(PLAYER.current_location))
    display_move_from last_location
  end

  # Resets player data by setting the values of gold, silver, days, and visits to 0.
  # Sets the player's location to Sutter Creek.
  def reset_player
    PLAYER.reset
    PLAYER.location(SUTTER_CREEK)
  end

  # During the first three locations a prospector searches, they shall leave a location
  # if they find no silver and no gold. If they find any silver or gold,
  # they will stay at the location for another iteration.
  # During the final two locations a prospector searches, they shall leave a location if
  # they find one ounce or fewer of gold and two ounces or fewer of silver. If they find
  # either two ounces or more of gold, or three ounces or more of silver, they will remain.

  # Play the game
  def play(which_player)
    PLAYER.name(which_player)
    display_starting_message
    while PLAYER.visits < 5
      while search(PLAYER.current_location)
      end
      move_from PLAYER.current_location
    end
    display_results
    reset_player
  end
end
