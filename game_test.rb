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
    @player = Player.new @sutter_creek, 0, 0
    @sutter_creek = Location.new 'Sutter Creek', 0, 2, 2
    @coloma = Location.new 'Coloma', 0, 3, 2
    @angels_camp = Location.new "Angel's Camp", 0, 4, 3
    @nevada_city = Location.new 'Nevada City', 0, 5, 1
    @virginia_city = Location.new 'Virginia City', 3, 3, 2
    @midas = Location.new 'Midas', 5, 0, 2
    @el_dorado = Location.new 'El Dorado Canyon', 10, 0, 4

    @sutter_creek.set_neighbors @coloma, @angels_camp, nil, nil
  end

  # UNIT TESTS FOR METHOD
  # Equivalence classes:
  # valid: random_int(0,3) = 0, 1, 2, or 3
  # invalid: random_int(0,3) < 0
  def test_random_int
    assert_includes([0, 1, 2, 3], @g.random_int(0, 3))
  end

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
  # valid: location = @sutter_creek -> next_location = @angels_camp || @coloma
  # invalid: location = @sutter_creek -> next_location != @angels_camp || @coloma
  def test_next_location
    assert_includes([@angels_camp, @coloma], @g.next_location(@sutter_creek))
  end

  # UNIT TESTS FOR METHOD prospect(location) returns [gold,silver]
  # Equivalence classes:
  def test_prospect
    assert_includes([[0, 0], [1, 1], [2, 0]], @g.prospect(@virginia_city))
  end

  # UNIT TESTS FOR METHOD search(location, player)
  # Equivalence classes:

  # UNIT TESTS FOR METHOD stop_search?(silver, gold)
  # min_gold = 2 and min_silver = 3 if the player is on their last or penultimate location visit.
  # Equivalence classes:
  # silver == 0 && gold == 0 -> true
  # gold < min_gold && silver < min_silver -> true
  # gold > min_gold || silver > min_silver -> false
  def test_stop_search_found_none
    assert_equal(@g.stop_search?(0, 0), true)
  end

  def test_stop_search_not_enough
    assert_equal(@g.stop_search?(0, 0), true)
  end

  def test_stop_search_false
    assert_equal(@g.stop_search?(3, 3), false)
  end

  # UNIT TESTS FOR METHOD display_starting_message(player)
  def test_display_starting_message
    @player = Player.new @sutter_creek, 0, 0
    @player.name = '1'
    assert_output("Prospector 1 starting in Sutter Creek.\n") { @g.display_starting_message(@player) }
  end

  # UNIT TESTS FOR METHOD reset(player)
  def test_reset
    @player = Player.new @sutter_creek, 0, 0
    @player.gold = 1
    @player.silver = 2
    @player.visits = 3
    @player.days = 4

    @g.reset(@player)
    assert(@player.gold.zero? && @player.silver.zero? && @player.visits.zero? && @player.days.zero?)
  end

  # UNIT TESTS FOR METHOD display_results(player)
  # should just show set values with variable and printed names matching e.g. 6 days, prospector 2, 2 gold
  def test_display_results
    @player = Player.new @sutter_creek, 0, 0
    @player.name = 2
    @player.gold = 2
    @player.silver = 0
    @player.days = 6
    assert_output("After 6 days, Prospector #2 returned to San Francisco with:\n" +
      "\t2 ounces of gold.\n"   +
      "\t0 ounces of silver.\n" +
      "\tHeading home with $41.34.\n\n") { @g.display_results(@player) }
  end

  # UNIT TESTS FOR METHOD move_from(location, player)
  # player.visits < 5 -> location is one of its neighbors
  # player.visits >= 5 -> return, location remains same
  def test_move_from_location
    @player.visits = 3
    @player.current_location = @sutter_creek
    @g.move_from_location(@player)
    assert_includes([@coloma, @angels_camp], @player.current_location)
  end

  def test_do_not_move
    @player.visits = 7
    @player.current_location = @sutter_creek
    @g.move_from_location(@player)
    assert_equal(@sutter_creek, @player.current_location)
  end

  # UNIT TESTS FOR METHOD display_move_from(last_location, player)
  def test_display_move_from
    @player = Player.new @sutter_creek, 0, 0
    @player.current_location = @coloma
    @player.gold = 0
    @player.silver = 0
    assert_output("Heading from Sutter Creek to Coloma, " +
      "holding 0 ounces of gold and 0 ounces of silver.\n") { @g.display_move_from(@sutter_creek, @player) }
  end
end
