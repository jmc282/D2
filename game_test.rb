require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

require_relative 'game'

class GameTest < Minitest::Test

	# 10 is seed value
    def setup
      @g = Game::new 10
    end

	# UNIT TESTS FOR METHOD
	def test_random_int
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
    assert_raise @g.get_units(-1), 'Cannot get less than 1 unit.'
  end

	# UNIT TESTS FOR METHOD convert_currency(gold, silver)
  # Equivalence classes:
  # gold == 1 silver == 0 -> returns "$20.67"
  # gold == 2 silver == 3 -> returns "45.27"
  # gold < 0 silver < 0 -> raises 'Currency cannot be negative.'
	def test_convert_currency
    assert_equal @g.convert_currency(1, 0), '$20.67'
	end

  def test_convert_currency_mixed
    assert_equal &g.convert_currency(2, 3), '$45.27'
  end

  def test_convert_currency_negative
    assert_raise @g.convert_currency(-1, -1), 'Currency cannot be negative.'
  end

	# UNIT TESTS FOR METHOD stop_search?(silver, gold)
	# Equivalence classes:
	# silver == 0, gold == 0	true
	# silver == 0, gold != 0	false
	# silver != 0, gold == 0	false
	# silver != 0, gold != 0	false
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
end
