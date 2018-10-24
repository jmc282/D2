class Player
  # Initialization of Player
  def initialize(current_location, silver, gold)
    @name
    @current_location = current_location
    @silver = silver
    @gold = gold
    @visits = 0
    @days = 0
  end

  def reset
    @gold = 0
    @silver = 0
    @visits = 0
    @days = 0
  end

  def name
    @name
  end

  def set_name(name)
    @name = name
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
  def set_location(location)
    @current_location = location
  end

end