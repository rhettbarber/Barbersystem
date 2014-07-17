#Copyright 2007 New Medio.  This file is part of ActiveShipping.  See README for license and legal information.

module ActiveShipping
	module Handling
		class Base
		end

		class Generic < Base
			attr_accessor :per_pound, :per_order, :per_item, :shipping_multiplier
			def initialize(options = {})
				if options[:dsn]
					options = options.merge(ActiveShipping::Base.parse_dsn(options.delete(:dsn)))
				end
				@per_order = options[:per_order]
				@per_item = options[:per_item]
				@shipping_multiplier = options[:shipping_multiplier]
				@per_pound = options[:per_pound]
			end

			def estimate_shipping_handling_costs(shipping_method, origin, destination, weight = nil, num_items = nil, value = nil, carrier_gateway = nil, other_info = nil)
				handling = 0.0
				shipping = nil

				if carrier_gateway != nil
					shipping = carrier_gateway.estimate_shipping_cost(shipping_method, origin, destination, weight, num_items, value, other_info)
				end

				if @per_order != nil
					handling += @per_order
				end

				if num_items != nil && @per_item != nil
					handling += num_items * @per_item
				end

				if weight != nil && @per_pound != nil
					handling += weight * @per_pound
				end

				if shipping != nil && @shipping_multiplier != nil
					handling += shipping * @shipping_multiplier
				end

				total = (shipping != nil && handling != nil) ? shipping + handling : nil
				return [shipping, handling, total]
			end
		end
	end
end