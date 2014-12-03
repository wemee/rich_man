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
