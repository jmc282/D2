require_relative 'game.rb'
require_relative 'location.rb'

# Prints the usage message to STDOUT and then exit the program
# exits with code 1 to indicate there was an error

def show_usage_and_exit
  puts "Usage:\nruby gold_rush.rb *seed* *num_prospectors*"
  puts "*seed* should be an integer\n*num_prospectors* should be a non-negative integer"
  exit 1
end

# Returns true if and only if:
# 1. There are exactly two arguments
# 2. Both arguments are integers
# 3. The *num_prospectors* argument, when converted to an integer, is nonnegative
# Returns false otherwise

def valid_args?(args)
  args.count == 2 && args[1].to_i > 0
rescue StandardError
  false
end

# EXECUTION STARTS HERE

# If arguments are valid, create a new game using *seed* and *num_players* arguments, and play the game
# Otherwise, show proper usage message and exit program

show_usage_and_exit unless valid_args?(ARGV)

which_player = 0
num_players = ARGV[1].to_i
g = Game.new(ARGV[0].to_i)
num_players.times do
  which_player += 1
  g.play(which_player.to_s)
end