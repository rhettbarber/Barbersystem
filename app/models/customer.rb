class Customer < ActiveRecord::Base
   has_many :purchases_entries_for_commissions
  has_many :websites
  has_many :customer_items
has_one :customer
has_many :viewable_purchases	
has_one :affiliate
has_one :user
has_many :purchases 
has_many :ship_tos
validates_presence_of  :FirstName, :LastName, :Address, :City, :State, :Zip, :EmailAddress, :PhoneNumber, :EmailAddress



scope :commisioned_artists, :conditions => {:CustomNumber1 => 1},:order => "LastName DESC"

#attr_protected :AccountNumber # not needed if using attr_accessible whitelisting
attr_accessible :FirstName, :LastName, :Address, :Address2 ,:Company, :City, :Country, :State, :Zip, :EmailAddress, :PhoneNumber, :EmailAddress, :default_shipping_service_id,  :TaxNumber, :FaxNumber
attr_accessible :primary_ship_to_id, :Title 

####NOTES
#CurrentDiscount field is the percentage discount this customer gets off an entire order
#PriceLevel determines where in the  quantity_discounts table the price should be taken from


def combined_name
          self.FirstName + " " +  self.LastName + " " + self.Company
end



def commission_percentage
           self.CustomNumber1
end



def self.new_account_number
	random_string = 'mob' + User.generate_random_string.to_s
	if Customer.exists?(:AccountNumber => random_string)
		Customer.new_account_number
	else
		return random_string
	end
end	





def self.customer_for_checkout(customer_form_data,email_address )
                                              customer =  Customer.new
                                              customer.AccountBalance = 0
                                              customer.AccountNumber  = Customer.new_account_number
                                              customer.AccountOpened = Time.now
                                              customer.account_type_id = 0
                                              customer.Address = customer_form_data[:Address]
                                              customer.Address2 = customer_form_data[:Address2]
                                              customer.AssessFinanceCharges = 0
                                              customer.HQID = 0
                                              customer.cashier_id = 1
                                              customer.City = customer_form_data[:City]
                                              customer.Company = customer_form_data[:Company]
                                              customer.Country = 'US'  #customer_form_data[:USPSCountries][:Country] || 0
                                              customer.CreditLimit= 0
                                              customer.CurrentDiscount = 0
                                              customer.default_shipping_service_id = 0
                                              customer.EmailAddress = email_address
                                              customer.Employee = 0
                                              customer.FaxNumber = customer_form_data[:FaxNumber]
                                              customer.FirstName =  customer_form_data[:FirstName]
                                              customer.GlobalCustomer = 0
                                              customer.LastClosingBalance= 0
                                              customer.LastClosingDate = 0                                            
                                              customer.LastName = customer_form_data[:LastName]
                                              customer.LastStartingDate = 0
                                              customer.LastUpdated = Time.now
                                              customer.LayawayCustomer = 0
                                              customer.LimitPurchase = 9000
                                              customer.Notes = customer_form_data[:Notes]
                                              customer.PhoneNumber = customer_form_data[:PhoneNumber]                                                                                                                                                                         
                                              customer.PictureName = 0                                                                    
                                              customer.PriceLevel = 0
                                              customer.primary_ship_to_id = 0
                                              customer.sales_rep_id = 0
                                              customer.State = customer_form_data[:State]
                                              customer.store_id = 1
                                              customer.TaxExempt = 0
                                              customer.TaxNumber= customer_form_data[:TaxNumber]
                                              customer.Title = 0                                               
                                              customer.TotalSales = 0
                                              customer.TotalSavings = 0
                                              customer.TotalVisits = 1
                                              customer.Zip = customer_form_data[:Zip]
                                              customer.mail_to = customer_form_data[:mail_to]                                                  
                                              customer.CustomText1 = 0       
                                              customer.CustomText2 = 0       
                                              customer.CustomText3 = 0       
                                              customer.CustomText4 = 0       
                                              customer

end



def customer_viewable_page_types
  	all_page_type_ids = []
  	if self
     	for pt in self.page_types
     		all_page_type_ids << pt.id
     	end	
     		return all_page_type_ids
	else
		1
	end
 end


def page_types
	self.customer_type_record.page_types
end


def customer_type_record
	#debugger
	if self.PriceLevel == 1
		return CustomerType.find(4)
	elsif self.PriceLevel == 2
          if self.CustomText4 ==  'do' or self.CustomText4 ==  'DO'
                   return CustomerType.find(2)
          else
                   return CustomerType.find(3)
		end	
	elsif self.PriceLevel == 3
		return CustomerType.find(1)
	else
		return CustomerType.find(5)
	end	
end	





def self.customer_types
	['all','preprint','dixie-outfitters-licensed-transfer','transfer','franchise','retail']
end


def customer_type_OLD
	if self.PriceLevel == '1'
		'preprint'
	elsif self.PriceLevel == '2'
		if self.CustomText4 == 'DO' or self.CustomText4 == 'do'
			'dixie-outfitters-licensed-transfer'
		else	
			'transfer'
		end	
	elsif self.PriceLevel == '3'	
		'franchise'
	else
		'retail'	
	end	
end	


def licensed_for_message
	if self.licensed_for == 'DO'
		'You are a Authorized Dealer of Dixie Outfitters Merchandise'
	else
		'If you are interested in ordering Dixie Outfitters Transfers at wholesale prices, 
		Please call 866-916-5866 and ask our Customer Service Representative about becoming a Dixie Outfitters authorized Dealer.'
	end
end

def introduction_image_url(website)
	if  ['barber_store','dixie_store'].include?(website.name) && self.PriceLevel == 3 && self.licensed_for == 'DO'
		 '/images/introductions/' + website.name + '_resources_franchise.jpg'
	elsif self.licensed_for == 'DO' && self.PriceLevel > 0
		 '/images/introductions/' +	website.name + '_resources_licensed.jpg'
	elsif self.PriceLevel > 0 && self.licensed_for != 'DO'
		 '/images/introductions/' +	website.name + '_resources_dealer.jpg'
	else 
		 '/images/introductions/' + website.name + '_resources.jpg'
	end
end	




def greeting_name
    company =  'of ' +  self.Company if self.Company != nil and  self.Company != 0 and  self.Company != ""
    company = ' ' if company.nil?
      self.FirstName + ' ' + self.LastName + ' ' +  company
end




def customer_type
                                                if self.PriceLevel == 0
                                                             customer_type = 'Retail'
                                                elsif self.PriceLevel == 1
                                                              customer_type = 'Preprint'
                                                elsif self.PriceLevel == 2
                                                              customer_type = 'Blank-Transfer'
                                               elsif self.PriceLevel == 3
                                                              customer_type = 'Franchise'
                                                end
end





def primary_shipping_service_name
        if self.default_shipping_service_id  != 0
            primary_shipping_service  = ShippingService.find(self.default_shipping_service_id  )
            primary_shipping_service_name = primary_shipping_service.Name
        else
        primary_shipping_service_name = 'ups_standard'
        end
end


def licensed_for
          if self.CustomText4.downcase  ==  'do'  
                    licensed_for = 'DO'
           else
                      licensed_for = 'No License'
           end
end


def find_pending_orders
    Purchase.find(:all,:conditions => ["customer_id = ? ",self.id ])
end


def  permanent_discount_multiple
              if self.CurrentDiscount != nil or self.CurrentDiscount != 0 or self.CurrentDiscount != '0'
               permanent_discount_multiple = self.CurrentDiscount.to_f   / 100
              else
               permanent_discount_multiple = 0
             end
end



  



end
