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
