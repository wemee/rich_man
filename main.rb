class Player

	attr_reader :cash, :name, :houses_idx

	def initialize name='Anonymous', game
		@cash = 500000
		@name = name
		@game = game
		@houses_idx = []
	end

	def add_house_idx idx
		@houses_idx << idx
	end

	def remove_house_idx idx
		@houses_idx.delete idx
	end

	def pay amount
		@cash -= amount
	end

	def receive amount
		@cash += amount
	end

	def broken?
		if @cash < 0
			if(@houses_idx.size >= 1)
				@game.requisition self
				broken?
			else
				return true
			end
		else
			return false
		end
	end
end

class House

	attr_accessor :owner, :price, :level, :idx

	def initialize price, idx
		@price = price
		@level = 0
		@owner = nil
		@max_level = 5
		@idx = idx
	end

	def sell_price
		(@price + (@price/5)*level)*9/10
	end

	def sold
		@level = 0
		@owner = nil
	end

	def fee
		(@price/5) * (@level+1)
	end

	def upgrade_cost
		@price/5
	end

	def can_upgrade?
		@level < @max_level
	end

	def upgrade
		@level += 1
	end
end

class Map
	def initialize size
		@size = size
		init_houses
	end

	def get_house position
		@houses[position]
	end

	def print_result
		@houses.each_with_index{|house, idx|
			print "house_#{idx}: #{house.level} "
			puts "" if(idx%5 == 0)
		}
	end

	def get_cheapest_house houses_idx
		return nil if(houses_idx.size == 0)

		house = get_house(houses_idx.first)
		houses_idx.each{|idx|
			house = get_house(idx) if(house.sell_price < get_house(idx).sell_price)
		}
		return house
	end

	private
	def init_houses
		@houses = []
		@size.times{|n|
			@houses << House.new(10000 + n*1000, n)
		}
	end
end

class Dice
	def roll
		rand(6)
	end
end

class Game
	def initialize map_size
		@map_size = map_size
		@round_fee = 5000
		reset
	end

	def run
		@players.each{|player|
			@positions[player] += setps
			if @positions[player] >= @map_size
				@positions[player] %= @map_size
				player.receive @round_fee
				puts "#{player.name} recivie round fee"
			end

			house = @map.get_house(@positions[player])
			
			if house.owner.nil?
				buy_house_by(player, house) if player.cash >= house.price
			elsif house.owner == player
				upgrade_house_by(player, house) if player.cash >= house.upgrade_cost
			else
				pay_fee player, house
			end
		}
	end

	def buy_house_by player, house
		player.pay house.price
		house.owner = player
		player.add_house_idx house.idx
		puts "#{player.name} buy house at #{@positions[player]}, cost #{house.price}"
	end

	def upgrade_house_by player, house
		if house.can_upgrade?
			player.pay house.upgrade_cost
			house.upgrade
			puts "#{player.name} upgrade house at #{@positions[player]}, cost #{house.upgrade_cost}"
		end
	end

	def pay_fee player, house
		fee = house.fee
		owner = house.owner

		player.pay fee
		owner.receive fee
		puts "#{player.name} pay fee for #{owner.name} at #{@positions[player]}, cost #{fee}"
	end

	def requisition player
		house = @map.get_cheapest_house player.houses_idx
		return if house.nil?

		player.receive house.sell_price
		player.remove_house_idx house.idx
		house.sold

		puts "#{player.name} sold house #{house.idx}, receive #{house.sell_price}"
	end

	def setps
		setps = 0
		@dice.each{|d|
			setps += d.roll
		}
		return setps
	end

	def reset
		@players = [Player.new('John', self), Player.new('Bob', self)]
		@map = Map.new(@map_size)
		@dice = [Dice.new, Dice.new]
		@positions = {@players[0] => 0, @players[1] => 0}
	end

	def print_result
		puts " #{'_'*15}"
		@players.each{|player|
			puts "| Player #{player.name}"
			puts "| Cash: #{player.cash}"
		}
		puts " #{'_'*15}"

		@map.print_result
	end

	def some_one_broken?
		result = false
		@players.each{|player|
			if player.broken?
				result = true
				break;
			end
		}
		return result
	end
end

require 'dice'
require 'game'
require 'house'
require 'main'
require 'map'
require 'player'

game = Game.new(40)

round = 0
until game.some_one_broken?
	round += 1
	puts "Round: #{round}"
	game.run
	# sleep 0.25
end

game.print_result