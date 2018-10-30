# Class defining Player object
class Player
  attr_accessor  :name
  attr_accessor  :current_location
  attr_accessor  :silver
  attr_accessor  :gold
  attr_accessor  :visits
  attr_accessor  :days

  # Initialization of Player
  def initialize(current_location, silver, gold)
    @name = nil
    @current_location = current_location
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

  # Returns the minimum amount of metal the miner must find at a location to continue prospecting. 
  # If the player is at their first, second, or third site, returns (min gold) 0, and (min silver) 0.
  # If the player is at their fourth or fifth site, returns (min gold) 2, and (min silver) 3.
  def prospect_min
    raise 'Cannot have a minimum less than zero.' if @visits < 0

    if @visits <= 2
      return 0, 0
    else
      return 2, 3
    end
  end

end
