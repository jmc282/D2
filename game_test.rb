require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'game'
require_relative 'location.rb'
require_relative 'player.rb'
# Test Suite for game
class GameTest < Minitest::Test
  # 10 is seed value
  def setup
    @g = Game.new(10)
  end

  # UNIT TESTS FOR METHOD
  # def test_random_int
  # end

  # UNIT TESTS FOR METHOD get_units(amount)
  # Equivalence classes:
  # amount == 1 -> returns "1 ounce"
  # amount != 1 -> returns "#{amount} ounces"
  # amount == (not a number)??
  def test_get_units_ounce
    assert_equal @g.get_units(1), '1 ounce'
  end

  def test_get_units_ounces
    assert_equal @g.get_units(5), '5 ounces'
  end

  def test_get_units_ounce_less_1
    assert_raises 'Cannot get less than 1 unit.' do
      @g.get_units(-1)
    end
  end

  # UNIT TESTS FOR METHOD convert_currency(silver, gold)
  # Equivalence classes:
  # silver == 0 gold == 1 -> returns "$20.67"
  # silver == 3 gold == 2 -> returns "45.27"
  # silver < 0  -> raises 'Currency cannot be negative.'
  # gold   < 0  -> raises 'Currency cannot be negative.'
  def test_convert_currency
    assert_equal @g.convert_currency(0, 1), '$20.67'
  end

  def test_convert_currency_mixed
    assert_equal @g.convert_currency(3, 2), '$45.27'
  end

  def test_convert_currency_silver_negative
    assert_raises 'Currency cannot be negative.' do
      @g.convert_currency(-1, 0)
    end
  end

  def test_convert_currency_gold_negative
    assert_raises 'Currency cannot be negative.' do
      @g.convert_currency(0, -1)
    end
  end

  # UNIT TESTS FOR METHOD display_findings(silver_found, gold_found, location)
  # Equivalence classes:
  # silver_found == 0 gold_found == 0 -> display no metals found
  # silver_found > 0 -> display metals found
  # gold_found > 0   -> display metals found
  def test_no_metal_found
    @l = Location.new 'Sutter Creek', 0, 2, 2
    assert_output("\tFound no precious metals in Sutter Creek.\n") {@g.display_findings(0, 0, @l.name)}
  end

  def test_positive_silver_found
    @l = Location.new 'Sutter Creek', 0, 2, 2
    assert_output("\tFound 1 ounce of silver in Sutter Creek.\n") {@g.display_findings(1, 0, @l.name)}
  end

  def test_positive_gold_found
    @l = Location.new 'Sutter Creek', 0, 2, 2
    assert_output("\tFound 1 ounce of gold in Sutter Creek.\n") {@g.display_findings(0, 1, @l.name)}
  end

  # UNIT TESTS FOR METHOD stop_search?(silver, gold)
  # Equivalence classes:
  # silver == 0, gold == 0  true
  # silver == 0, gold != 0  false
  # silver != 0, gold == 0  false
  # silver != 0, gold != 0  false
  def test_stop_search_if_none_found
    assert_equal @g.stop_search?(0, 0), true
  end

  def test_stop_search_still_gold
    assert_equal @g.stop_search?(0, 1), false
  end

  def test_stop_search_still_silver
    assert_equal @g.stop_search?(1, 0), false
  end

  def test_stop_search_still_both
    assert_equal @g.stop_search?(1, 1), false
  end

  # UNIT TESTS FOR METHOD next_location(location)
  # Equivalence classes:
  #

  # UNIT TESTS FOR METHOD search(location, player)
  # Equivalence classes:
  #

  # UNIT TESTS FOR METHOD search(location, player)
  # Equivalence classes:
  #
end
