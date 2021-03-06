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
  def display_starting_message(player)
    puts "Prospector #{player.name} starting in #{player.current_location.name}."
  end

  # Displays which location the player is coming from, and where they are heading to.
  def display_move_from(last_location, player)
    print "Heading from #{last_location.name} to #{player.current_location.name}, "
    puts "holding #{get_units(player.gold)} of gold and #{get_units(player.silver)} of silver."
  end

  # Returns the amount of gold or silver with appropiate units in ounces.
  def get_units(amount)
    raise 'Cannot get less than 1 unit.' if amount < 0

    if amount == 1
      '1 ounce'
    else
      "#{amount} ounces"
    end
  end

  # Displays the result of the game for one player:
  # Includes the total number of days, name of the prospector,
  # amount of gold, amount of silver, and the total money's worth of the metals.
  def display_results(player)
    puts "After #{player.days} days, Prospector ##{player.name} returned to San Francisco with:"
    puts "\t#{get_units(player.gold)} of gold."
    puts "\t#{get_units(player.silver)} of silver."
    puts "\tHeading home with #{convert_currency(player.silver, player.gold)}.\n\n"
  end

  # Converts currency to dollars
  def convert_currency(silver, gold)
    raise 'Currency cannot be negative.' if gold < 0 || silver < 0

    gold_currency = gold * 20.67
    silver_currency = silver * 1.31
    total_currency = gold_currency + silver_currency
    '$' + total_currency.round(2).to_s
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
  # Saves the amount of precious metals found to player data.
  def stop_search?(silver, gold)
    return true if silver.zero? && gold.zero?

    min_gold, min_silver = PLAYER.prospect_min(PLAYER)
    return true if gold < min_gold && silver < min_silver

    save(silver, gold)
    false
  end

  # Searches for gold in a given location. Prospects at the location until the miner finds
  # less than the minimum gold and silver. Adds 1 day to the total.
  def search(location, player)
    player.add_day
    gold_found, silver_found = prospect(location)
    location.display_findings(silver_found, gold_found)
    !stop_search?(silver_found, gold_found)
  end

  # Saves the amount of silver and gold found in one iteration to player data.
  def save(silver_found, gold_found)
    PLAYER.add_silver(silver_found)
    PLAYER.add_gold(gold_found)
  end

  # Increment the number of locations the miner has visited. If the miner has visited
  # less than 5 locations, set the player's current location to one of the location's
  # neighbors.
  def move_from_location(player)
    player.add_visit
    return if player.visits >= 5

    player.location(next_location(player.current_location))
  end

  # Resets player data by setting the values of gold, silver, days, and visits to 0.
  # Sets the player's location to Sutter Creek.
  def reset(player)
    player.reset
    player.location(SUTTER_CREEK)
  end

  # Play the game
  def play(which_player)
    PLAYER.player_name(which_player)
    display_starting_message(PLAYER)
    while PLAYER.visits < 5
      while search(PLAYER.current_location, PLAYER)
      end
      last_location = PLAYER.current_location
      move_from_location(PLAYER)
      display_move_from(last_location, PLAYER)
    end
    display_results(PLAYER)
    reset(PLAYER)
  end
end
