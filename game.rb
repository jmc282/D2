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

  PLAYER = Player.new SUTTER_CREEK, 0, 0

  # Initialization of game

  def initialize seed
    @seed = seed                # seed value for the game
    @prng = Random.new(seed)    # pseudorandom number generator using argument seed value
  end

  # Generates a pseudorandom integer between given max and min values

  def random_int min, max
    return @prng.rand(min..max)
  end 

  def display_starting_message
    puts "Prospector #{PLAYER.name} starting in #{PLAYER.current_location.name}."
  end

  def display_location_message last_location
    print "Heading from #{last_location} to #{PLAYER.current_location.name}, "
    puts "holding #{PLAYER.gold} gold and #{PLAYER.silver} silver"
  end
  
  # Finds which location the miner heads to next given the current location

  def next_location location
    num = random_int(0, location.amt_neighbors-1) 
    return location.neighbors[num]
  end

  # Returns the amount of gold and silver found in one iteration at a given location 

  def prospect location
    gold = random_int(0, location.max_gold)
    silver = random_int(0, location.max_silver)
    return gold, silver
  end 
  
  # Returns false if the miner finds no silver and no gold at a location. Returns true otherwise. 

  def continue_search? silver, gold
    if silver == 0 && gold == 0 
      return false 
    else 
      return true
    end
  end

  # Search for gold in a given location. Prospect at the location until the miner finds 
  # less than the minimum gold and silver. 

  def search location
    gold_found, silver_found = prospect(location)
    save(silver_found, gold_found)
    if silver_found == 0 and gold_found == 0
      display_no_metals_found(location.name)
    else   
      display_metals_found(silver_found, gold_found, location.name)
    end  
    return continue_search?(silver_found, gold_found)
  end

  def display_no_metals_found location
    puts "\tFound no precious metals in #{location}."
  end

  # Calls a method to  display the amounts of silver and gold found at a location in proper units.

  def display_metals_found silver, gold, location
    display_metal(silver, "silver", location)
    display_metal(gold, "gold", location)
  end

  def display_metal amount, metal, location
    if amount == 1
      puts "\tFound 1 ounce of #{metal} in #{location}."
    elsif amount > 1
      puts "\tFound #{amount.to_s} ounces of #{metal} in #{location}." 
    end
  end

  def save silver_found, gold_found
    PLAYER.add_silver(silver_found)
    PLAYER.add_gold(gold_found)
  end

  def move_from location
    PLAYER.add_visit
    if PLAYER.visits < 5 
      last_location = location.name
      PLAYER.set_location(next_location(PLAYER.current_location))
      display_location_message last_location
    end
  end

  # During the first three locations a prospector searches, they shall leave a location 
  # if they find no silver and no gold. If they find any silver or gold, 
  # they will stay at the location for another iteration.

  # Play the game

  def play name
    PLAYER.set_name(name)
    display_starting_message
    while PLAYER.visits < 5
      location = PLAYER.current_location
      while(search(location)) 
      end
      move_from location
    end

    PLAYER.reset
    PLAYER.set_location(SUTTER_CREEK)


    
  
  end



end # end of game class





