class Player

  # Initialization of Player
  def initialize current_location, visits, silver, gold
	@current_location = current_location
	@visits = visits
	@silver = silver
	@gold = gold
  @days = 0
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

  def days
    @days
  end

  def add_day
    @days += 1
  end

  def add_silver silver_found
    @silver += silver_found
  end 

  def add_gold gold_found
    @gold += gold_found
  end

  # Sets the location of the gold miner
  def set_location location
  	@current_location = location
  end

end