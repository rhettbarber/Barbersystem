class CustomersController < ApplicationController

ssl_exceptions

before_filter :initialize_variables , :only => [:edit ,:update ,:show ,:new, :show, :create]

before_filter :user_with_customer? , :except => [:show, :new,  :create ,:create_user_and_customer ]
#before_filter :logged_in_user?



#cache_sweeper :customer_sweeper


##################################################################################################################
def update
	respond_to do |format|
	  if @customer.update_attributes(params[:customer])
      delete_customer_cache
	    flash[:notice] = 'Customer was successfully updated.'
	    format.html { redirect_to customer_url(@customer) }
	    format.xml  { head :ok }
	  else
	    format.html { render :action => "edit" }
	    format.xml  { render :xml => @customer.errors.to_xml }
	  end
	end
end
##################################################################################################################

def index
  Customer.uncached do
    respond_to do |format|
      format.html
      format.xml  { render :xml => @customer.to_xml }
    end
  end
#      if admin?
#            @customers = Customer.all.limit("20")
#      else
#          redirect_to  '/customers/show'
#      end
end
##################################################################################################################
def show
          Customer.uncached do
            respond_to do |format|
                      format.html
                      format.xml  { render :xml => @customer.to_xml }
            end
    end
end
##################################################################################################################
def new
  if @user.customer
                logger.warn "/customers/new   @user.customer"
                logger.warn "/customers/new   @user.customer"
                logger.warn "/customers/new   @user.customer"
                logger.warn "/customers/new   @user.customer"
                #redirect_to  '/account/index'
                redirect_to  '/customers/show'
  else
             logger.warn "/customers/new   NOT @user.customer"
             logger.warn "/customers/new   NOT @user.customer"
             logger.warn "/customers/new   NOT @user.customer"
             logger.warn "/customers/new   NOT @user.customer"
            #    redirect_to(:controller => 'account', :action => 'login')  and return if @user.nil?
                if current_user.customer_id == nil
                        flash[:notice] =  'You have been logged in, please enter your customer billing information'
                end
                @customer = Customer.new
            end
end
##################################################################################################################
def edit
  user_customer   =  @user.customer
  @customer =  user_customer
  logger.warn "##############################################"
  logger.warn "---------------------------------------------"
  logger.warn "##############################################"
  logger.warn "##############################################"
  logger.warn "##############################################"
  logger.warn "##############################################"
  logger.warn "@user.customer.inspect: " + user_customer.inspect
  logger.warn "##############################################"
  logger.warn "##############################################"
  logger.warn "##############################################"
  logger.warn "---------------------------------------------"
  logger.warn "##############################################"
end
##################################################################################################################
def create
  logger.warn "begin customers/create"
  logger.warn "begin customers/create"
  logger.warn "begin customers/create"
  g  = "G"
	@customer =  Customer.new(params[:customer])
	@customer.AccountNumber = Customer.new_account_number
	@customer.AccountBalance = 0
	@customer.AccountOpened = Time.now
	@customer.account_type_id = 0
	@customer.Address2 = 0 if @customer.Address2 == nil
	@customer.AssessFinanceCharges = 0
	@customer.HQID = 0
	@customer.cashier_id = 0
	@customer.sales_rep_id = 0
	@customer.CreditLimit= 0
	@customer.CurrentDiscount = 0
	@customer.Country = "United States"
	@customer.default_shipping_service_id = 1
	@customer.EmailAddress = @user.email
	@customer.Employee = 0
	@customer.FaxNumber =  params[:customer][:FaxNumber] || 0
	@customer.GlobalCustomer = 0
	@customer.LastClosingBalance= 0
	@customer.LastClosingDate = 0                                            
	@customer.LastStartingDate = 0
	@customer.LastUpdated = Time.now
	@customer.LastVisit = Time.now
	@customer.LayawayCustomer = 0
	@customer.LimitPurchase = 9000                                                                                                                                                                        
	@customer.PictureName = 0        
	 if @website.name == "barber_store"
                    logger.warn "customers_controller create...@website.name == barber_store"
                    logger.warn "customers_controller create...@website.name == barber_store"
                    logger.warn "customers_controller create...@website.name == barber_store"
                    logger.warn "customers_controller create...@website.name == barber_store"
	              		@customer.PriceLevel = 2
   elsif params[:promotion_code]
                   logger.warn "customers_controller create...@website.name IS NOT  barber_store"
                   logger.warn "customers_controller create...@website.name IS NOT  barber_store"
                   logger.warn "customers_controller create...@website.name IS NOT  barber_store"
                   logger.warn "customers_controller create...@website.name IS NOT  barber_store"
                   logger.warn " params[:promotion_code]: " +  params[:promotion_code].inspect
                  if params[:promotion_code] == '777'
                          @customer.PriceLevel = 2
                  elsif  params[:promotion_code] == ""
                          @customer.PriceLevel = 0
                  else
                          add_security_warning(5)
                            @customer.PriceLevel = 0
                  end
	else
			@customer.PriceLevel = 0
	end
	@customer.primary_ship_to_id = 0
	@customer.store_id = @website.id
	@customer.TaxExempt = 0
	@customer.TaxNumber = params[:customer][:TaxNumber] || 0
	@customer.Title = 0                                               
	@customer.TotalSales = 0
	@customer.TotalSavings = 0
	@customer.TotalVisits = 1   
	@customer.CustomDate1 = 0       
	@customer.CustomDate2 = 0       
	@customer.CustomDate3 = 0       
	@customer.CustomDate4 = 0                                               
	@customer.CustomText1 = 0       
	@customer.CustomText2 = 0       
	@customer.CustomText3 = 0       
	@customer.CustomText4 = 0 
	@customer.CustomNumber1 = 0       
	@customer.CustomNumber2 = 0       
	@customer.CustomNumber3 = 0       
	@customer.CustomNumber4 = 0 
	@customer.CustomNumber5 = 0
	if @customer.valid?
                         if @customer.save
                           logger.warn "@customer.save"
                           logger.warn "@customer.save"
                           logger.warn "@customer.save"
                           logger.warn "@customer.save"
                          delete_customer_cache
                                            @flash_messages = []
                                             @flash_messages << "Billing Saved-"
                                            #session[:customer_id]  = current_user.customer_id
                                          @user.customer_id = @customer.id
                                          if @user.save
                                                  logger.warn "#########################################"
                                                  logger.warn "#########################################"
                                                  logger.warn "#########################################"
                                                  logger.warn "@user.save successful!!!!"
                                                  logger.warn "@customer.inspect: " + @customer.inspect
                                                  logger.warn "@user.inspect: " + @user.inspect
                                                  logger.warn "#########################################"
                                                  logger.warn "#########################################"
                                                  logger.warn "#########################################"
                                                  session[:customer_id] = @user.customer_id
                                                  delete_user_cache
                                                   if params[:use_billing_for_shipping] == "1"
                                                            @ship_to = ShipTo.new
                                                            @ship_to.Address = @customer.Address
                                                            @ship_to.Address2 = @customer.Address2
                                                            @ship_to.City = @customer.City
                                                            @ship_to.Company = @customer.Company
                                                            @ship_to.Country = @customer.Country
                                                            @ship_to.Name = @customer.FirstName + ' ' + @customer.LastName
                                                            @ship_to.State = @customer.State
                                                            @ship_to.Zip = @customer.Zip
                                                            @ship_to.store_id = @customer.store_id
                                                            @ship_to.EmailAddress = @customer.EmailAddress
                                                            @ship_to.PhoneNumber = @customer.PhoneNumber
                                                            @ship_to.FaxNumber = @customer.FaxNumber
                                                            @ship_to.customer_id = @customer.id
                                                            if @ship_to.save
                                                                  @flash_messages << "-ShipTo Saved-"
                                                                  if @purchase
                                                                        @purchase.ship_to_id = @ship_to.id
                                                                        if @purchase.save
                                                                          @flash_messages << "-ShipTo-on-purchase-saved"
                                                                        end
                                                                  end
                                                            end

                                                   end
                                                   if @purchase
                                                          @purchase.customer_id = @customer.id
                                                           if @purchase.save
                                                                           logger.warn "@purchase.save"
                                                                           logger.warn "@purchase.save"
                                                                           logger.warn "@purchase.save"
                                                                           logger.warn "@purchase.save"
                                                                           delete_purchase_cache
                                                                           @flash_messages << "-Customer-on-purchase-saved"
                                                           end
                                                   end

                                                  flash[:notice] = @flash_messages
                                                         #if session['return-to']
                                                         #                 redirect_to session['return-to']
                                                         #                 session['return-to'] = nil
                                                         # else
                                                         #
                                                          #              redirect_to :controller => 'account' ,:action => "index"
                                                         # end
                                                            logger.warn "next_checkout_step"
                                                            logger.warn "next_checkout_step"
                                                            logger.warn "next_checkout_step"
                                                            logger.warn "next_checkout_step"
                                                            logger.warn "next_checkout_step"
                                                            logger.warn "next_checkout_step"
                                                          redirect_to :controller => 'cart' , :action => "next_checkout_step"
                                          else
                                                        logger.warn "#########################################"
                                                        logger.warn "#########################################"
                                                        logger.warn "#########################################"
                                                        logger.warn "@user.save unsuccessful!!!!"
                                                        logger.warn "@customer.inspect: " + @customer.inspect
                                                        logger.warn "@user.inspect: " + @user.inspect
                                                        logger.warn "#########################################"
                                                        logger.warn "#########################################"
                                                        logger.warn "#########################################"
                                          end
                         else
                                          logger.warn "@customer did not save"
                                          logger.warn "@customer did not save"
                                          logger.warn "@customer did not save"
                                          logger.warn "@customer did not save"
                                          render :new  , :params => @customer
                                           # respond_to do |format|
                                           #       redirect_to( params.merge(:action => 'new'))
                                           #      format.xml  { render :xml => @customer.errors.to_xml }
                                           #  end
                            end
  else
                      logger.warn "@customer not valid"
                      logger.warn "@customer not valid"
                      logger.warn "@customer not valid"
                      logger.warn "@customer not valid"
                      logger.warn "@customer not valid"
                      logger.warn "@customer not valid"
                      render :new  , :params => @customer
	                     # respond_to do |format|
                        #      redirect_to( params.merge(:action => 'new'))
	                     #      format.xml  { render :xml => @customer.errors.to_xml }
	                     #  end
	      end
end
##################################################################################################################
#def update
#	respond_to do |format|
#	  if @customer.update_attributes(params[:customer])
#	  	delete_customer_cache
#	    flash[:notice] = 'Customer was successfully updated.'
#	    format.html { redirect_to customer_url(@customer) }
#	    format.xml  { head :ok }
#	  else
#	    format.html { render :action => "edit" }
#	    format.xml  { render :xml => @customer.errors.to_xml }
#	  end
#	end
#end
##################################################################################################################

end
