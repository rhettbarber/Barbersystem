class ShipTo < ActiveRecord::Base

@@HANDLING_CHARGE = 0.00

  belongs_to :customer
  has_one :purchase
  has_one :viewable_purchase

  validates_length_of         :Zip,    :within => 3..14
  
  validates_presence_of  :Address, :City, :Country, :Name, :PhoneNumber,:State, :Zip
  
  attr_accessible :Address, :Address2, :City, :Company, :Country, :FaxNumber, :Name, :PhoneNumber,:State, :Zip

cattr_accessor  :current_purchase_id


  def self.valid_attribute?(attr, value)
            mock = self.new(attr => value)
            if mock.valid?
                   return true
            else
                    $stdout.puts "mock.errors: " + mock.errors.to_s
                    $stdout.puts  "mock.errors.has_key?(attr): " + mock.errors.has_key?(attr).to_s
                    $stdout.puts  "mock.errors.values_at(attr): " + mock.errors.values_at(attr).to_s
                    if mock.errors.has_key?(attr)
                          return false

                    else
                          return true
                    end
            end
  end
 
 
def self.ship_to_from_customer_billing(customer)
	ship_to = ShipTo.new
	ship_to.Address = customer.Address
	ship_to.Address2 = customer.Address2
	ship_to.City = customer.City
	ship_to.Company = customer.Company
	ship_to.Country = customer.Country
	ship_to.Name = customer.FirstName + ' ' + customer.LastName
	ship_to.State = customer.State
	ship_to.Zip = customer.Zip
	ship_to.store_id = customer.store_id
	ship_to.PhoneNumber = customer.PhoneNumber
	ship_to.FaxNumber = customer.FaxNumber
	ship_to.customer_id = customer.id
	ship_to
end


def origin
  ActiveMerchant::Shipping::Location.new(country: "US", state: "GA", city: "Odum", postal_code: "31555")
end

def destination
  #ActiveMerchant::Shipping:: Location.new(country: "US", state: self.state, city: city, postal_code: self.Zip)
  ActiveMerchant::Shipping:: Location.new(country: "US",  postal_code: self.Zip)
end

def packages
          length = 7
          width = 7
          height =  1

          if ShipTo.current_purchase_id
                 purchase = Purchase.find ShipTo.current_purchase_id
          end

         if purchase
                 weight =    purchase.total_weight
         else
               weight =  1
         end


          logger.debug "weight: " + weight.to_s
          #weight_in_grams = weight.lbs.to.grams.to_f

          weight_in_grams =  1  # weight.to_f   *    453.592

          logger.debug "weight_in_grams: " +  weight_in_grams.to_s
          package = ActiveMerchant::Shipping::Package.new( weight_in_grams    ,  [length, width, height] )
end

def get_rates_from_shipper(shipper)
        begin
                    response = shipper.find_rates(origin, destination, packages)

                    the_response =       response.rates      #.select{|sss| ShippingService.available_service_codes_array.include?(sss.service_code)  }.sort_by(&:price)
                    logger.warn "###########################################"
                    logger.warn "###########################################"
                    logger.warn "ShippingService.available_service_codes_array: " + ShippingService.available_service_codes_array.to_s
                    logger.warn "the_response: " + the_response.to_a.to_s
                    logger.warn "###########################################"
                    logger.warn "###########################################"
                    return the_response
        rescue  Exception => e
                      logger.warn "SHIPPING API ERROR"
                      logger.warn "e.message: " +  e.message.to_s
                      logger.warn "e.backtrace.inspect: " +  e.backtrace.inspect
                      #'unavailable'
                       return  e.message.to_s
        end

end

def ups_rates
  ups = ActiveMerchant::Shipping::UPS.new(:login => 'rhettro', :password => 'onlineart', :key => '7C0F90B0C9F0B730')
  logger.warn "########################################### get_rates_from_shipper ups"
  get_rates_from_shipper(ups)
end


def usps_rates
              usps = ActiveMerchant::Shipping::USPS.new(:login => "699BARBE5543",:password => "983PK26KV621" )
              logger.warn "########################################### get_rates_from_shipper usps"
              get_rates_from_shipper(usps)
end







 #def ups_services
 #
 #                 #Package initialize(name, grams_or_ounces, value, quantity, options = {})
 #
 #
 #                    # Package up a poster and a Wii for your nephew.
 #                    packages = [    ActiveMerchant::Shipping::Package.new(  (7.5 * 16),       [15, 10, 4.5],     :units => :imperial)    ]
 #
 #                    # You live in Beverly Hills, he lives in Ottawa
 #                    origin = ActiveMerchant::Shipping::Location.new(      :country => 'US',
 #                                                                          :state => 'CA',
 #                                                                          :city => 'Beverly Hills',
 #                                                                          :zip => '90210')
 #
 #                    destination = ActiveMerchant::Shipping::Location.new( :country => 'CA',
 #                                                                          :province => 'ON',
 #                                                                          :city => 'Ottawa',
 #                                                                          :postal_code => 'K1P 1J1')
 #
 #
 #
 #                    ups = ActiveMerchant::Shipping::UPS.new(:login => 'rhettro', :password => 'onlineart', :key => '7C0F90B0C9F0B730')
 #                    response = ups.find_rates(origin, destination, packages)
 #
 #                    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price    ]}
 #
 #                    g = "g"
 #
 #                    return ups_rates
 #end







###################################################################################################################################################
#  def shipping_service_price(carrier, service_name, purchase)
##:ups_pickup_type => 01 (daily), 03 (customer counter), 06 (one time pickup), 07 (on call air pickup), 11 (retail rates / UPS Store), 19 (letter center), 20 (air service center)
##    begin
#                  service_name = service_name.to_sym
#                  my_origin = ActiveShipping::Location.new(:country => 'US', :postal_code => '31555')
#                  my_us_dest = ActiveShipping::Location.new(:country => 'US', :postal_code => self.Zip )
#                  total_weight = purchase.total_weight
#                  if self.customer.PriceLevel > 0 #and self.customer.CustomText3 ==  '1'
#                              residential = false
#                  else
#                              residential = true
#                  end
#                  customer_type_number = '04'  # our origin customer type.. us
#                  if carrier == 'ups'
#
#                                  #ups_service_object = ActiveShipping::UpsGateway.new(:username => "rhettro", :ups_account => "392182", :ups_license => "7C0F90B0C9F0B730", :ups_pickup_type => "01", :password => "onlineart" )
#                                  #shipping_price =  ups_service_object.estimate_shipping_cost( customer_type_number , service_name , my_origin, my_us_dest, total_weight, residential  )
#
#
#                                  #ups_service_object = ActiveShipping::UpsGateway.new(:username => "rhettro", :ups_account => "392182", :ups_license => "7C0F90B0C9F0B730", :ups_pickup_type => "01", :password => "onlineart" )
#                                  #shipping_price =  ups_service_object.estimate_shipping_cost( customer_type_number , service_name , my_origin, my_us_dest, total_weight, residential  )
#
#
#
#
#
#                                  # Package up a poster and a Wii for your nephew.
#                                  packages = [    ActiveMerchant::Shipping::Package.new(  100,   [93,10], :cylinder => true),   ActiveMerchant::Shipping::Package.new(  (7.5 * 16),       [15, 10, 4.5],     :units => :imperial)    ]
#
#                    # You live in Beverly Hills, he lives in Ottawa
#                    origin = ActiveMerchant::Shipping::Location.new(      :country => 'US',
#                                                :state => 'CA',
#                                                :city => 'Beverly Hills',
#                                                :zip => '90210')
#
#                    destination = ActiveMerchant::Shipping::Location.new( :country => 'CA',
#                                                :province => 'ON',
#                                                :city => 'Ottawa',
#                                                :postal_code => 'K1P 1J1')
#
#
#
#                                  ups = ActiveMerchant::Shipping::UPS.new(:login => 'rhettro', :password => 'onlineart', :key => '7C0F90B0C9F0B730')
#                                  response = ups.find_rates(origin, destination, packages)
#
#                                  ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
#
#                                     g = "g"
#
#                  elsif carrier == 'usps'
#                                  usps_service_object = ActiveShipping::UspsGateway.new(:username => "699BARBE5543",:password => "983PK26KV621" )
#                                  shipping_price =  usps_service_object.estimate_shipping_cost( service_name , my_origin, my_us_dest, total_weight )
#                  else
#                                    '776'
#                  end
#                  return shipping_price  + 2
#    #rescue  Exception => e
#    #              logger.warn "SHIPPING API ERROR"
#    #              logger.warn "e.message: " +  e.message.to_s
#    #              logger.warn "e.backtrace.inspect: " +  e.backtrace.inspect
#    #              'shipping service unavailable'
#    #end
#
#  end

###################################################################################################################################################

 
 
 
 
  
#@@service_types = {
#	:ground => "03", #UPS Ground
#	:priority => "12", #UPS 3-Day Select
############################################ 2nd day air
#	:express => "01" #UPS Next Day Air
#}  
#################################
#		CustomerTypes = {
#			'wholesale' => '01',
#			'ocassional' => '02',
#			'retail' => '04'
#		}

###################################################################################################################################################
###################################################################################################################################################
#def shipping_service_price_before(carrier, service_name, purchase)
##:ups_pickup_type => 01 (daily), 03 (customer counter), 06 (one time pickup), 07 (on call air pickup), 11 (retail rates / UPS Store), 19 (letter center), 20 (air service center)
#     	begin
#                     service_name = service_name.to_sym
#                     my_origin = ActiveShipping::Location.new(:country => 'US', :postal_code => '31555')
#                     my_us_dest = ActiveShipping::Location.new(:country => 'US', :postal_code => self.Zip )
#                     total_weight = purchase.total_weight
#					 if self.customer.PriceLevel > 0 #and self.customer.CustomText3 ==  '1'
#                        residential = false
#				 	else
#                       residential = true
#          end
#           customer_type_number = '04'  # our origin customer type.. us
#            if carrier == 'ups'
#                     	ups_service_object = ActiveShipping::UpsGateway.new(:username => "rhettro", :ups_account => "392182", :ups_license => "7C0F90B0C9F0B730", :ups_pickup_type => "01", :password => "onlineart" )
#                     	shipping_price =  ups_service_object.estimate_shipping_cost( customer_type_number , service_name , my_origin, my_us_dest, total_weight, residential  )
#    			 	elsif carrier == 'usps'
#    			 		usps_service_object = ActiveShipping::UspsGateway.new(:username => "699BARBE5543",:password => "983PK26KV621" )
#    			 		shipping_price =  usps_service_object.estimate_shipping_cost( service_name , my_origin, my_us_dest, total_weight )
#    				else
#                   		'776'
#               		end
#               	return shipping_price  + 2
#       rescue  Exception => e
#                           logger.warn "SHIPPING API ERROR"
#                           logger.warn "e.message: " +  e.message.to_s
#                            logger.warn "e.backtrace.inspect: " +  e.backtrace.inspect
#                          'shipping service unavailable'
#            end
#
#end
#
####################################################################################################################################################
#
#
#
#
#
#
####################################################################################################################################################
#
#def shipping_service_price_before_usps(service_name)
#            begin
#                         if self.customer.PriceLevel > 0
#                         	 api_shipping_object = Shipping::Base.new :zip => self.Zip,  :sender_zip => 31555, :weight => self.purchase.total_weight, :service_type => service_name , :customer_type => 'wholesale'
#                      	else
#                        	 api_shipping_object = Shipping::Base.new :zip => self.Zip,  :sender_zip => 31555, :weight => self.purchase.total_weight, :service_type => service_name , :customer_type => 'retail'
#                        end
#                   		return api_shipping_object.ups.price  + 2
#            rescue
#                          'shipping service unavailable'
#            end
#end
#





end
