LIB_PATH = '../lib'
require "#{LIB_PATH}/dice"
require "#{LIB_PATH}/game"
require "#{LIB_PATH}/house"
require "#{LIB_PATH}/map"
require "#{LIB_PATH}/player"

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