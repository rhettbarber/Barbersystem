class Purchase < ActiveRecord::Base
        has_many :ups_ins
        has_one :cookie_trace
        has_one :sale
        has_one :user_session
        has_one :quote_tender_entry
        has_many :purchases_entries
        has_many :listing_purchases_entries
        has_many :purchases_entry_details
        belongs_to :customer
        belongs_to :shipping_service
        belongs_to :ship_to
        belongs_to :website
        @@GEORGIA_TAX_MULTIPLE =  0.06
        @@HANDLING_CHARGE = 2.00
      	attr_accessible :Comment, :ReferenceNumber,:purchases_entry_attributes , :ship_to_id   , :shipping_service_id    ,:QuantityOnOrder

        cattr_accessor  :customer

        def remove_symbiotic_items_added_as_singular_items ## for after log in of a retail customer who somehow got wholesale items into their cart.. like on barber website
                items_to_delete  = [0]
                 self.purchases_entries.each do |purchases_entry|
                            if purchases_entry.item
                                     items_to_delete  <<  purchases_entry.id   if  purchases_entry.symbiotic_item? and purchases_entry.symbiote_purchases_entry_id == 0
                            end
                end
                logger.debug "ABOUT TO DELETE.. items_to_delete.inspect: " + items_to_delete.inspect
                PurchasesEntry.delete(items_to_delete )
               #return items_to_delete
        end
########################################################################################################
  def purchases_entry_attributes=(purchases_entry_attributes)
             logger.warn "####################################### purchase.purchases_entry_attributes"
             logger.warn "####################################### purchase.purchases_entry_attributes"
             logger.warn "####################################### purchase.purchases_entry_attributes"
             logger.warn "####################################### purchase.purchases_entry_attributes"
             logger.warn "####################################### purchase.purchases_entry_attributes"

             logger.warn "####################################### purchase.purchases_entries.first.QuantityOnOrder " +   self.purchases_entries.first.QuantityOnOrder.to_s

             logger.warn "####################################### purchase.purchases_entry_attributes"
             logger.warn "####################################### purchase.purchases_entry_attributes"
             logger.warn "####################################### purchase.purchases_entry_attributes"
              purchases_entry_attributes.each do |attributes|
                                    logger.warn "####################################### attributes: " + attributes.inspect
                                    purchases_entry = purchases_entries.detect {|pe| pe.id == attributes[:id].to_i }
                                  logger.warn "####################################### purchases_entry.id " + purchases_entry.id.to_s
                                    purchases_entry_opposite_entry =  purchases_entry.opposite_entry if purchases_entry.opposite_entry != false
                                    purchases_entry.attributes = attributes
                                    purchases_entry_opposite_entry.attributes = attributes     if purchases_entry_opposite_entry
                                    purchases_entry.save!(:validate=> false)
                                    purchases_entry_opposite_entry.save(:validate=> false)  if purchases_entry_opposite_entry

                                    purchases_entry.destroy if purchases_entry.QuantityOnOrder <= 0.0
                                    if purchases_entry_opposite_entry
                                               purchases_entry_opposite_entry.destroy  if  purchases_entry_opposite_entry.QuantityOnOrder <= 0.0
                                    end
              end
             logger.warn "####################################### purchase.purchases_entry_attributes"
             logger.warn "####################################### purchase.purchases_entry_attributes"
             logger.warn "####################################### purchase.purchases_entry_attributes"
            #PurchasesEntry.uncached do
            #                  logger.warn "####################################### purchase.purchases_entries.first.QuantityOnOrder " +   self.purchases_entries.first.QuantityOnOrder.to_s
            # end
             logger.warn "####################################### purchase.purchases_entry_attributes"
             logger.warn "####################################### purchase.purchases_entry_attributes"
  end
########################################################################################################
  def reset_shipping_service_id
    self.shipping_service_id = 0
    self.save
  end
########################################################################################################
########################################################################################################
  def shipping_service_price
    begin
            if self.shipping_service.CarrierID == 4
                        usps = ActiveMerchant::Shipping::USPS.new(:login => "699BARBE5543",:password => "983PK26KV621" )
                        the_rates =  self.ship_to.get_rates_from_shipper(usps)
                        the_selected_rate  =   the_rates.select{|sss|   sss.service_code ==  self.shipping_service.Code    }
                        the_price = the_selected_rate.first.package_rates.first[:rate].to_f / 100 + 2
            else
                        ups = ActiveMerchant::Shipping::UPS.new(:login => 'rhettro', :password => 'onlineart', :key => '7C0F90B0C9F0B730')
                        the_rates =  self.ship_to.get_rates_from_shipper(ups)
                        the_selected_rate  =   the_rates.select{|sss|   sss.service_code ==  self.shipping_service.Code    }
                       the_price =  the_selected_rate.first.total_price.to_f / 100 + 2
            end
            return the_price
    rescue
               return 8.99
      end
  end
########################################################################################################
  def ups_shipping_price
    #begin
    self.shipping_service_price
    #unless free_catalog_purchase
    #         self.ship_to.shipping_service_price(self.shipping_service.web_carrier_name, self.shipping_service.web_name, self )
    #else
    #         0
    # end
    #rescue
    #     return  7.77  ## 7.77 is returned on shipping error
    #end
  end
########################################################################################################






  def date_created
                Date.parse(self.Time.to_s)
end





def customer_slug
            customer = self.customer
            if customer
                    return Slug.generate( customer.FirstName + " " + customer.LastName + " " +  customer.Company   )
            else
                    return ""
              end
end




def control_sheet_entries
          conditions = ["purchase_id = ? and item_id = 25319", self.id     ]
           return  ListingPurchasesEntry.find(:all, :conditions => conditions)
end





def overdue_purchases_entry_details
  unfinished
          conditions = ["listing_purchases_entry_id"]
          PurchasesEntryDetail.find(:all, :conditions => conditions)
end



def affiliate_with_referer
		if self.a_id != '0' 
				cookie_trace = self.cookie_trace
				if cookie_trace
						if cookie_trace.referer != ''
								true
						else
								false
						end
				else
						false
				end
		else		
				false
		end
end


def affiliate_user
		if self.a_id != '0' 
				cookie_trace = self.cookie_trace
				if cookie_trace
						if cookie_trace.a_id != ''
								User.find cookie_trace.a_id
						end
				end
		end
end





def qualifies_for_discount
		if self.customer
			if self.customer.PriceLevel > 0
				true
			else
				false
			end
		else
			false
		end
end	
	
def discount_name
	if self.qualifies_for_discount
			if self.customer.CurrentDiscount > 0
				"Permanent"
			else
				""
			end
	else
		""
	end
end
########################################################################################################
def add_free_catalog_entry(item)
                                              purchases_entry =  PurchasesEntry.new
                                              purchases_entry.on_hold = 0
                                              purchases_entry.ItemLookupCode  = item.ItemLookupCode
                                              purchases_entry.master_department_id  = 0
                                              purchases_entry.QuantityOnOrder = 1
                                              purchases_entry.discount_reason_code_id = 0
                                              purchases_entry.return_reason_code_id = 0
                                              purchases_entry.QuantityRTD = 0
                                              purchases_entry.DetailID = 0
                                              purchases_entry.SalesRepID = 0
                                              purchases_entry.PriceSource = 1
                                              purchases_entry.FullPrice = 0
                                              purchases_entry.item_id =  item.id
                                              purchases_entry.purchase_id = self.id
                                              purchases_entry.store_id = 7
                                              purchases_entry.Cost = 0
                                              purchases_entry.Comment = 0
                                              purchases_entry.commission_paid = 0
                                              purchases_entry.Description =  Slug.generate(item.Description)
                                              purchases_entry.Price = 0
                                              purchases_entry.Taxable = 0
                                              purchases_entry.LastUpdated = Time.now      
                                              purchases_entry.symbiote_purchases_entry_id = 0                            
                                              purchases_entry.save
                                              purchases_entry
end

def add_cod_item
                                              purchases_entry =  PurchasesEntry.new
                                              purchases_entry.on_hold = 0
                                              purchases_entry.ItemLookupCode  = "COD Charge"
                                              purchases_entry.master_department_id  = 0
                                              purchases_entry.QuantityOnOrder = 1
                                              purchases_entry.discount_reason_code_id = 0
                                              purchases_entry.return_reason_code_id = 0
                                              purchases_entry.QuantityRTD = 0
                                              purchases_entry.DetailID = 0
                                              purchases_entry.SalesRepID = 0
                                              purchases_entry.PriceSource = 1
                                              purchases_entry.FullPrice = 0
                                              purchases_entry.item_id =  14033
                                              purchases_entry.purchase_id = self.id
                                              purchases_entry.store_id = 7
                                              purchases_entry.Cost = 0
                                              purchases_entry.Comment = 0
                                              purchases_entry.commission_paid  = 0
                                              purchases_entry.Description = "COD Charge"
                                              purchases_entry.Price = 9
                                              purchases_entry.Taxable = 0
                                              purchases_entry.LastUpdated = Time.now      
                                              purchases_entry.symbiote_purchases_entry_id = 0                            
                                              purchases_entry.save
                                              purchases_entry
end


def add_online_discount_item(online_discount_amount)
                                              purchases_entry =  PurchasesEntry.new
                                              purchases_entry.on_hold = 0
                                              purchases_entry.ItemLookupCode  = "Online_5%_Discount"
                                              purchases_entry.master_department_id  = 0
                                              purchases_entry.QuantityOnOrder = 1
                                              purchases_entry.discount_reason_code_id = 8
                                              purchases_entry.return_reason_code_id = 0
                                              purchases_entry.QuantityRTD = 0
                                              purchases_entry.DetailID = 0
                                              purchases_entry.SalesRepID = 0
                                              purchases_entry.PriceSource = 1
                                              purchases_entry.FullPrice = 0
                                              purchases_entry.item_id =  10271
                                              purchases_entry.purchase_id = self.id
                                              purchases_entry.store_id = 7
                                              purchases_entry.Cost = 0
                                              purchases_entry.Comment = 0
                                              purchases_entry.commission_paid  = 0
                                              purchases_entry.Description = "5% Online Discount"
                                              purchases_entry.Price = online_discount_amount * -1
                                              purchases_entry.Taxable = 0
                                              purchases_entry.LastUpdated = Time.now      
                                              purchases_entry.symbiote_purchases_entry_id = 0                            
                                              purchases_entry.save
                                              purchases_entry
end

def add_discount_item(discount_amount)
                                              purchases_entry =  PurchasesEntry.new
                                              purchases_entry.on_hold = 0
                                              purchases_entry.ItemLookupCode  = "Discount"
                                              purchases_entry.master_department_id  = 0
                                              purchases_entry.QuantityOnOrder = 1
                                              purchases_entry.discount_reason_code_id = 8
                                              purchases_entry.return_reason_code_id = 0
                                              purchases_entry.QuantityRTD = 0
                                              purchases_entry.DetailID = 0
                                              purchases_entry.SalesRepID = 0
                                              purchases_entry.PriceSource = 1
                                              purchases_entry.FullPrice = 0
                                              purchases_entry.item_id =  13653
                                              purchases_entry.purchase_id = self.id
                                              purchases_entry.store_id = 7
                                              purchases_entry.Cost = 0
                                              purchases_entry.Comment = 0
                                              purchases_entry.commission_paid  = 0
                                              purchases_entry.Description = "Discount"
                                              purchases_entry.Price = discount_amount * -1
                                              purchases_entry.Taxable = 0
                                              purchases_entry.LastUpdated = Time.now      
                                              purchases_entry.symbiote_purchases_entry_id = 0                            
                                              purchases_entry.save
                                              purchases_entry
end

########################################################################################################

def affiliate_payable_amount
	self.Total * 0.08
end	
########################################################################################################
def opposite_result_item_ids_only_in_specific_category(category)
		category.all_item_ids_and_additive_category_item_ids.to_set.intersection(self.opposite_result_item_ids_only(Item.first_of_components_item_ids).to_set)
end
########################################################################################################
def opposite_result_item_ids_only(item_set_to_limit)
		return self.all_opposite_item_ids.to_set.intersection(item_set_to_limit)
end
########################################################################################################
def has_on_hold_entries?
	if self
		if self.purchases_entries.exists?(:on_hold => '1')
			return true
		else
			return false
		end	
	else
		false
	end		
end	
########################################################################################################
########################################################################################################
####### SYMBIONT AREA
def new_combo_symbiont(item, design, quantity, department_id, pe_item_comment, pe_design_comment )  # master_department_id needs work or testing
                                              purchases_entry_slave =  PurchasesEntry.new
                                              purchases_entry_slave.master_department_id  = department_id  # item.category.category_class.slaves_opposite_master_default_department_id
                                              purchases_entry_slave.ItemLookupCode  = item.ItemLookupCode
                                              purchases_entry_slave.QuantityOnOrder = quantity
                                              purchases_entry_slave.on_hold = 0
                                              purchases_entry_slave.QuantityRTD = 0
                                              purchases_entry_slave.DetailID = 0
                                              purchases_entry_slave.SalesRepID = 0
                                              purchases_entry_slave.discount_reason_code_id = 0
                                              purchases_entry_slave.return_reason_code_id = 0
                                              purchases_entry_slave.PriceSource = 1
                                              purchases_entry_slave.FullPrice = item.full_unit_price(purchases_entry_slave)
                                              purchases_entry_slave.item_id =  item.id
                                              purchases_entry_slave.purchase_id = id
                                              purchases_entry_slave.store_id = 7
                                              purchases_entry_slave.Cost = item.Cost
                                              purchases_entry_slave.Comment =  pe_design_comment || 0
                                              purchases_entry_slave.commission_paid = 0
                                              purchases_entry_slave.Description =     Slug.generate(item.Description)          # item.Description[0..5]
                                              purchases_entry_slave.Price = item.Price
                                              purchases_entry_slave.Taxable = 1
                                              purchases_entry_slave.LastUpdated = Time.now      
                                              purchases_entry_slave.symbiote_purchases_entry_id = 0                                                                   
                                              purchases_entry_slave.save
                                                  purchases_entry_master =  PurchasesEntry.new
                                                  purchases_entry_master.on_hold  = 0
                                                  purchases_entry_master.ItemLookupCode  = design.ItemLookupCode
                                                  purchases_entry_master.master_department_id  =  department_id  # item.category.category_class.slaves_opposite_master_default_department_id
                                                  purchases_entry_master.QuantityOnOrder = quantity
                                                  purchases_entry_master.QuantityRTD = 0
                                                  purchases_entry_master.DetailID = 0
                                                  purchases_entry_master.SalesRepID = 0
                                                  purchases_entry_master.PriceSource = 1
                                                  purchases_entry_master.discount_reason_code_id = 0
                                              	  purchases_entry_master.return_reason_code_id = 0
                                                  purchases_entry_master.FullPrice =  design.full_unit_price(purchases_entry_master)
                                                  purchases_entry_master.item_id =  design.id
                                                  purchases_entry_master.purchase_id = id
                                                  purchases_entry_master.store_id = 7
                                                  purchases_entry_master.Cost = 0
                                                  purchases_entry_master.Comment = pe_item_comment || 0
                                                  purchases_entry_master.commission_paid = 0
                                                  purchases_entry_master.Description =  Slug.generate(design.Description)
                                                  purchases_entry_master.Price = 0
                                                  purchases_entry_master.Taxable = 1
                                                  purchases_entry_master.LastUpdated = Time.now      
                                                  purchases_entry_master.symbiote_purchases_entry_id = purchases_entry_slave.id                                                                    
                                                  purchases_entry_master.save
                                               purchases_entry_slave.symbiote_purchases_entry_id = purchases_entry_master.id    
                                               purchases_entry_slave.save 
end
########################################################################################################
 def new_slave_symbiote(item,quantity,hold_status )
                                             if hold_status == "true"
                                               hold_status = 1
                                             else
                                               hold_status = 0
                                             end
                                              purchases_entry_slave =  PurchasesEntry.new
                                              purchases_entry_slave.master_department_id  = item.category.category_class.slaves_opposite_master_default_department_id
                                              purchases_entry_slave.ItemLookupCode  = item.ItemLookupCode
                                              purchases_entry_slave.QuantityOnOrder = quantity
                                              purchases_entry_slave.on_hold = hold_status
                                              purchases_entry_slave.QuantityRTD = 0
                                              purchases_entry_slave.DetailID = 0
                                              purchases_entry_slave.SalesRepID = 0
                                              purchases_entry_slave.discount_reason_code_id = 0
                                              purchases_entry_slave.return_reason_code_id = 0
                                              purchases_entry_slave.PriceSource = 1
                                              purchases_entry_slave.item_id =  item.id
                                              purchases_entry_slave.purchase_id = id
                                              purchases_entry_slave.store_id = 7
                                              purchases_entry_slave.Cost = item.Cost
                                              purchases_entry_slave.Comment = 0
                                              purchases_entry_slave.commission_paid = 0
                                              purchases_entry_slave.Description =     Slug.generate(item.Description)          # item.Description[0..5]
                                              purchases_entry_slave.Price = item.Price
                                              purchases_entry_slave.Taxable = 1
                                              purchases_entry_slave.LastUpdated = Time.now      
                                              purchases_entry_slave.symbiote_purchases_entry_id = 0
                                             purchases_entry_slave.FullPrice = item.full_unit_price(purchases_entry_slave)
                                              purchases_entry_slave.save
                                                  purchases_entry_master =  PurchasesEntry.new
                                                  purchases_entry_master.on_hold  = hold_status
                                                  purchases_entry_master.ItemLookupCode  = 0
                                                  purchases_entry_master.master_department_id  = item.category.category_class.slaves_opposite_master_default_department_id   
                                                  purchases_entry_master.QuantityOnOrder = quantity
                                                  purchases_entry_master.QuantityRTD = 0
                                                  purchases_entry_master.DetailID = 0
                                                  purchases_entry_master.SalesRepID = 0
                                                  purchases_entry_master.PriceSource = 1
                                                  purchases_entry_master.discount_reason_code_id = 0
                                              	  purchases_entry_master.return_reason_code_id = 0
                                                  purchases_entry_master.FullPrice = 0
                                                  purchases_entry_master.item_id =  0
                                                  purchases_entry_master.purchase_id = id
                                                  purchases_entry_master.store_id = 7
                                                  purchases_entry_master.Cost = 0
                                                  purchases_entry_master.Comment = 0
                                                 purchases_entry_master.commission_paid = 0
                                                  purchases_entry_master.Description = 0
                                                  purchases_entry_master.Price = 0
                                                  purchases_entry_master.Taxable = 1
                                                  purchases_entry_master.LastUpdated = Time.now      
                                                  purchases_entry_master.symbiote_purchases_entry_id = purchases_entry_slave.id                                                                    
                                                  purchases_entry_master.save
                                               purchases_entry_slave.symbiote_purchases_entry_id = purchases_entry_master.id    
                                               purchases_entry_slave.save                             
end 
########################################################################################################
def new_master_symbiote(item,quantity,department,hold_status )
                                             CUSTOM_LOGGER.error "hold_status: " + hold_status
                                              if hold_status == "true"
                                              	 hold_status = 1
                                          	  else
                                            	hold_status = 0
                                        	  end
                                              purchases_entry_master =  PurchasesEntry.new
                                              purchases_entry_master.on_hold  =  hold_status
                                              purchases_entry_master.ItemLookupCode  = item.ItemLookupCode
                                              purchases_entry_master.master_department_id  = department
                                              purchases_entry_master.QuantityOnOrder = quantity
                                              purchases_entry_master.QuantityRTD = 0
                                              purchases_entry_master.DetailID = 0
                                              purchases_entry_master.discount_reason_code_id = 0
                                              purchases_entry_master.return_reason_code_id = 0
                                              purchases_entry_master.SalesRepID = 0
                                              purchases_entry_master.PriceSource = 1
                                              purchases_entry_master.item_id =  item.id
                                              purchases_entry_master.purchase_id = id
                                              purchases_entry_master.store_id = 7
                                              purchases_entry_master.Cost = item.Cost
                                              purchases_entry_master.Comment = 0
                                              purchases_entry_master.commission_paid = 0
                                              purchases_entry_master.Description =   Slug.generate(item.Description)    #item.Description[0..5]
                                              purchases_entry_master.Price = item.Price
                                              purchases_entry_master.Taxable = 1
                                              purchases_entry_master.LastUpdated = Time.now      
                                              purchases_entry_master.symbiote_purchases_entry_id = 0
                                             purchases_entry_master.FullPrice = item.full_unit_price(purchases_entry_master)
                                              purchases_entry_master.save
                                                  purchases_entry_slave =  PurchasesEntry.new
                                                  purchases_entry_slave.ItemLookupCode  = 0
                                                  purchases_entry_slave.on_hold  = hold_status
                                                  purchases_entry_slave.master_department_id  = department
                                                  purchases_entry_slave.QuantityOnOrder = quantity
                                                  purchases_entry_slave.discount_reason_code_id = 0
                                              	  purchases_entry_slave.return_reason_code_id = 0
                                                  purchases_entry_slave.QuantityRTD = 0
                                                  purchases_entry_slave.DetailID = 0
                                                  purchases_entry_slave.SalesRepID = 0
                                                  purchases_entry_slave.PriceSource = 1
                                                  purchases_entry_slave.FullPrice = 0
                                                  purchases_entry_slave.item_id =  0
                                                  purchases_entry_slave.purchase_id = id
                                                  purchases_entry_slave.store_id = 7
                                                  purchases_entry_slave.Cost = 0
                                                  purchases_entry_slave.Comment = 0
                                                 purchases_entry_slave.commission_paid = 0
                                                  purchases_entry_slave.Description = 0
                                                  purchases_entry_slave.Price = 0
                                                  purchases_entry_slave.Taxable = 1
                                                  purchases_entry_slave.LastUpdated = Time.now      
                                                  purchases_entry_slave.symbiote_purchases_entry_id = purchases_entry_master.id                                                                    
                                                  purchases_entry_slave.save
                                               purchases_entry_master.symbiote_purchases_entry_id = purchases_entry_slave.id    
                                               purchases_entry_master.save        
  
end  
########################################################################################################
def light_opposite_item_ids
      op_item_ids = []
    for item in all_opposite_items
        op_item_ids << item.id if item.SubDescription2 == 'light'
    end
      return op_item_ids
end
########################################################################################################
def opaque_opposite_item_ids
      op_item_ids = []
    for item in all_opposite_items
        op_item_ids << item.id if item.SubDescription2 == 'opaque'
    end
      return op_item_ids
end
########################################################################################################
def all_opposite_item_ids
    op_item_ids = []
    for item in all_opposite_items
        op_item_ids << item.id
    end
      return op_item_ids
end
########################################################################################################
def all_opposite_items
      Item.find(:all, :conditions => ["category_id in (?)",   self.opposite_category_ids   ])
end
########################################################################################################
def opposite_category_ids
        if incomplete_symbiont == true
             symbiote.item.category.category_class.opposite_category_ids.split(/,/)
        else
           false
        end
end
########################################################################################################
def incomplete_symbiont
          if PurchasesEntry.exists?(:purchase_id  => self.id ,  :item_id =>   '0' , :on_hold => '0'  )
                 CUSTOM_LOGGER.error "PE Exists"
                  if self.customer
                                 CUSTOM_LOGGER.error "self.customer"
                                  if self.customer.PriceLevel == 2 or  self.customer.PriceLevel == 3
                                               CUSTOM_LOGGER.error "self.customer.PriceLevel == 2 or  self.customer.PriceLevel == 3"
                                                 false
                                  else
                                             CUSTOM_LOGGER.error "Not self.customer.PriceLevel == 2 or  self.customer.PriceLevel == 3"
                                               true
                                   end
                    else
                                       CUSTOM_LOGGER.error "Not self.customer"
                                         true
                     end
          else
                             CUSTOM_LOGGER.error "No PE exists"
                               false
          end 
end
########################################################################################################
def symbiote_blank
      if incomplete_symbiont == true
               PurchasesEntry.find(:first, :conditions => [ "purchase_id = ? and item_id = ? and on_hold = ?", self.id , '0', '0'  ])
        else
                 false
        end
 end
########################################################################################################
def symbiote
        if incomplete_symbiont == true
             #PurchasesEntry.find(:first, :conditions => [ "purchase_id = ? and id = ? and on_hold = ?", id , symbiote_blank.symbiote_purchases_entry_id ,'0' ])
             PurchasesEntry.includes(:item).where("purchase_id = ? and id = ? and on_hold = ?", id , symbiote_blank.symbiote_purchases_entry_id ,'0').first
        else
             false
        end
end
########################################################################################################
def symbiote_type
          if incomplete_symbiont == true
                   symbiote.item.category.category_class.item_type
           else
                   false
        end
end
########################################################################################################
def master
        if symbiote_type == 'master'
                 symbiote
          elsif symbiote_type == 'slave'
                 symbiote_blank
          else
                 false
          end
end                
########################################################################################################
def slave
          if symbiote_type == 'master'
                   symbiote_blank
          elsif symbiote_type == 'slave'
                   symbiote
          else
                     false
          end
end
########################################################################################################
####### PRICE TOTALS
def final_total_after_shipping
          begin
                         self.total_after_tax  +  self.ups_shipping_price
           rescue
                           nil
           end                        
end
########################################################################################################
def full_price_total(customer)        
          total = 0.0
          customer = self.customer
          self.purchases_entries.each do |li|
	             if li.item_id != 0  && li.on_hold == 0
                   Item.unscoped do
                      item = Item.find(li.item_id)
                      total +=   li.full_extended_price(customer,item)
                   end
		         end
          end
          return total
end
########################################################################################################
def subtotal
          total = 0.0
          customer = self.customer
          self.purchases_entries.each do |li|
                quantity = li.QuantityOnOrder
			    	 if li.item_id != 0 && li.on_hold == 0
                    Item.unscoped do
                          item = Item.find(li.item_id)
                          total +=   li.your_extended_price(customer,quantity,item)
                      end
				      end
      	  end
      	  total = total - self.discount_savings
          return total
end
########################################################################################################
def subtotal_volume_and_permanent_discountable_only_items
          total = 0.0
          customer = self.customer
          self.purchases_entries.each do |li|
                quantity = li.QuantityOnOrder
			    	 if li.item_id != 0 && li.on_hold == 0
                   Item.unscoped do
                            item = Item.find(li.item_id)
                            if item.department_is_permanent_or_volume_discountable
                              total +=   li.your_extended_price(customer,quantity,item)
                            end
                     end
				      end
      	  end
          return total
end
########################################################################################################
def total_savings
        customer = self.customer
          temp_total = 0.0
          self.purchases_entries.each do |li|
	             if li.item_id != 0  && li.on_hold == 0
                       Item.unscoped do
                              item = Item.find(li.item_id)
                              temp_total +=  (li.your_extended_price_savings(customer,li.QuantityOnOrder,item) )
                         end
		         end
          end
          temp_total = temp_total + self.discount_savings
          return  temp_total
end
########################################################################################################
def online_discount_savings
        if self.customer
                    if self.customer.PriceLevel == 2 or  self.customer.PriceLevel == 3
                             self.subtotal * 0.05
                  else
                         0
                  end
         else
            0
          end
end
########################################################################################################
def subtotal_after_all_discounts
       self.subtotal  -  self.online_discount_savings
end
########################################################################################################
def tax_amount
       if self.customer
               if self.customer.PriceLevel > 0
                  0
              else
                       if self.customer.State 
                              if self.customer.State.downcase == "ga" or self.customer.State.downcase == 'georgia'
                                   self.subtotal_after_all_discounts *  @@GEORGIA_TAX_MULTIPLE
                              else
                                  0
                              end
                        else
                            0
                        end        
              end
      else
       0
      end
end
########################################################################################################
def total_after_tax
        self.subtotal_after_all_discounts + self.tax_amount
end
########################################################################################################
def volume_discount_savings
        if self.customer
        				if self.customer.CurrentDiscount  == 0 && self.customer.PriceLevel > 1
                            self.subtotal_volume_and_permanent_discountable_only_items *  self.volume_discount_multiple
                        else
                              0
                        end
          else
                  0
          end
end
########################################################################################################
def total_after_volume_discount
           self.subtotal  -  self.volume_discount_savings
end
########################################################################################################
def discount_savings
	if self.qualifies_for_discount
		if self.discount_multiple > 0
			self.discount_multiple * self.subtotal_volume_and_permanent_discountable_only_items
		else
			0.0
		end
	else
		0.0
	end
end	
########################################################################################################	
def discount_multiple
	if self.qualifies_for_discount
		if self.customer.CurrentDiscount > 0
			self.customer.CurrentDiscount * 0.01
		else
			self.volume_discount_multiple
		end
	else
		0.0
	end
end	
########################################################################################################
def discount_percentage
	if self.qualifies_for_discount
		if self.customer.CurrentDiscount > 0
			self.customer.CurrentDiscount
		else
			self.volume_discount_multiple * 100
		end
	else
		0.0
	end
end	
########################################################################################################
 def volume_discount_multiple
                    return 0.to_f
                                      # unless self == nil
                                      #                     if self.subtotal_volume_and_permanent_discountable_only_items.between?(0,49)
                                      #                       volume_discount_multiple = 0.to_f
                                      #                    elsif self.subtotal_volume_and_permanent_discountable_only_items.between?(50,99)
                                      #                       volume_discount_multiple = '.05'.to_f
                                      #                     elsif self.subtotal_volume_and_permanent_discountable_only_items.between?(101,249)
                                      #                       volume_discount_multiple = '.1'.to_f
                                      #                     elsif self.subtotal_volume_and_permanent_discountable_only_items.between?(250,499)
                                      #                       volume_discount_multiple = '.15'.to_f
                                      #                     elsif self.subtotal_volume_and_permanent_discountable_only_items.between?(500,999)
                                      #                       volume_discount_multiple = '.2'.to_f
                                      #                     elsif self.subtotal_volume_and_permanent_discountable_only_items.between?(1000,2499)
                                      #                       volume_discount_multiple = '.25'.to_f
                                      #                     elsif self.subtotal_volume_and_permanent_discountable_only_items.between?(2500,4999)
                                      #                       volume_discount_multiple = '.3'.to_f
                                      #                     elsif self.subtotal_volume_and_permanent_discountable_only_items.between?(5000,7500)
                                      #                       volume_discount_multiple = '.35'.to_f
                                      #                     else
                                      #                       volume_discount_multiple = 0.to_f
                                      #                       end
                                      #      else
                                      #      volume_discount_multiple = 0.to_f
                                      #      end
end    
########################################################################################################        
def slave_entries_discount_amount
                    total = 0
        for slave_entry in self.slave_entries
                  item = Item.find(slave_entry.item_id)
                    total +=  (slave_entry.your_extended_price(customer,slave_entry.QuantityOnOrder,item) )
        end
                      slave_entries_discount_total = total  * '.05'.to_f
end
########################################################################################################
####### OTHER TOTALS
 def total_weight
                total = 0.0
                self.purchases_entries.each do |li|
                    	if li.item
                    		total +=   li.item.Weight * li.QuantityOnOrder
                    	end
                end
                   ss = "gg"
                    total  = total + 1 if total < 1
            return total
end
########################################################################################################
def specific_item_count(item)
      purchases_entries = self.purchases_entries
      purchases_entries.sum(:QuantityOnOrder, :conditions => ['item_id = ?', item ]).to_i
end
########################################################################################################
def cart_count
        purchases_entries = self.purchases_entries
      purchases_entries.sum(:QuantityOnOrder).to_i
end
########################################################################################################   
####### SHIPPING BEGIN
  def free_catalog_purchase
    if self.subtotal_after_all_discounts == 0
             true 
    else
            false
     end
end
########################################################################################################
def average_ups_standard_shipping_object
                      Shipping::Base.new :zip => 31545,  :sender_zip => 31555, :weight => self.total_weight, :service_type => 'ground_service'                                          
            #logger.info("\n\n ------------inspect shipping =  #{shipping(zipcode).inspect}--------------\n\n" )
end
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
def shipping
                error_here_too
                  if self.shipping_service && self.ship_to
                               self.ship_to.api_shipping_object(self.shipping_service.Name)
                  else                                           
                            error_here
                            self.average_ups_standard_shipping_object
                  end
end
########################################################################################################   
####### CRUD METHODS & OTHER
def delete_license_required_entries
        license_required_entries = [0]
        for purchases_entry in self.purchases_entries
             if purchases_entry.item
                       license_required_entries  <<  purchases_entry.id if purchases_entry.item.requires_license == true
              end
        end
            PurchasesEntry.delete(license_required_entries )
end
########################################################################################################
def remove_symbiotic_references ## for after log in of a non-licensed dealer, this will take the symbiont_id off
        for purchases_entry in self.purchases_entries
                       purchases_entry.symbiote_purchases_entry_id = 0
                       purchases_entry.save
        end
end	
########################################################################################################
def self.delete_purchase_and_entries(purchase,purchases_entries)
                        purchase = Purchase.destroy(purchase)
                        purchase_entries = PurchasesEntry.destroy(purchases_entries)

end
######################################################################################################## 
def self.purchase_default(customer,website_id)
                        purchase = Purchase.new
                        purchase.Time = Time.now
                        purchase.customer_id = customer
                        purchase.Taxable = 1
                              if customer.class  ==  Fixnum
                                   purchase.shipping_service_id = 0
                               else
                                     purchase.shipping_service_id  = customer.default_shipping_service_id
                               end                                     
                        purchase.Deposit = 0
                        purchase.Tax = 0
                        purchase.website_id = website_id
                        purchase.Total = 0
                        purchase.LastUpdated = Time.now
                        purchase.DepositOverride = 0
                        purchase.SalesRepID = 0
                        purchase.ShippingChargeOnOrder= 0
                        purchase.ShippingChargeOverride = 0
                              if customer.class  ==  Fixnum
                                   purchase.ship_to_id = 0
                               else
                                     purchase.ship_to_id  = customer.primary_ship_to_id
                               end
                        purchase.ReferenceNumber  = 'unfinished_web'       
                        purchase.ShippingTrackingNumber  = 0                        
                        purchase.Type = 3#A QUOTE###############2 is a work order
                        purchase.store_id = 0
                        purchase.Comment = 0
                        purchase.Closed = 0
                        purchase.ShippingNotes = 'Shipping Note'        
                        purchase.save
                        purchase
end
########################################################################################################
  def  product_entries_count
            shirt_total = 0.0
            self.product_entries.each do |she|
                      shirt_total += she.QuantityOnOrder
            end
            return shirt_total
  end
########################################################################################################
  def  three_or_less_shipping_allowed?
            if  self.standard_shirt_entries_count   <= 3
                          if  self.product_entries_count  - self.standard_shirt_entries_count   > 0
                                        false
                          else
                                        true
                          end
            else
                              false
              end
  end
########################################################################################################
  def  standard_shirt_entries_count
          shirt_total = 0.0
          self.standard_shirt_entries.each do |she|
                    shirt_total += she.QuantityOnOrder
          end
    return shirt_total
  end
########################################################################################################
  def standard_shirt_entries
    online_discountable_entry = []
    for purchases_entry in self.purchases_entries
      if purchases_entry.item
        if purchases_entry.item.category.category_class.id == 1
          online_discountable_entry   <<  purchases_entry
        end
      end
    end
    return online_discountable_entry
  end
########################################################################################################

def product_entries
                    online_discountable_entry = []
      for purchases_entry in self.purchases_entries
            if purchases_entry.item
      			if purchases_entry.item.category.category_class.item_type != 'slave'
                    online_discountable_entry   <<  purchases_entry
            	end
            end
      end
                   return online_discountable_entry
end
########################################################################################################
def slave_entries
                    online_discountable_entry = []
      for purchases_entry in self.purchases_entries
            if purchases_entry.item
      			if purchases_entry.item.category.category_class.item_type == 'slave'
                    online_discountable_entry   <<  purchases_entry
            	end
            end
      end
                   return online_discountable_entry
end
########################################################################################################
def slave_entries_count
        self.slave_entries.size
end
########################################################################################################

#        logger.info("\n\n ------------- --------------inspect shipping =  #{shipping(zipcode).inspect}         ------  ------------------\n\n   " )



end
