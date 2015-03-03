class PurchasesEntriesForCommission < ActiveRecord::Base

  set_primary_key "id"

      belongs_to :customer
     has_many :sales    , :foreign_key => "purchase_id"
  belongs_to :item







  def permanent_or_volume_discount
    logger.debug "BEGIN permanent_or_volume_discount_multiplier"
    discount_percentage = 0.0
    logger.debug "self.id: " + self.id.to_s
    # 'Discountable Total: 456.25  Percent:0.5  Type:permanent_discount'
    discount_lines =  PurchasesEntry.find(:all, :conditions => ["Price < 0 and purchase_id = ?",  self.purchase_id     ]   )

    logger.debug "discount_lines.size: " +   discount_lines.size.to_s
    logger.debug "discount_lines.inspect: " +   discount_lines.inspect
    discount_lines.each do |dli|
      if dli.Comment.include? 'Percent:'
        logger.debug "discount volume and permanent"
        the_discount_percentage =     dli.Comment.split('Percent:')[1] .split(' ')[0].to_f
        logger.debug "the_discount_percentage: " +  the_discount_percentage.to_s
        discount_percentage  =     the_discount_percentage
      end
      logger.debug "dli.purchases_entry_Comment" +  dli.Comment.to_s
    end
    sum = 0
    logger.debug "END permanent_or_volume_discount_multiplier"
    if  discount_percentage  > 0
      return discount_percentage
    else
      return 0
    end
  end




  def internet_discount
    if   PurchasesEntry.exists?(  [ "item_id = ? and purchase_id = ?",  10271, self.purchase_id  ]      )
      0.05
    else
      0.0
    end

  end




  def    permanent_or_volume_discount_multiplier
    return  1.0 -   permanent_or_volume_discount
  end




  def    internet_discount_multiplier
    return  1.0 -   internet_discount
  end







  #############################################################################################################################  JUNK BELOW TO SCAVENGE

#
#      def commission_in_dollars(begin_date,end_date)
#					@rtc = 0.0
#						if  self.CommissionAmount > 0
#										@rtc += self.commissionable_quantity(begin_date,end_date)  * self.CommissionAmount
#						elsif self.CommissionPercentSale > 0
#										@records_to_calculate = sales_entry_records(begin_date,end_date)
#										if @records_to_calculate
#										  @records_to_calculate.each do |se|
#													@rtc   +=    se.combined_total
#											end
#										end
#						else
#								@rtc += 0.0
#						end
#						return @rtc
#end
#
#
#
#def quantity_sold(begin_date,end_date)
#		#conditions = ["item_id = ? and sales.sale_time > ? and sales.sale_time < ?  and Quantity > 0", self.id, begin_date, end_date ]
#		conditions = ["item_id = ? and sales.sale_time > ? and sales.sale_time < ?  and Quantity > 0 and sales.customer_id IS NOT NULL", self.id, begin_date, end_date ]
#		SalesEntry.sum("Quantity", :conditions => conditions, :include => ['sale'] )
#		#SalesEntry.find( :all, :conditions => conditions, :include => ['sale'] )
#end
##############################################################################################################################
#def quantity_returned(begin_date,end_date)
#		conditions = ["item_id = ? and sales.sale_time > ? and sales.sale_time < ? and Quantity < 0 ", self.id, begin_date, end_date ]
#		SalesEntry.sum("Quantity", :conditions => conditions, :include => ['sale'] )
#end
##############################################################################################################################
#def commissionable_quantity(begin_date,end_date)
#		conditions = ["item_id = ? and sales.sale_time > ? and sales.sale_time < ? ", self.id, begin_date, end_date ]
#		SalesEntry.sum("Quantity", :conditions => conditions, :include => ['sale'] )
#end
##############################################################################################################################



end
