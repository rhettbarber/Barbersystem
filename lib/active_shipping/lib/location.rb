#Copyright 2007 New Medio.  This file is part of ActiveShipping.  See README for license and legal information.

module ActiveShipping
	class Location
		attr_accessor :company, :name, :address1, :address2, :address3, :city, :state, :postal_code, :country, :handling_rules

		def initialize(options = {})
			options.each do |opt, val|
				self.send("#{opt}=".intern, val)
			end
			@carriers = {}
		end

		def add_carrier(carrier)
			@carriers[carrier.carrier_code] = carrier
		end

		def remove_carrier(carrier)
			case carrier
				when String
					@carriers.delete(carrier)
				else
					@carriers.delete(carrier.carrier_code)
			end
		end

		def estimate_shipping_handling_costs(shipping_method, destination, weight = nil, num_items = nil, value = nil, other_info = nil)
			results = {}
			best_total_cost = nil
			best_carrier = nil
			@carriers.each do |carrier_code, carrier_gateway| 
				begin
					
					if @handling_rules
						shipping_cost, handling_cost, total_cost = @handling_rules.estimate_shipping_handling_costs(shipping_method, self, destination, weight, num_items, value, carrier_gateway, other_info)
					else
						shipping_cost = carrier_gateway.estimate_shipping_cost(shipping_method, self, destination, weight, num_items, value, other_info)
						handling_cost = 0
						total_cost = shipping_cost
					end

					results[carrier_code] = {
						:carrier_code => carrier_code,
						:status => :success,
						:shipping_cost => shipping_cost,
						:handling_cost => handling_cost,
						:total_cost => total_cost
					}
					
					if best_total_cost == nil
						best_carrier = carrier_code
						best_total_cost = total_cost
					end
				rescue
					results[carrier_code] = {
						:carrier_code => carrier_code,
						:status => :error
					}
				end
			end
			if best_total_cost != nil
				results[:best] = results[best_carrier]
			end

			return results
		end
	end
end

