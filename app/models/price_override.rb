class PriceOverride  < ActiveRecord::Base


   def  overriden_quantity_discount_id
             if self.Comment.include? 'sublim9'
                         return  22651
             elsif self.Comment.include? 'sublim12'
                      return   22652
             elsif self.Comment.include? 'sublim14'
                         return   22650
             elsif self.Comment.include? 'sublimfull'
                          return  22649
             else
                             wrong_wrong
             end
   end




end
