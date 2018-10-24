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

	def test_display_starting_message
	end

	# UNIT TESTS FOR METHOD get_units(amount)
	# Equivalence classes:
	# amount == 1 -> returns "1 ounce"
	# amount != 1 -> returns "#{amount} ounces" 
	# amount == (not a number)??
	def test_get_units_ounce
		assert_equal @g.get_units(1), "1 ounce"
	end

	# UNIT TESTS FOR METHOD 
	def test_get_units_ounces
		assert_equal @g.get_units(5), "5 ounces"
	end

	# UNIT TESTS FOR METHOD 
	def test_convert_currency
	end

	# UNIT TESTS FOR METHOD stop_search?(silver, gold)
	# Equivalence classes:
	# silver == 0, gold == 0
	# silver == 0, gold != 0
	# silver != 0, gold == 0
	# silver != 0, gold != 0
	def test_stop_search_if_none_found
		assert_equal @g.stop_search?(0, 0), true
	end

	def test_do_not_stop_search
		assert_equal @g.stop_search?(1, 0), false
	end

end
