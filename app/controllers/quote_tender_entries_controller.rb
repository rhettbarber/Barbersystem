class QuoteTenderEntriesController < ApplicationController

ssl_exceptions
before_filter :initialize_variables, :only => [:index,:check,:credit_card, :net_30]

  #after_filter :flash_to_json_header

before_filter :user_with_customer?
#before_filter :incomplete_symbiont?
#before_filter :purchase_in_progress?

 def verify_credit_card
                        @credit_card = ActiveMerchant::Billing::CreditCard.new(
                        :type               => "visa",
                        :number             => "3024007148673576",
                        :verification_value => "123",
                        :month              => 1,
                        :year               => Time.now.year+1,
                        :first_name         => "Greg",
                        :last_name          => "Barber"
                      )

                unless @credit_card.valid?
                          @credit_card.errors.full_messages.each do |message|
                    #        errors.add_to_base message
                              $stdout.puts "777777777777777777777777777777777777"
                              $stdout.puts "777777777777777777777777777777777777 message: " + message
                              $stdout.puts "777777777777777777777777777777777777"
                          end
                end
                render :layout => false, :inline =>     "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}"
  end

def verify_credit_card_fields
				if params[:CreditCardExpirationMonth] and  params[:CreditCardExpirationYear]
                                if params[:CreditCardExpirationMonth] != " " and  params[:CreditCardExpirationYear]  != " "
                                            respond_to do |format|
                                                           @quote_tender_entry.tender_id = 2
                                                           @quote_tender_entry.Amount = @purchase.Total
                                                           @quote_tender_entry.purchase_id = @purchase.id
                                                           @quote_tender_entry.CreditCardExpiration = params[:CreditCardExpirationMonth] + '/' + params[:CreditCardExpirationYear]
                                                           @quote_tender_entry.CreditCardApprovalCode = params[:quote_tender_entry][:CreditCardApprovalCode]
                                                           @purchase.Comment =  @quote_tender_entry.CreditCardNumber + '-' + @quote_tender_entry.CreditCardExpiration + '-' + @quote_tender_entry.CreditCardApprovalCode
                                                           @customer.CustomText1 =  @quote_tender_entry.CreditCardNumber
                                                           @customer.CustomText2 =  @quote_tender_entry.CreditCardExpiration + '-' + @quote_tender_entry.CreditCardApprovalCode

                                                    format.html { render :text => "success" }
                                                     format.js { render :text => "success for js" }

                                             end
                           else
                                      flash[:notice] = "Credit Card date must be filled completely"
                                      logger.debug "-----CREDIT CARD DATES BLANK-----"
                                      logger.debug "-----CREDIT CARD DATES BLANK-----"
                                      render :text => "missing param 1"
                          end
						 else
						 			flash[:notice] = "Credit Card date must be filled completely ALTOGETHER MISSING PARAM"
						 			logger.debug "-----CREDIT CARD DATES BLANK-----"
						 			logger.debug "-----CREDIT CARD DATES BLANK-----"
                  render :text => "missing param 1"
						end
end
#############################################################################################################################
def credit_card
		@quote_tender_entry =  @purchase.quote_tender_entry || QuoteTenderEntry.new
				if @quote_tender_entry
		 				begin
		 						@selected_month = @quote_tender_entry.CreditCardExpiration.split('/')[0]
								@selected_year = @quote_tender_entry.CreditCardExpiration.split('/')[1]
						rescue
								@selected_month = " "
								@selected_year = " "
						end
				else
		 				@selected_month = " "
						@selected_year = " "
				end
		return unless request.post?
				if params[:CreditCardExpirationMonth] and  params[:CreditCardExpirationYear]  
									if params[:CreditCardExpirationMonth] != " " and  params[:CreditCardExpirationYear]  != " " 
											        if  @purchase.quote_tender_entry
											        		logger.debug "-------------------------------------@purchase.quote_tender_entry: #{@purchase.quote_tender_entry}"
											                 @quote_tender_entry = @purchase.quote_tender_entry
											                 @quote_tender_entry.update_attributes(params[:quote_tender_entry])
											        else         
											            	logger.debug "-------------------------------------NOT @purchase.quote_tender_entry"      
											        		@quote_tender_entry = QuoteTenderEntry.new(params[:quote_tender_entry])
											        end 
											        
											        respond_to do |format|
											           @quote_tender_entry.tender_id = 2
											           @quote_tender_entry.Amount = @purchase.Total
											           @quote_tender_entry.purchase_id = @purchase.id 
											       	   @quote_tender_entry.CreditCardExpiration = params[:CreditCardExpirationMonth] + '/' + params[:CreditCardExpirationYear] 
											       	   @quote_tender_entry.CreditCardApprovalCode = params[:CreditCardApprovalCode]
											       	   @quote_tender_entry.CreditCardNumber = params[:CreditCardNumber]
											           @purchase.Comment =  @quote_tender_entry.CreditCardNumber + '-' + @quote_tender_entry.CreditCardExpiration + '-' + @quote_tender_entry.CreditCardApprovalCode
											           @customer.CustomText1 =  @quote_tender_entry.CreditCardNumber 
												       @customer.CustomText2 =  @quote_tender_entry.CreditCardExpiration + '-' + @quote_tender_entry.CreditCardApprovalCode
											       		if @quote_tender_entry.valid?  
													       	if @quote_tender_entry.save! 
													          		if @purchase.save! 
                                                  #	if @customer.save!   #update_attributes!(:CustomText1 => @customer_CustomText1, :CustomText2 => @customer_CustomText2 )
                                                      logger.debug "-----AVID-----------------------@quote_tender_entry.saveD && @purchase.saveD && @customer.saveD"
                                                      delete_customer_cache
                                                      delete_purchase_cache
                                                       session[:checkout_quote_tender_entry] = true
                                                      flash[:notice] = 'QuoteTenderEntry was successfully created.'
                                                      format.html  {    redirect_to :controller => 'cart' , :action => "next_checkout_step" }
															        else
																	    logger.debug "-----AVID2-------SAVE FAILED------ @purchase.save"
															            format.html { render :action => "credit_card" }
															            format.xml  { render :xml => @quote_tender_entry.errors.to_xml }
															        end    
													          else
													          		logger.debug "-----AVID1-------SAVE FAILED------@quote_tender_entry.save"
													            format.html { render :action => "credit_card" }
													            format.xml  { render :xml => @quote_tender_entry.errors.to_xml }
													          end
														  else
												          		logger.debug "-----VALIDATION FAILED------@quote_tender_entry.valid?"
												            format.html { render :action => "credit_card" }
												            format.xml  { render :xml => @quote_tender_entry.errors.to_xml }
												          end
											        end
									 else
									 			flash[:notice] = "Credit Card date must be filled completely"
									 			logger.debug "-----CREDIT CARD DATES BLANK-----"
									 			logger.debug "-----CREDIT CARD DATES BLANK-----"
									 			render :action => "credit_card" #,:CreditCardExpirationMonth => params[:CreditCardExpirationMonth], :CreditCardExpirationYear =>   params[:CreditCardExpirationYear] , :quote_tender_entry => params[:quote_tender_entry]
                   end
						 else
						 			flash[:notice] = "Credit Card date must be filled completely"
						 			logger.debug "-----CREDIT CARD DATES BLANK-----"
						 			logger.debug "-----CREDIT CARD DATES BLANK-----"
						 			render :action => "credit_card" 
						end 
end
#############################################################################################################################
def index

end
#############################################################################################################################
def net_30
	logger.debug "-------------------------------------@purchase.quote_tender_entry: #{@purchase.quote_tender_entry}"	
        	if  @purchase.quote_tender_entry  
             @quote_tender_entry = @purchase.quote_tender_entry
           else
              @quote_tender_entry = QuoteTenderEntry.new
        	end
            @quote_tender_entry.CreditCardNumber = '3030303030'
            @quote_tender_entry.CreditCardApprovalCode = 0
            @quote_tender_entry.CreditCardExpiration = 0
            @quote_tender_entry.tender_id = 5
            @quote_tender_entry.Amount = @purchase.Total
            @quote_tender_entry.purchase_id = @purchase.id 
        	@purchase.Comment =  "NET 30-!!REMEMBER CHARGE!!"
            @quote_tender_entry.save 
            @purchase.save
            delete_purchase_cache
end
#############################################################################################################################
def cod_money_order_cashiers_check
	logger.debug "-------------------------------------@purchase.quote_tender_entry: #{@purchase.quote_tender_entry}"	
        	if  @purchase.quote_tender_entry  
             @quote_tender_entry = @purchase.quote_tender_entry
           else
              @quote_tender_entry = QuoteTenderEntry.new
        	end
            @quote_tender_entry.CreditCardNumber = '6046604660466046'
            @quote_tender_entry.CreditCardApprovalCode = 0
            @quote_tender_entry.CreditCardExpiration = 0
            @quote_tender_entry.tender_id = 14
            @quote_tender_entry.Amount = @purchase.Total
            @quote_tender_entry.purchase_id = @purchase.id 
        	@purchase.Comment =  "COD CASH-!!REMEMBER CHARGE!!"
            @quote_tender_entry.save 
            @purchase.save
            delete_purchase_cache
end
#############################################################################################################################
def cod_check
	logger.debug "-------------------------------------@purchase.quote_tender_entry: #{@purchase.quote_tender_entry}"	
        	if  @purchase.quote_tender_entry  
             @quote_tender_entry = @purchase.quote_tender_entry
           else
              @quote_tender_entry = QuoteTenderEntry.new
        	end
            @quote_tender_entry.CreditCardNumber = '6047604760476047'
            @quote_tender_entry.CreditCardApprovalCode = 0
            @quote_tender_entry.CreditCardExpiration = 0
            @quote_tender_entry.tender_id = 12
            @quote_tender_entry.Amount = @purchase.Total
            @quote_tender_entry.purchase_id = @purchase.id 
        	@purchase.Comment =  "COD CHECK-!!REMEMBER CHARGE!!"
            @quote_tender_entry.save 
            @purchase.save
            delete_purchase_cache
end
#############################################################################################################################
def check
	logger.debug "-------------------------------------@purchase.quote_tender_entry: #{@purchase.quote_tender_entry}"
	logger.debug "-------------------------------------params[:quote_tender_entry: #{params[:quote_tender_entry]}"	
           if  @purchase.quote_tender_entry  
             @quote_tender_entry = @purchase.quote_tender_entry
           else
              @quote_tender_entry = QuoteTenderEntry.new
            end
            @quote_tender_entry.CreditCardNumber = '77777777'
            @quote_tender_entry.CreditCardApprovalCode = 0
            @quote_tender_entry.CreditCardExpiration = 0
            @quote_tender_entry.tender_id = 3
            @quote_tender_entry.Amount = @purchase.Total
            @quote_tender_entry.purchase_id = @purchase.id 
        	@purchase.Comment =  "Mail-In-Check" + '-' + @quote_tender_entry.CreditCardExpiration.to_s
            @quote_tender_entry.save
            @purchase.save
            delete_purchase_cache
end
#############################################################################################################################
def show
    if @purchase.quote_tender_entry
          @quote_tender_entry = @purchase.quote_tender_entry
          respond_to do |format|
            format.html # show.rhtml
            format.xml  { render :xml => @purchase.quote_tender_entry.to_xml }
            end
      else
        redirect_to :action => 'new'
      end
end
#############################################################################################################################
def edit
	@quote_tender_entry =  @purchase.quote_tender_entry
end
#############################################################################################################################













#############################################################################################################################

#def verify_credit_full_test
#
#ActiveMerchant::Billing::Base.mode = :test
#                      gateway = ActiveMerchant::Billing::PaypalGateway.new(
#                        :login => "b_rhet_1297983751_biz_api1.yahoo.com",
#                        :password => "1297983772",
#                        :signature => "AgTBr7iW6QOM16hYAXxonu1FoUr3AnE5-zUfiIBywdOqbh3qMOdQ05XV"
#                      )
#
#                      credit_card = ActiveMerchant::Billing::CreditCard.new(
#                        :type               => "visa",
#                        :number             => "3024007148673576",
#                        :verification_value => "123",
#                        :month              => 1,
#                        :year               => Time.now.year+1,
#                        :first_name         => "Rhett",
#                        :last_name          => "Barber"
#                      )
#
#                      if credit_card.valid?
#                                  response = gateway.authorize(1000, credit_card, :ip => "127.0.0.1")
#                                  if response.success?
#                                    gateway.capture(1000, response.authorization)
#                                         response_success
#                                  else
#                                          response_failure
#                                       puts "Error: #{response.message}"
#                                  end
#                      else
#                            logger.warn "5555555555555555555555555555555555555555555555555 card_not_valid"
#                             logger.warn "5555555555555555555555555555555555555555555555555 card_not_valid"
#                                #card_not_valid
#                                flash[:notice] = "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}"
#                                render :layout => false, :inline =>     "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}"
#                      end
#end


#                if @purchase.ship_to.update_attributes(  @the_field_name  =>    @the_value           )
#                          flash[:notice] ||= "Successfully updated comment."
#                             render :layout => false, :inline =>  params[:value].to_s
#
#               else
#                                flash[:notice] ||= "Attention: " + @purchase.ship_to.errors.to_s.inspect.to_s
#                               render :layout => false, :inline =>     @purchase.errors.to_s.inspect.to_s , :status => 444 # @customer.errors.to_s
#
#               end




##################### BAD - INSECURE BY DEFAULT WITH FILTERS OFF
##################### BAD - INSECURE BY DEFAULT
##################### BAD - INSECURE BY DEFAULT
##################### BAD - INSECURE BY DEFAULT
##################### BAD - INSECURE BY DEFAULT
##################### BAD - INSECURE BY DEFAULT
##################### BAD - INSECURE BY DEFAULT
##################### BAD - INSECURE BY DEFAULT
##################### BAD - INSECURE BY DEFAULT WITH FILTERS OFF
#############################################################################################################################
##################### BAD - INSECURE BY DEFAULT UPDATES ANYTHING
##################### BAD - INSECURE BY DEFAULT UPDATES ANYTHING
##################### BAD - INSECURE BY DEFAULT UPDATES ANYTHING
  def update   ##################### BAD - INSECURE BY DEFAULT UPDATES ANYTHING
    insecure_update
    #startup_purchase
    #             if

  end
#               session[:verified_purchase] = false
#
#              if session[:verified_purchase] == false
#                        verify_credit_card
#            else
#                              startup_purchase
#                            @quote_tender_entry =  @purchase.quote_tender_entry
#                            @quote_tender_entry.attributes = params[:quote_tender_entry]
#
#                            if @quote_tender_entry.save
#                              @quote_tender_entry.reload
#
#                              flash[:success] = "Successfully updated quote_tender_entry."
#
#                              render :partial => 'edit', :locals => {:quote_tender_entry => @quote_tender_entry}
#                            else
#                              flash[:invalid] = @quote_tender_entry.errors.full_messages
#                              render :partial =>  'edit', :status => 444
#                            end
#           end
#  logger.warn "5555555555555555555555555555555555555555555555555"
#  logger.warn "5555555555555555555555555555555555555555555555555"
#
#    logger.warn "flash.inspect" +  flash.inspect
#  logger.warn "params.inspect" +  params.inspect
#   logger.warn "session.inspect" +  session.inspect
#  logger.warn "5555555555555555555555555555555555555555555555555"
#  logger.warn "5555555555555555555555555555555555555555555555555"
#end
#############################################################################################################################
#def update_old
#  startup_purchase
#  if params[:verified_purchase] == '0'
#    verify_credit_card
#  else
#    @quote_tender_entry =  @purchase.quote_tender_entry
#    if @purchase.quote_tender_entry
#      logger.debug "-------------------------------------@purchase.quote_tender_entry: #{@purchase.quote_tender_entry}"
#      respond_to do |format|
#        @quote_tender_entry.CreditCardExpiration = params[:CreditCardExpirationMonth] + '/' + params[:CreditCardExpirationYear] if params[:CreditCardExpirationMonth] && params[:CreditCardExpirationYear]
#        if @quote_tender_entry.update_attributes(params[:quote_tender_entry])
#          @purchase.Comment =  @quote_tender_entry.CreditCardNumber + '-' + @quote_tender_entry.CreditCardExpiration
#          if @purchase.save
#            delete_purchase_cache
#            flash[:notice] = 'QuoteTenderEntry was successfully updated.'
#            format.html { redirect_to quote_tender_entry_url(@quote_tender_entry) }
#            format.xml  { head :ok }
#          else
#            format.html { render :action => "edit" }
#            format.xml  { render :xml => @quote_tender_entry.errors.to_xml }
#          end
#        else
#          format.html { render :action => "edit" }
#          format.xml  { render :xml => @quote_tender_entry.errors.to_xml }
#        end
#      end
#    else
#      bad_no_purchase_quote_tender_entry
#    end
#  end
#end
#############################################################################################################################
#############################################################################################################################
def destroy_OFF
	@quote_tender_entry =  @purchase.quote_tender_entry
	@quote_tender_entry.destroy

	respond_to do |format|
	  format.html { redirect_to quote_tender_entries_url }
	  format.xml  { head :ok }
	end
end
#############################################################################################################################
def show_before
    if @purchase.quote_tender_entry
          @quote_tender_entry = @purchase.quote_tender_entry
          respond_to do |format|
            format.html # show.rhtml
            format.xml  { render :xml => @purchase.quote_tender_entry.to_xml }
            end
      else
        redirect_to :action => 'new'
      end
end














  
end
