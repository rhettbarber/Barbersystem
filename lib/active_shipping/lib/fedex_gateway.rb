#Copyright 2007 New Medio.  This file is part of ActiveShipping.  See README for license and legal information.

module ActiveShipping
	class FedexGateway
		attr_accessor :fedex_account, :fedex_meter, :fedex_packaging, :fedex_dropoff, :test_mode, :debug_mode, :password
		def initialize(options)
			if(options[:dsn])
				options = options.merge(Util.parse_dsn(options.delete(:dsn)))
			end
			@fedex_account = options[:fedex_account]
			@fedex_meter = options[:fedex_meter]
			@fedex_packaging = options[:fedex_packaging] || "YOURPACKAGING"
			@fedex_dropoff = options[:fedex_dropoff] || "REGULARPICKUP"
			@test_mode = options[:test_mode]
			@debug_mode = options[:debug_mode]
		end

		@@rate_map = {
			:ground => ["FDXG", "FEDEXGROUND"],
			:priority => ["FDXE", "FEDEX2DAY"],
			:express => ["FDXE", "STANDARDOVERNIGHT"]
		}

		@@transaction_id = 0  #Not sure how important this is
		def estimate_shipping_cost(shipping_method, origin, destination, weight, num_items = nil, value = nil, other_info = nil)
			@@transaction_id += 1
			transaction_id = @@transaction_id
			fedex_carrier, fedex_service = @@rate_map[shipping_method]
			current_time = Time.now.gmtime
			ship_date = "#{current_time.year}-#{sprintf("%02d",current_time.month)}-#{sprintf("%02d", current_time.day)}"

			return fedex_ship(transaction_id, fedex_carrier, fedex_service, origin, destination, weight, ship_date)
		end

		def carrier_code
			FedexGateway.carrier_code
		end

		def self.carrier_code
			:fedex
		end

		def self.carrier_name
			"Fedex"
		end

		private
		def fedex_ship(transaction_id, fedex_carrier, fedex_service, origin, destination, weight, ship_date)
			xml_data = rate_xml(transaction_id, fedex_carrier, fedex_service, origin, destination, weight, ship_date)

			data = ActiveShipping::Util.run_http_post_connection(connection_uri, xml_data).body

			if data.match(/Error/s)
				if data.match(/<Code>(.*)<\/Code>/s)
					error_code = $1
				else
					error_code = "unknown"
				end

				if data.match(/<Message>(.*)<\/Message>/s)
					error_message = $1
				else
					error_message = "unknown"
				end

				raise "#{error_code}:#{error_message}"
			else
				if data.match(/<NetCharge>(.*)<\/NetCharge>/s)
					return BigDecimal.new($1)
				else
					raise "Could not find rate."
				end
			end
		end

		def rate_xml(transaction_id, fedex_carrier, fedex_service, origin, destination, weight, ship_date)
			weight = sprintf("%0.1f", weight)
			
			return <<EOF
<?xml version="1.0" encoding="UTF-8" ?>
<FDXRateRequest xmlns:api="http://www.fedex.com/fsmapi" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="FDXRateRequest.xsd">
<RequestHeader>
	<CustomerTransactionIdentifier>#{transaction_id}</CustomerTransactionIdentifier>
	<AccountNumber>#{@fedex_account}</AccountNumber>
	<MeterNumber>#{@fedex_meter}</MeterNumber>
	<CarrierCode>#{fedex_carrier}</CarrierCode>
</RequestHeader>
<ShipDate>#{ship_date}</ShipDate>
<DropoffType>#{@fedex_dropoff}</DropoffType>
<Service>#{fedex_service}</Service>
<Packaging>#{@fedex_packaging}</Packaging>
<WeightUnits>LBS</WeightUnits>
<Weight>#{weight}</Weight>
<OriginAddress>
	#{origin.state ? "<StateOrProvinceCode>" + origin.state + "</StateOrProvinceCode>" : ""}
	#{origin.postal_code ? "<PostalCode>" + origin.postal_code + "</PostalCode>" : ""}
	<CountryCode>#{origin.country}</CountryCode>
</OriginAddress>
<DestinationAddress>
	#{destination.state ? "<StateOrProvinceCode>" + destination.state + "</StateOrProvinceCode>" : ""}
	#{destination.postal_code ? "<PostalCode>" + destination.postal_code + "</PostalCode>" : ""}
	<CountryCode>#{destination.country}</CountryCode>
</DestinationAddress>
<Payment>
	<PayorType>SENDER</PayorType>
</Payment>
<PackageCount>1</PackageCount>
</FDXRateRequest>
EOF
		end

		def connection_uri
			@test_mode ? FedexGateway.test_uri : FedexGateway.prod_uri
		end

		def self.test_uri
			"https://gatewaybeta.fedex.com:443/GatewayDC"
		end

		def self.prod_uri
			"https://gateway.fedex.com:443/GatewayDC"
		end
	end
end
ActiveShipping::Base.register_shipping_module(ActiveShipping::FedexGateway)
