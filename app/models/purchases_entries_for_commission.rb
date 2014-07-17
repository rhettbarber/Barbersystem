class PurchasesEntriesForCommission < ActiveRecord::Base
      belongs_to :customer
     has_many :sales
















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
