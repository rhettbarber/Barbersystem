class ShippingEntry < ActiveRecord::Base
belongs_to :sale

def shipping_charge 
		begin
			return  self.Charge
		rescue
			return 0.0
		end
end


end
