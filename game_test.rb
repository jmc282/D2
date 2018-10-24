require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

require_relative 'game'

class GameTest < Minitest::Test


    def setup
      @g = Game::new 10
    end

	def test_random_int
	end

	def test_display_starting_message
	end

	# UNIT TESTS FOR METHOD get_units(amount)
	# Equivalence classes:
	# amount = 1 -> returns "1 ounce"
	# amount != 1 -> returns "#{amount} ounces" 
	# amount = (not a number)
	def test_get_units_1
		assert_equal @g.get_units(1), "1 ounce"
	end

	def test_get_units_not_1
		assert_equal @g.get_units(5), "5 ounces"
	end


	def test_convert_currency
	end

	def test_stop_search?
	end

end
