class PurchasesEntry < ActiveRecord::Base
#    belongs_to :viewable_purchase
    belongs_to :purchase
    belongs_to :item
    has_one :layout
    has_one :purchases_entry_detail      , :foreign_key => "listing_purchases_entry_id"

	  attr_accessible :QuantityOnOrder, :Comment   , :QuantityRTD , :Description   , :Price , :fulfilled

    #before_create :wipe_incomplete_symbiont
    #before_destroy  :wipe_incomplete_symbiont
    #before_save :wipe_incomplete_symbiont
    #before_update :wipe_incomplete_symbiont
    #
    #def wipe_incomplete_symbiont
    #      session[:incomplete_symbiont_found] = false
    #end


    #### DUPLICATE FUNCTION FROM sublimation_entry.rb
    #### DUPLICATE FUNCTION FROM sublimation_entry.rb
    #### DUPLICATE FUNCTION FROM sublimation_entry.rb
    #### DUPLICATE FUNCTION FROM sublimation_entry.rb
    def transfer_type_name
      if self.Comment.to_s.include? 'sublim9'
        return    "Sublimation transfer size 9\"x9\""
      elsif self.Comment.to_s.include? "sublim12"
        return    "Sublimation transfer size 12\"x12\""
      elsif self.Comment.to_s.include?  "sublim14"
        return    "Sublimation transfer size 14\"x14\""
      elsif self.Comment.to_s.include?  "sublimfull"
        return    "Sublimation transfer size 15\"x19\""
      elsif self.Comment.to_s.include?  "sublimaot"
        return    "Sublimation All Over T"
      else
        return    ""
      end
    end





  def override_quantity_discount?

            if self.Comment.to_s.include? 'sublim9'
                       return    true

            elsif self.Comment.to_s.include? "sublim12"
                       return    true

            elsif self.Comment.to_s.include?  "sublim14"
                       return    true
            elsif self.Comment.to_s.include?  "sublimfull"
                       return    true
            else
                        return     false
             end
end


  def overriden_quantity_discount_id
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







def overdue
          #logger.debug "due_date: " + self.due_date.to_s
          #logger.debug "Date.civil: " + Date.civil.to_s
         begin
                    if   self.due_date <=   Date.today
                                true
                    else
                                false
                    end
         rescue
                true
           end
end


def balance
            self.QuantityRTD.to_i  -   self.QuantityOnOrder.to_i
end

def balance_operator
            if  self.balance >=  0
             return "+"
            end
end


  def due_date
            begin
                       date =   self.Comment.gsub(']','').gsub('[','')
                       date_split  =     date.split("-")
                       year            =      date_split[0].to_i
                       month        =      date_split[1].to_i
                       day              =      date_split[2].to_i
                       logger.debug "self.Comment: " + self.Comment
                      g = "g"

                     return Date.civil( year, month, day)
            rescue
                      "No Date"
              end


  end



def extended_total_at_commissioned_price
			self.QuantityRTD * self.commissioned_price
end


def commissioned_price
		@special_price_levels = ['0','1']
		if self.purchase.customer
					if   @special_price_levels. include?(self.purchase.customer.PriceLevel.to_s)
							return self.item.lowest_quantity_discount_price_b
					else
							return self.Price
					end
		else
					return 0.0
		end
end


def commission_percent_sale

  #use @commissioned_customer instead

                logger.warn "######### item.ItemLookupCode: "  +   item.ItemLookupCode
                logger.warn "self.purchase.customer.CustomNumber1: " + self.purchase.customer.CustomNumber1.to_s
                if 	self.item.CommissionPercentSale > 0
                                   logger.warn "######### self.item.ItemLookupCode: "  +  self. item.ItemLookupCode
                                   logger.warn "self.item.CommissionPercentSale"
                                  self.item.CommissionPercentSale * 0.01
                elsif self.item.customer_item.customer.CustomNumber1 > 0
                                   logger.warn "######### self.item.ItemLookupCode: "  +  self. item.ItemLookupCode
                                    logger.warn "self.item.customer_item.customer.CustomNumber1: " + self.item.customer_item.customer.CustomNumber1.to_s
                                   self.item.customer_item.customer.CustomNumber1  * 0.01
                else
                                  0.0
                end
end



def fixed_total
	return item.CommissionAmount * self.QuantityRTD
end

def percent_total
	return  self.extended_total_at_commissioned_price *  self.commission_percent_sale
end

def combined_total
			return self.percent_total  +   self.fixed_total
end

 def  symbiont_your_unit_price
    if self.complete_symbiont  
    		quantity = self.QuantityOnOrder 
	 		if self.purchase.customer
	 			customer = self.purchase.customer
	       		return self.item.your_unit_price( customer, quantity ) + self.opposite_entry.item.your_unit_price( customer, quantity )
	 		else
	 			return self.item.full_unit_price(0,quantity)
	 		end	
 	else
 		0
 	end
 end
   
 def  symbiont_your_extended_price
         begin
                return self.symbiont_your_unit_price * self.QuantityOnOrder    
           rescue
                       0
            end
 end





 def  symbiont_full_unit_price
        self.item.full_unit_price + self.opposite_entry.item.full_unit_price
 end
   
 def  symbiont_full_extended_price
         begin
                       self.full_extended_price(0,self.item)  +  self.opposite_entry.full_extended_price(0,self.opposite_entry.item)
           rescue
                       0
            end
 end



########################################################################################################
####### SYMBIONT AREA

 
 def potential_slave_decides_masters_department(potential_slave)
          if self.master_department_id =='0'
                     potential_slave.category.category_class.opposite_default_department_id
            else
                    if self.item.category.use_generic_department == '1'
                        self.item.department_id
                    else
                              if  potential_slave.category.category_class.appearing_sections.include?(self.masters_department_letter_section_code)
                                            self.master_department_id
                                else    
                                            potential_slave.category.category_class.slaves_opposite_master_default_department_id
                               end
                     end
              end
end

 def design_decides_potential_masters_department(parameter_department) ##here self is the slave items purchases entry.
         if self.item.category.category_class.appearing_sections.include?(parameter_department.letter_section_code)

                    potential_dept =      parameter_department.id
          else    

        #          potential_dept =    self.item.category.category_class.slaves_opposite_master_default_department_id
                  potential_dept =    self.item.design_decides_opposites_department
         end
 end

def complete_symbiote(item,master_department, pe_comment)
                                              self.ItemLookupCode  = item.ItemLookupCode
                                              self.master_department_id =  master_department
                                              self.QuantityOnOrder =  self.opposite_entry.QuantityOnOrder  ##be sure to update with param the opposite before this.
                                              self.FullPrice =  item.full_unit_price
                                              self.item_id =  item.id
                                              self.Cost = item.Cost
                                              self.Comment = pe_comment
                                              self.Description =  Slug.generate(item.Description)
                                              self.Price = item.Price
                                              self.LastUpdated = Time.now                                                                 
                                              self.save
                                              opposite = self.opposite_entry
                                              opposite.master_department_id = master_department
                                              opposite.save
end   
    
 def masters_department_letter_section_code
          dep = Department.find(self.master_department_id)
          dep.letter_section_code
 end
 
  def potential_slave_decides_item_class_components(design) 
#@item_class_components  = @item_entry.potential_slave_decides_item_class_components(@design) 
        if  design.opacity_letter == 'o'
                 self.item.item_class_component.item_class.item_class_components
        else
                   self.item.item_class_component.item_class.light_components_only
        end
 end

  def slaves_item_class_components_decision
                 iccs = Set.new
                 self.opposite_entry.item.item_class_component.item_class.item_class_components.each do | icc |
                                if icc.item
                                                if icc.item.WebItem == true
                                                            if  !icc.item.Inactive
                                                                 iccs.add( icc)
                                                            end
                                                end
                                  end

                 end
           return iccs
 end

 def slaves_department_decision
         if self.slave_of_symbiont_pair.item.category.category_class.exclude_from_sections.include?(self.slave_of_symbiont_pair.master_department_letter_section_code)
                      self.slave_of_symbiont_pair.category.category_class.opposite_default_department_id
          else    
                      self.master_of_symbiont_pair.master_department_id
         end
 end

def symbiotic_item?
         symbiotic_item
end


 def symbiotic_item
      if self.item.category.category_class.item_type == 'master' or  self.item.category.category_class.item_type == 'slave' 
             true
      else
              false
      end
 end
 
 def master_of_symbiont_pair
        if self.item.category.category_class.item_type == 'master'
            self
        else
            self.opposite_entry
        end
 end
 
 def slave_of_symbiont_pair
        if self.item.category.category_class.item_type == 'slave'
            self
        else
            self.opposite_entry
        end
 end
 
def master_department_letter_section_code
            master_dept  = Department.find( self.master_department_id )
           return  master_dept.letter_section_code
end

 def complete_symbiont
          if self.item && self.opposite_entry.item
                   true
          else
                   false
          end
 end

 def self.add_singular_designer_item(purchase,item,quantity,department, comment )
											  department = department || 0
                                              purchases_entry =  PurchasesEntry.new
                                              purchases_entry.on_hold = 0
                                              purchases_entry.ItemLookupCode  = item.ItemLookupCode
                                              purchases_entry.master_department_id  = department
                                              purchases_entry.QuantityOnOrder = quantity
                                              purchases_entry.QuantityRTD = 0
                                              purchases_entry.DetailID = 0
                                              purchases_entry.SalesRepID = 0
                                              purchases_entry.PriceSource = 1
                                              purchases_entry.discount_reason_code_id = 0
                                              purchases_entry.return_reason_code_id = 0
                                              purchases_entry.FullPrice = item.full_unit_price
                                              purchases_entry.item_id =  item.id
                                              purchases_entry.purchase_id = purchase.id
                                              purchases_entry.store_id = 7
                                              purchases_entry.Cost = item.Cost
                                              purchases_entry.Comment = comment || 0
                                              purchases_entry.Description = Slug.generate(item.Description)
                                              purchases_entry.Price = item.Price
                                              purchases_entry.Taxable = 1
                                              purchases_entry.LastUpdated = Time.now
                                              purchases_entry.symbiote_purchases_entry_id = 0
                                              purchases_entry.save
                                              purchases_entry
end

def self.add_singular_item(purchase,item,quantity,department, comment )
											  department = department || 0
                                              purchases_entry =  PurchasesEntry.new
                                              purchases_entry.on_hold = 0
                                              purchases_entry.ItemLookupCode  = item.ItemLookupCode
                                              purchases_entry.master_department_id  = department
                                              purchases_entry.QuantityOnOrder = quantity
                                              purchases_entry.QuantityRTD = 0
                                              purchases_entry.DetailID = 0
                                              purchases_entry.SalesRepID = 0
                                              purchases_entry.PriceSource = 1
                                              purchases_entry.discount_reason_code_id = 0
                                              purchases_entry.return_reason_code_id = 0
                                              purchases_entry.item_id =  item.id
                                              purchases_entry.purchase_id = purchase.id
                                              purchases_entry.store_id = 7
                                              purchases_entry.Cost = item.Cost
                                              purchases_entry.Comment = comment || 0
                                              purchases_entry.Description = Slug.generate(item.Description)
                                              purchases_entry.Price = item.Price
                                              purchases_entry.Taxable = 1
                                              purchases_entry.LastUpdated = Time.now      
                                              purchases_entry.symbiote_purchases_entry_id = 0
                                              purchases_entry.FullPrice = item.full_unit_price( purchases_entry)
                                              purchases_entry.save
                                              purchases_entry
end

def master_entry
             if self.item
                          if self.item.category.category_class.item_type == 'master'
                                     true
                          else
                                    false
                          end
              else
                        false
              end
end
  
def opposite_entry
        #logger.warn "#########################################"
        #logger.warn "#########################################"
        #logger.warn "#########################################"
        #logger.warn "#########################################"
        logger.warn "self.symbiote_purchases_entry_id: " +  self.symbiote_purchases_entry_id.to_s
        if self.symbiote_purchases_entry_id != '0' and  self.symbiote_purchases_entry_id != 0
                     PurchasesEntry.where("symbiote_purchases_entry_id = ?", self.id ).first
          else
                   false
        end
end
   
########################################################################################################
####### TOTALS AREA
def full_extended_price(customer=0,item=0)
      if item.class != Item
          item = Item.find(item)
      end
             item.full_unit_price(customer, self) *  self.QuantityOnOrder
end

def your_extended_price(customer=0,quantity=0,item=0)
	begin
      yep = item.unit_quantity_tier_discount_price(customer,quantity,self)  *  self.QuantityOnOrder
      return yep.to_f
 	rescue
 		return 0
 	end
end


def your_extended_price_savings(customer=0,quantity=0,item=0)
      yeps = self.full_extended_price(customer,item)   -   self.your_extended_price(customer,quantity,item)
      return yeps.to_f
end
    
def extended_tax
      self.Price *    0.06
end
    
  
  
  
end
