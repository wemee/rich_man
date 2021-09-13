require_relative '../lib/dice'
require_relative '../lib/game'
require_relative '../lib/house'
require_relative '../lib/map'
require_relative '../lib/player'

game = Game.new(40)

round = 0
until game.some_one_broken?
	round += 1
	puts "Round: #{round}"
	game.run
	# sleep 0.25
end

game.print_result

game = Game.new(40)

round = 0
until game.some_one_broken?
	round += 1
	puts "Round: #{round}"
	game.run
	# sleep 0.25
end

game.print_result
