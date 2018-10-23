class Player

  # Initialization of Player
  def initialize(current_location, visits, silver, gold)
	@current_location = current_location
	@visits = visits
	@silver = silver
	@gold = gold
  end

  def current_location
  	@current_location
  end

  def visits
  	@visits
  end

  def silver
  	@silver
  end

  def gold
  	@gold
  end

  # Sets the location of the gold miner
  def set_location(location)
  	@current_location = location
  end

end