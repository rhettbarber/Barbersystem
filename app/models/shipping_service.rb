class ShippingService < ActiveRecord::Base
  
has_many :purchases

has_many :viewable_purchases

def self.available_service_names
            codes_array = Set.new
            shipping_services = ShippingService.where("web_carrier_name != ? and CarrierID in (?) ",  '0', [3,4]  ).all
            # logger.warn "shipping_services: " + shipping_services.to_s
            shipping_services.each do |ss|
                           logger.warn "shipping_services Code: " +  ss.web_name.to_s
                          codes_array.add ss.web_name
            end
             return codes_array
end




def self.available_services
        #self.find(:all,:conditions =>  ["CarrierID in (?) and web_name != '0'" , [3,4]   ])
     return ShippingService.where("web_carrier_name != ? and CarrierID in (?) ",  '0', [3,4]  )
end



def weight_tier_shipping_price_UNFINISHED(purchase)  
                        weight = purchase.total_weight  
                                                         if  self.exists?( purchase.ShippingServiceID  ) 
                                                                               shipping_service = ShippingService.find( purchase.ShippingServiceID ) 
                                                                              tier1 = shipping_service.Value1.to_i
                                                                              tier1_price = shipping_service.Charge1
                                                                              tier1 = tier1                                                              
                                                                             tier2 = shipping_service.Value2.to_i
                                                                              tier2_price = shipping_service.Charge2                                                              
                                                                              tier2 = tier2 - 1
                                                                              tier3 = shipping_service.Value3.to_i
                                                                             tier3_price = shipping_service.Charge3
                                                                              tier3 = tier3 -1
                                                                              tier4 = shipping_service.Value4.to_i   -   1
                                                                              tier4_price = shipping_service.Charge4
                                                                              tier4 = tier4 - 1
                                                                              tier5 = shipping_service.Value5.to_i
                                                                              tier5_price = shipping_service.Charge5
                                                                              tier5 = tier5 -1                                                              
                                                                             tier6 = shipping_service.Value6.to_i
                                                                              tier6_price = shipping_service.Charge6                                                              
                                                                              tier6 = tier6 - 1
                                                                              tier7 = shipping_service.Value7.to_i
                                                                             tier7_price = shipping_service.Charge7
                                                                              tier7 = tier7 -1
                                                                              tier8 = shipping_service.Value8.to_i   -   1
                                                                              tier8_price = shipping_service.Charge8
                                                                              tier8 = tier8 - 1                                                                              
                                                                              tier9 = shipping_service.Value9.to_i
                                                                              tier9_price = shipping_service.Charge9
                                                                              tier9 = tier9 - 1                                                              
                                                                             tier10 = shipping_service.Value10.to_i
                                                                              tier10_price = shipping_service.Charge10                                                              
                                                                              tier10 = tier10 - 1
                                                                              tier11 = shipping_service.Value11.to_i
                                                                             tier11_price = shipping_service.Charge11
                                                                              tier11 = tier11 -1
                                                                              tier12 = shipping_service.Value12.to_i   -   1
                                                                              tier12_price = shipping_service.Charge12
                                                                              tier12 = tier12 - 1
                                                                              tier13 = shipping_service.Value13.to_i
                                                                              tier13_price = shipping_service.Charge13
                                                                              tier13 = tier13                                                              
                                                                             tier14 = shipping_service.Value14.to_i
                                                                              tier14_price = shipping_service.Charge14                                                              
                                                                              tier14 = tier14 - 1
                                                                              tier15 = shipping_service.Value15.to_i
                                                                             tier15_price = shipping_service.Charge15
                                                                              tier15 = tier15 -1
                                                                                if weight == shipping_service.Value1
                                                                                                      weight_tier_shipping_price = shipping_service.Charge1
                                                                               elsif weight.between?(tier2,tier3)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge2
                                                                               elsif weight.between?(tier3,tier4)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge3                                                                                                      
                                                                               elsif weight.between?(tier4,tier5)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge4                                                                                                      
                                                                               elsif weight.between?(tier5,tier6)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge5
                                                                               elsif weight.between?(tier6,tier7)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge6                                                                                                      
                                                                                elsif weight.between?(tier7,tier8)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge7                                                                                                     
                                                                                elsif weight.between?(tier8,tier9)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge8  
                                                                               elsif weight.between?(tier9,tier10)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge9      
                                                                               elsif weight.between?(tier10,tier11)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge10       
                                                                             elsif weight.between?(tier11,tier12)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge11                                                                                                      
                                                                               elsif weight.between?(tier12,tier13)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge12                                                                                                      
                                                                               elsif weight.between?(tier13,tier14)
                                                                                                      weight_tier_shipping_price = shipping_service.Charge13
                                                                               elsif weight.between?(tier14,tier15)
                                                                                                     weight_tier_shipping_price = shipping_service.Charge14
                                                                               elsif weight >=  tier15
                                                                                                      weight_tier_shipping_price = 11111
                                                                                  end
                                                             else
                                                             weight_tier_shipping_price =    11111
                                                             end 
end





end
