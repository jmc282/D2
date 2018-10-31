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
    @player = Player.new nil, 0, 0
  end

  # UNIT TEST FOR METHOD player_name(name)
  def test_player_name
    @player.player_name('Bob')
    assert_equal('Bob', @player.name)
  end

  # UNIT TEST FOR METHOD add_day
  def test_add_day
    @player.days = 1
    @player.add_day
    assert_equal(2, @player.days)
  end

  # UNIT TEST FOR METHOD add_visit
  def test_add_visit
    @player.visits = 1
    @player.add_visit
    assert_equal(2, @player.visits)
  end

  # UNIT TESTS FOR METHOD add_visit
  # Equivalence classes:
  # raise 'Cannot have a minimum less than zero.' if @visits < 0
  # return [0, 0] if @visits <= 2
  # [2,3]

  # If visits is negative, raises error
  # EDGE CASE
  def test_prospect_min_negative
    @player.visits = -1
    assert_raises('Cannot have a minimum less than zero.') { @player.prospect_min }
  end

  # If visits is zero, returns array of two zeroes
  def test_prospect_min_zero
    mock_player = Minitest::Mock.new("Player")
    def mock_player.visits; 0; end
    assert_equal([0, 0], @player.prospect_min(mock_player))
  end

  # If visits is greater than 3, returns 2 and 3 in array
  def test_prosect_min_last_two
    mock_player = Minitest::Mock.new("Player")
    def mock_player.visits; 4; end
    assert_equal([2, 3], @player.prospect_min(mock_player))
  end
end
