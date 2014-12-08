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
