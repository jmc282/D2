require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'game'
require_relative 'location.rb'
require_relative 'player.rb'
# Test Suite for player
class PlayerTest < Minitest::Test
  # 10 is seed value
  def setup
    @g = Game.new(10)
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
end
