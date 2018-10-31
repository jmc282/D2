require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'game'
require_relative 'location.rb'
require_relative 'player.rb'
# Test Suite for player
class LocationTest < Minitest::Test
  # 10 is seed value
  def setup
    @l = Location.new 'Sutter Creek', 0, 2, 2
  end

  # UNIT TESTS FOR METHOD display_findings(silver_found, gold_found)
  # Equivalence classes:
  # silver_found == 0 gold_found == 0 -> display no metals found
  # silver_found > 0 -> display metals found
  # gold_found > 0   -> display metals found
  # both > 0         -> display metals found

  # If there are no metals, should print that there are none
  def test_no_metal_found
    assert_output("\tFound no precious metals in Sutter Creek.\n") { @l.display_findings(0, 0) }
  end

  # If only silver is found, print number of silver found
  def test_positive_silver_found
    assert_output("\tFound 1 ounce of silver in Sutter Creek.\n") { @l.display_findings(1, 0) }
  end

  # If only gold is found, print number of gold found
  def test_positive_gold_found
    assert_output("\tFound 1 ounce of gold in Sutter Creek.\n") { @l.display_findings(0, 1) }
  end

  # If both are found, print both
  def test_both_found
    assert_output("\tFound 2 ounces of gold and 3 ounces of silver in Sutter Creek.\n") { @l.display_findings(2, 3) }
  end

  # UNIT TESTS FOR METHOD display_metal_found(amount, metal)
  # Equivalence classes:
  # amount = 0  -> puts '1 ounce of metal'
  # amount > 0  -> puts 'x ounces of metal'
  # amount <= 0 -> returns nil

  # If only 1 metal, should say "ounce" in print
  def test_metal_found_one
    assert_output('1 ounce of gold ') {@l.display_metal_found(1, 'gold')}
  end

  # If multiple metal found, should say "ounces" in print
  def test_metal_found_some
    assert_output('3 ounces of adamantite ') {@l.display_metal_found(3, 'adamantite')}
  end

  # If no metal found, should return nil
  def test_metal_found_none
    assert_nil @l.display_metal_found(0, 'silver')
  end

  # UNIT TESTS FOR METHOD get_units(amount)
  # Equivalence classes:
  # amount < 0  -> raises 'Cannot get less than 1 unit.'
  # amount = 1  -> returns '1 ounce'
  # amount != 1 -> returns 'x ounces'

  # If negative amount, raises error
  def test_get_negative_unit
    assert_raises 'Cannot get less than 0 units.' do
      @l.get_units(-2)
    end
  end

  # If single unit, return singular
  def test_get_one_unit
    assert_equal @l.get_units(1), '1 ounce'
  end

  # If multiple units, return plural
  def test_get_some_unit
    assert_equal @l.get_units(3), '3 ounces'
  end
end
