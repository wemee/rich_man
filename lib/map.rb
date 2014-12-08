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
