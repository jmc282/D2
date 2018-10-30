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

  # UNIT TESTS FOR METHOD method?(args?)
  # Equivalence classes:
  # classes go here


end
