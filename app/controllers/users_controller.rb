class UsersController < ApplicationController
#require 'csv'
#before_filter :redirect_unless_admin
ssl_exceptions
before_filter :redirect_unless_cashier  # more harsh
cache_sweeper :user_sweeper


  def edit_credit_card
	                @selected_purchase = Purchase.find( params[:id] )
                  @selected_customer = @selected_purchase.customer
                  if !@selected_customer
                    not_at_selected_customer
                    #redirect_to :action => 'new_customer_from_existing_user',:id => @selected_user.id
                  end
  end

def confirm_credit_card
                  #@selected_purchase = Purchase.find( params[:id] )
                  #@selected_customer = @selected_purchase.customer
                  #if !@selected_customer
                  #  not_at_selected_customer
                  #  #redirect_to :action => 'new_customer_from_existing_user',:id => @selected_user.id
                  #end
end



def charge_credit_card
          #
          #credit_card = ActiveMerchant::Billing::LinkpointGateway.new(
          #  :number     => '4111111111111111',
          #  :month      => '8',
          #  :year       => '2009',
          #  :first_name => 'First',
          #  :last_name  => 'Entry',
          #  :verification_value  => '123'
          #)
          #
          #
          #          if credit_card.valid?    #move to controller
          #                  # Create a gateway object to the TrustCommerce service
          #                  gateway = ActiveMerchant::Billing::LinkpointGateway.new(
          #                    :login    => '1001298660',
          #                    :password => 'asdfasdfe2'
          #      )
          #
          #      # Authorize for $10 dollars (1000 cents)
          #      response = gateway.authorize(1, credit_card)
          #      test_line = 'test_line'
          #      if response.success?
          #        # Capture the money
          #        gateway.capture(1, response.authorization)
          #      else
          #        raise StandardError, response.message
          #      end
          #end
          # Use the TrustCommerce test servers
          #ActiveMerchant::Billing::Base.mode = :test
          #    ActiveMerchant::Billing::LinkpointGateway.pem_file  = File.read( Rails.root.to_s + '/certs/1001298660.pem')
          gateway = ActiveMerchant::Billing::LinkpointGateway.new(
                      :login => '1001298660'
          )

          # ActiveMerchant accepts all amounts as Integer values in cents
          amount = 1  # $10.00

          # The card verification value is also known as CVV2, CVC2, or CID
          credit_card = ActiveMerchant::Billing::CreditCard.new(
                          :first_name         => 'Test',
                          :last_name          => 'Card',
                          :number             => '4242424242424242',
                          :month              => '8',
                          :year               => '2012',
                          :verification_value => '123')



             #@credit_card = credit_card


          #@response =   credit_card.valid?.to_s     #gateway,authorize(1, credit_card)


          # Validating the card automatically detects the card type
          if credit_card.valid?
                    # Capture $10 from the credit card
                    response = gateway.purchase(amount, credit_card, :order_id =>  '11111')
                      ss = 'ss'
                    if response
                                  logger.debug "response: " + response.inspect
                                   if  response.success?
                                      g
                                            @response =  "Successfully charged $#{sprintf("%.2f", amount / 100)} to the credit card #{credit_card.display_number}"
                                    else
                                               #response_was_not_a_success
                                              @response = response

                                    end
                      else
                                    no_response
                        end
          else
                     cc_invalid
            end



end


def find_shipping_info
	conditions = ["purchase_id = ?" , params[:id]  ]
	@the_purchase = UpsIn.find(:all, :conditions => conditions )
	flash[:notice] = 'The tracking number for this package is #' 
	render   'users/show_shipping_info'
end	


################################################
def list_catalog_requests_for_time_period
	@websites = Website.find(:all)
	if params[:website]
		if params[:website][:id]			
			@selected_website = Website.find params[:website][:id]
		else
			@selected_website = Website.find 1
		end
	else
		@selected_website = Website.find 1
	end
	if @selected_website.name == 'dixie_store'
			@catalog_item_id = '11426'
	elsif @selected_website.name == 'barber_store'
			@catalog_item_id = '11427'
	end
	if params[:begin_date]
		@begin_date =  params[:begin_date][:year] +'-'+ params[:begin_date][:month]+'-'+ params[:begin_date][:day]
		@begin_date = Time.parse(@begin_date) || Time.today - 14.days
	else
		@begin_date = Time.now.at_beginning_of_month
	end		
	if params[:end_date]
		@end_date =  params[:end_date][:year] +'-'+ params[:end_date][:month]+'-'+ params[:end_date][:day]
		@end_date = Time.parse(@end_date) || Time.today - 14.days
	else
		@end_date = Time.now.at_end_of_month
	end	 
	conditions    = ["purchases.Total < ? and purchases.Time > ? and purchases.Time < ? and purchases_entries.item_id = ?", 1 , @begin_date , @end_date , @catalog_item_id ]
	@purchases_entries = PurchasesEntry.find(:all, :conditions => conditions, :include => [:purchase ] , :order => "purchases.Time ASC")
	
	conditions    = ["sales.Total > ? and sales.sale_time >= ? and sales.sale_time <= ? and sales_entries.item_id = ?", 0 , @begin_date , @end_date , @catalog_item_id ]
	@sales_entries = SalesEntry.find(:all, :conditions => conditions, :include => [:sale ] , :order => "sales.sale_time ASC")
	@customer_ids_to_exclude_because_of_sales = []
	@sales_entries.each do |se|
			@customer_ids_to_exclude_because_of_sales << se.sale.customer.id
	end
	@selected_purchases_entries = []
	@added_customer_ids = []
	@purchases_entries.each do |pe|
			if pe.purchase.customer
					unless @customer_ids_to_exclude_because_of_sales.include?(pe.purchase.customer.id)
							@selected_purchases_entries << pe   unless @added_customer_ids.include?(pe.purchase.customer.id)
							@added_customer_ids << pe.purchase.customer.id
					end
			end
	end
end
################################################
def items_keyworder
 			logger.debug "@locked_item_ids: #{@locked_item_ids}"
			@locked_item_ids  = Caching::MemoryCache.instance.read "locked_item_ids"
 			@locked_item_ids ||= ['0']
 			#logger.warn "@website.default_design_department_ids.split(/,/) : #{@website.default_design_department_ids.split(/,/) }"
			conditions = ["id  NOT IN (?) and Notes = ? and department_id in (?)"  , @locked_item_ids ,  "" , @website.default_design_department_ids.split(/,/)   ]
             @items = Item.find(:all, :conditions => conditions ,:limit => 4, :order => "ItemLookupCode ASC")
            # logger.warn "@locked_item_ids: #{@locked_item_ids}"
            # logger.warn "@items.size: #{@items.size}"
             #@locked_item_ids +=	Item.ids_array(@items)
             Caching::MemoryCache.instance.write "locked_item_ids", @locked_item_ids , :expires_in => 40.minutes
           	 render(:partial => "users/items_keyworder_list" )
           	 logger.debug "@locked_item_ids: #{@locked_item_ids}"
end
################################################
def update_item_notes
	items = params[:item]
	if Item.update(items.keys, items.values)
		flash[:notice] = "Successfully updated item descriptions"
		redirect_to :back
	else
		flash[:notice] = "Update failed"
		redirect_to :back
	end
end
################################################
################################################




def index
    logger.debug "-------------------------------------begin users/index"
    @users = User.find(:all ,:from => [:customers_users]  , :limit => 50 )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
    logger.debug "-------------------------------------end users/index"
 end

################################################
def find_user_via_form
    ## UPDATE THIS TO MSFTE
	 keywords = params[:user_keywords]
 	conditions = ["email LIKE ? or FirstName LIKE ? or LastName LIKE ? or Company LIKE ? or AccountNumber LIKE ? or Zip LIKE ? or City LIKE ? or PhoneNumber LIKE ? or firstname_lastname LIKE ? or parsed_phonenumber  LIKE ?","%#{keywords}%" ,"%#{keywords}%" ,"%#{keywords}%","%#{keywords}%","%#{keywords}%","%#{keywords}%","%#{keywords}%","%#{keywords}%","%#{keywords}%","%#{keywords}%" ]
	@users = User.find(:all ,:from => [:customers_users], :conditions => conditions, :limit => 50 )
	render :partial => "users/user", :collection => @users, :spacer_template => "page_divider" ,:layout => 'none'
end
################################################
################################################



def find_item
		## @website_items and the others are cached collections of all items for each website created at: lib/startup_browsing - startup_specific_items
		startup_specific_items
		item_search_with_rank(@all_websites_all_items, params[:item_keywords]) 
		
		render :partial => "users/item", :collection => @items, :spacer_template => "page_divider" ,:layout => 'none'
end



################################################

  def items_index
     logger.debug "-------------------------------------begin items_index"
    @items = Item.find(:all  , :limit => 50 )
    respond_to do |format|
      format.html # index.html.erb
    end
    logger.debug "-------------------------------------end items_index"
 end

################################################

def list_selected_users_past_orders
	@selected_customer = Customer.find(params[:id])
	@sales = Sale.find(:all, :conditions => ["customer_id = ?", @selected_customer ])
	@purchases = Purchase.find(:all, :conditions => ["customer_id = ?", @selected_customer ])
end	


def export_catalog_requests_to_csv
  @selected_purchases_entries = PurchasesEntry.find(params[:selected_purchases_entries])
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |csv|
      csv << %w(AccountNumber Company FirstName LastName Address Address2 City State Zip)
	      @selected_purchases_entries.each do |purchases_entry|
	       if purchases_entry.purchase.customer	
		        csv << [
		    purchases_entry.purchase.customer.AccountNumber,
		    purchases_entry.purchase.customer.Company,
		    purchases_entry.purchase.customer.FirstName,
		    purchases_entry.purchase.customer.LastName,
		    purchases_entry.purchase.customer.Address,
		    purchases_entry.purchase.customer.Address2,
		    purchases_entry.purchase.customer.City,
		    purchases_entry.purchase.customer.State,
		    purchases_entry.purchase.customer.Zip
	        ]
        	end
	      end
    end
    report.rewind
    send_data(report.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => @website.name + '_cat_req_' + params[:begin_date] + '_to_' + params[:end_date] + '.csv')
	flash[:notice] = 'Your export should have completed.'
end	

def confirm_sort_purchase_entries_by_itemlookupcode
end	


def sort_purchase_entries_by_itemlookupcode
	conditions = ["purchase_id = ? and item_id != ?" , params[:id] , '0'   ]
	@original_purchases_entries = PurchasesEntry.find(:all, :conditions => conditions )
	@new_purchases_entries = []
	@original_purchases_entries.sort_by{|a| a.item.ItemLookupCode}.each do |pe|
		pe_clone = pe.clone
		pe_clone.symbiote_purchases_entry_id = 0
		pe_clone.save
		pe.destroy
	end		
	flash[:notice] = 'Finished sorting Quote #' + params[:id]	+ ' with total of ' + @original_purchases_entries.size.to_s + ' records'
	redirect_to :action => 'finished_sorting', :id => params[:id]
end	

def finished_sorting
	
end


def confirm_find_user_by_email
end

def find_user_by_email
	@selected_user = User.find(params[:id])
	if @selected_user
		flash[:notice] = 'This User was found with the email address you entered. Please "Load this customer into RMS"'
		redirect_to :action => 'show',:id => @selected_user.id
	else
		flash[:notice] = 'User find failed'
		render :action => 'confirm_find_user_by_email'
	end	
end


def confirm_load_users_last_quote
#	@selected_user = User.find(params[:id])
#	@selected_customer = @selected_user.customer 
#	if @selected_user && @selected_customer
#		@last_order = @selected_user.customer.purchases.find(:first, :order "Time DESC")
#		if @last_order
#			
#		else
#			flash[:notice] = 'No Last Quote Found'
#			render :action => 'index'
#		end	
#	else
#		flash[:notice] = 'This User has no Customer'
#		render :action => 'index'
#	end		
end	


def confirm_password_reset
	@selected_user = User.find(params[:id])
end	

def reset_password
	@selected_user = User.find(params[:id])
	if @selected_user.customer
		if @selected_user.customer
			random_string = 'pass' + User.generate_random_string.to_s
			@selected_user.password = random_string
			@selected_user.password_confirmation = random_string
			if @selected_user.save
				 UserNotifier.deliver_email_new_password(@selected_user, @website, random_string )
				flash[:notice] = 'Password changed to a Random sequence and was emailed to the user'
				redirect_to :action => 'show',:id => @selected_user
			else	
				flash[:notice] = 'Error Changing Password'
				render :action => 'index'
			end	
		else
			flash[:notice] = 'Customer AccountNumber is invalid for password making purposes'
			redirect_to :action => 'index'
		end	
	else
		flash[:notice] = 'This user has no customer, this can only be done with user with valid customer and AccountNumber'
		redirect_to :action => 'index'
	end	
end	

def associate_user_to_customer
	if params[:user_id] && params[:customer_id]
		@selected_user = User.find(params[:user_id])
		@selected_customer = Customer.find(params[:customer_id])
		if @selected_user && @selected_customer
			if @selected_user.email == @selected_customer.EmailAddress
					@selected_user.customer_id = @selected_customer.id
					if @selected_user.save
						flash[:notice] = 'User/Customer sucessfully linked!.'
						redirect_to :action => 'show',:id => @selected_user.id
					else
						flash[:notice] = '@selected_user save failed'
						render :action => 'confirm_associate_user_to_customer'
					end		
			else
				flash[:notice] = '@selected_user & @selected_customer emails did not match.'
				render :action => 'confirm_associate_user_to_customer'
			end
		else
			flash[:notice] = '@selected_customer or @selected_user not found'
			render :action => 'confirm_associate_user_to_customer'
		end		
	else
		flash[:notice] = 'params failure'
		render :action => 'confirm_associate_user_to_customer'
	end	
end


def confirm_associate_user_to_customer
	## gather params here using qsrules
end

def new_user_from_existing_customer
	    @selected_user = User.new
	    @selected_customer = @selected_user.customer
end
################################################
def create_user_from_existing_customer
	if params[:id]
		@selected_customer = Customer.find(params[:id])
		if @selected_customer
				@selected_user = User.new
				@selected_user.user_type_id = '4'
				@selected_user.customer_id = @selected_customer.id
				@selected_user.email = @selected_customer.EmailAddress
				@selected_user.password = @selected_customer.AccountNumber
				@selected_user.password_confirmation = @selected_customer.AccountNumber
				#@selected_user.a_id = User.new_a_id_code
						if @selected_user.save
						 	 redirect_to :action => 'show',:id => @selected_user.id
						else	
							  flash[:notice] = 'save failed!!'
							 render :action => 'new_user_from_existing_customer'
						end	
			else	
				flash[:notice] = '@selected_customer not found'
				render :action => 'new_user_from_existing_customer'
			end
	else	
		flash[:notice] = 'Param Pass Error'
		render :action => 'new_user_from_existing_customer'
	end
end
################################################
def find_user_orig
	 keywords = params[:user_keywords]
	 conditions = ["email LIKE ? or customers.FirstName LIKE ? or customers.LastName LIKE ? or customers.Company LIKE ? or customers.AccountNumber LIKE ?","%#{keywords}%" ,"%#{keywords}%","%#{keywords}%","%#{keywords}%","%#{keywords}%" ]
	@users = User.find(:all,:include => [:customer] , :conditions => conditions, :limit => 50 ) 
	render :partial => "users/user", :collection => @users, :spacer_template => "page_divider" ,:layout => 'none'
end
################################################
  def show
    @selected_user = User.find(params[:id])
	@selected_customer = @selected_user.customer
    if @selected_customer
	    respond_to do |format|
	      format.html # show.html.erb
	      format.xml  { render :xml => @selected_user }
	    end
	else
		flash[:notice] = 'No official customer record was found, please create one now'
		redirect_to :action => 'new_customer_from_existing_user',:id => @selected_user.id
	end	
  end

################################################
  def new_customer_from_existing_user
    @selected_user = User.find(params[:id])
	@selected_customer = Customer.new
  end

################################################
def create_new_customer_record_only
	@selected_user = User.find(params[:id])
	params[:customer][:EmailAddress] = @selected_user.email
	@selected_customer = Customer.customer_for_checkout(params[:customer],@selected_user.email )
   	@selected_customer.PriceLevel = params[:customer][:PriceLevel] 
    @selected_customer.CurrentDiscount = params[:customer][:CurrentDiscount] 
    @selected_customer.CurrentDiscount = 0 if @selected_customer.CurrentDiscount == nil 
   customer_account_number = Customer.new_account_number
   @selected_user.password = customer_account_number
   @selected_user.password_confirmation = customer_account_number
	if @selected_customer.valid? && @selected_user.valid?
		  if @selected_user.save && @selected_customer.save
		       @selected_user.customer_id = @selected_customer.id
		       @selected_user.save
		       @ship_to = ShipTo.ship_to_from_customer_billing(@selected_customer)
		       @ship_to.save
		       redirect_to :action => 'show',:id => @selected_user.id
		   else
		     render :action => 'new_customer_from_existing_user'
		   end
   else
     render :action => 'new_customer_from_existing_user'
   end
end 

################################################
  def new
    @selected_user = User.new
		@selected_customer = Customer.new
  end
################################################
def create
	params[:customer][:EmailAddress] = params[:user][:email]
   @selected_customer = Customer.customer_for_checkout(params[:customer],params[:customer][:EmailAddress] )
   @selected_customer.PriceLevel = params[:customer][:PriceLevel] 
   @selected_customer.CurrentDiscount = params[:customer][:CurrentDiscount] || 0
   @selected_customer.CustomText1 = params[:customer][:CustomText1] || 0
   @selected_customer.CustomText2 = params[:customer][:CustomText2] || 0
   @selected_customer.CustomText3 = params[:customer][:CustomText3] || 0
   @selected_customer.CustomText4 = params[:customer][:CustomText4] || 0
 @selected_customer.CustomDate1 = params[:customer][:CustomDate1] || 0
@selected_customer.CustomDate2 = params[:customer][:CustomDate2] || 0
@selected_customer.CustomDate3 = params[:customer][:CustomDate3] || 0
@selected_customer.CustomDate4 = params[:customer][:CustomDate4] || 0
@selected_customer.CustomDate5 = params[:customer][:CustomDate5] || 0	
@selected_customer.CustomNumber1 = params[:customer][:CustomNumber1] || 0
@selected_customer.CustomNumber2 = params[:customer][:CustomNumber2] || 0
@selected_customer.CustomNumber3 = params[:customer][:CustomNumber3] || 0
@selected_customer.CustomNumber4 = params[:customer][:CustomNumber4] || 0
@selected_customer.CustomNumber5 = params[:customer][:CustomNumber5] || 0	
   @selected_customer.LastVisit = Time.now
   if @selected_customer.CurrentDiscount == nil
   	@selected_customer.CurrentDiscount = 0
   end	
   @selected_user = User.new(params[:selected_user])
   customer_account_number = Customer.new_account_number
   @selected_user.password = customer_account_number
   @selected_user.password_confirmation = customer_account_number
   @selected_user.user_type_id = '4'
   @selected_customer.AccountNumber = customer_account_number
   @selected_user.email = params[:user][:email]
     if @selected_customer.valid? and @selected_user.valid?
			 			 logger.info "-------@selected_customer.valid? && @selected_user.valid? == TRUE"
						  User.transaction do
								  @selected_user.save!
								  @selected_customer.save!
								       logger.info "-------@selected_user.save && @selected_customer.save == TRUE"
								       @selected_user.customer_id = @selected_customer.id
								       @selected_user.save
								       @selected_ship_to = ShipTo.ship_to_from_customer_billing(@selected_customer)
								       @selected_ship_to.save!
						  end
					       redirect_to :action => 'show',:id => @selected_user.id
	   else  
	    		logger.info "-------@selected_customer.valid? && @selected_user.valid? == FALSE"
	    	#debugger
	     		flash[:notice] = @selected_user.errors.to_xml + @selected_customer.errors.to_xml
	        redirect_to( params.merge(:action => 'new').reject {|key,value| ["authenticity_token","password"].include?(key) } )
	   end
end 
################################################
 def update
   @selected_user = User.find(params[:id])
   @selected_customer = @selected_user.customer
   @selected_user.attributes = params[:user]
   @selected_customer.attributes = params[:customer]
   @selected_customer.PriceLevel = params[:customer][:PriceLevel] 
   @selected_customer.CurrentDiscount = params[:customer][:CurrentDiscount] 
	if @selected_customer.valid? && @selected_user.valid?
		 if @selected_user.save && @selected_customer.save
     		redirect_to :action => 'show', :id => @selected_user.id
     	 else
		     render :action => 'edit'
		 end
   else
     render :action => 'edit'
   end
 end 

################################################
  def destroy
    @selected_user = User.find(params[:id])
    if @selected_user.customer
	    if @selected_user.customer.ship_tos
		    for ship_to in @selected_user.customer.ship_tos
		    	ship_to.destroy
			end
		end
		@selected_user.customer.destroy
	end
    @selected_user.destroy
    respond_to do |format|
      flash[:notice] = 'User/Customer/ShipTos Destroyed'
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

################################################
  def edit
    @selected_user = User.find(params[:id])
    @selected_customer = @selected_user.customer
    if !@selected_customer
    	redirect_to :action => 'new_customer_from_existing_user',:id => @selected_user.id
    end	
  end
##################################################

################################################## DEPRECATTIONS
def create_validation_works
	params[:customer][:EmailAddress] = params[:user][:email]
   @selected_customer = Customer.new(params[:customer])
   	
   @selected_user = User.new(params[:user])
	if @selected_customer.valid? && @selected_user.valid?
		  if @selected_user.save && @selected_customer.save
		       @selected_user.customer_id = @selected_customer.id
		       @selected_user.save
		       redirect_to :action => 'show'
		   else
		     render :action => 'new'
		   end
   else
     render :action => 'new'
   end
end 

##################################################
private
def update_session_expiration_date
   unless ActionController::Base.session_options[:session_expires]
     ActionController::Base.session_options[:session_expires] = 4.hours.from_now
   end
end


end
