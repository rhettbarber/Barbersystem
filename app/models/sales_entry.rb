class SalesEntry < ActiveRecord::Base
belongs_to :sale
belongs_to :item
	
def extended_total_at_commissioned_price
			self.Quantity * self.commissioned_price
end
	
	
def commissioned_price
		@special_price_levels = ['0','1']
		if self.sale.customer
					if   @special_price_levels. include?(self.sale.customer.PriceLevel.to_s)
							return self.item.lowest_quantity_discount_price_b
					else
							return self.Price
					end
		else
					return 0.0
		end
end


def commission_percent_sale
		if 	self.item.CommissionPercentSale > 0
				self.item.CommissionPercentSale * 0.01
		else
				0.0
		end
end


	
def fixed_total
	return item.CommissionAmount * self.Quantity
end
	
def percent_total
	return  self.extended_total_at_commissioned_price *  self.commission_percent_sale
end	
	
def combined_total
			return self.percent_total  +   self.fixed_total
end
	
	
	
	
	
	
	
	
	
	
end
