module StorePurchase

#######################################   PROTECTED        ##################################################	
  protected	
###########################################################################################################	
def startup_purchase
		logger.debug "-------------------------------------begin lib/store_purchase/startup_purchase"
		if session[:purchase_id]
                      logger.debug "-------------------------------------session[:purchase_id] " + session[:purchase_id].to_s
                      @no_cache_controllers = ['quote_tender_entries','ship_tos','cart',"purchases"]
                      if  @no_cache_controllers.include? controller_name
                                                    CUSTOM_LOGGER.error("@purchase cache skipped due to @no_cache_controllers"  )
                      else
                                                     CUSTOM_LOGGER.error("@purchase cache found"  )
                  		                              @purchase = Caching::MemoryCache.instance.read request.session_options[:id] + '_purchase_' + session[:purchase_id].to_s  unless cache_on? == false
                      end
                      if !@purchase
                                 @purchase ||= Purchase.find(session[:purchase_id].to_s)
                                 Caching::MemoryCache.instance.write request.session_options[:id] + '_purchase_' + session[:purchase_id].to_s , @purchase if @purchase unless cache_on? == false
                                 logger.debug "-------------------------------------@purchase found by ActiveRecord" if @purchase
                      end
                    end
                           if @purchase
                                    logger.debug "-------------------------------------@purchase.id " + @purchase.id.to_s
                                    ShipTo.current_purchase_id = @purchase.id
                                    if  session[:affiliate_a_id]
                                                unless session[:a_id_already_set]
                                                @purchase.a_id = session[:affiliate_a_id]
                                                @purchase.save
                                                session[:a_id_already_set] = true
                                      end
                              end
                                 unless session[:user_session_purchase_id_set] == true
#                                        startup_user_session_deprecated
                                                       if logged_in?
                                                                    if @user
                                                                                ###########################################################################
                                                                                ###########################################################################
                                                                                ###########################################################################
                                                                                unless session[:recruiter_a_id_already_set]
                                                                                                logger.warn "session[:recruiter_a_id_already_set] NOT SET"
                                                                                                 if @user.recruiter
                                                                                                              logger.warn "@user.recruiter"
                                                                                                              @purchase.recruiter_a_id = @user.recruiter.id
                                                                                                              @purchase.save
                                                                                                              session[:recruiter_a_id_already_set] = true
                                                                                                  else
                                                                                                            logger.warn "NOT @user.recruiter"
                                                                                                  end
                                                                                      else
                                                                                              logger.warn "session[:recruiter_a_id_already_set]"
                                                                                      end
                                                                                      ###########################################################################
                                                                                      ###########################################################################
                                                                                      ###########################################################################
                                                                                        startup_user_session
                                                                                        @user_session.user_id =  current_user.id
                                                                                        @user_session.save
                                                                                        delete_user_session_cache
                                                                    end
                                                       end
                                                       startup_user_session
                                                      @user_session.purchase_id = @purchase.id
                                                     if @user_session.save
                                                      delete_user_session_cache
                                                      session[:user_session_purchase_id_set] = true
                                                   end
                                 end
    else
        logger.debug "-------------------------------------session[:purchase_id] NOT FOUND "
	  end

    find_ship_to
          
		logger.warn "######################################################"
		logger.warn "-------------------------------------@purchase:  " + @purchase.inspect
		logger.debug "-------------------------------------begin lib/store_purchase/startup_purchase"
end
############################################################################################################
def find_ship_to
  		logger.debug "-------------------------------------begin lib/store_purchase/find_ship_to"
      @ship_to_cache_string = request.session_options[:id] + '_ship_to_' + session[:purchase_id].to_s
      logger.debug "@ship_to_cache_string: " + @ship_to_cache_string
              @ship_to = Caching::MemoryCache.instance.read @ship_to_cache_string   unless cache_on? == false
            if @ship_to
                            logger.debug "@ship_to was found by cache"
            else
                                 logger.debug "@ship_to was not found by cache"
                                if @purchase
                                                if @purchase.ship_to
                                                             logger.debug " @purchase.ship_to"
                                                            @ship_to = @purchase.ship_to
                                                else
                                                           logger.debug "NOT @purchase.ship_to"
                                                          @ship_to = ShipTo.new
                                                end
                                else
                                               @ship_to = ShipTo.new
                                end
                                Caching::MemoryCache.instance.write @ship_to_cache_string  , @ship_to  unless cache_on? == false if @ship_to
            end
  		logger.debug "-------------------------------------end  lib/store_purchase/find_ship_to"
end
############################################################################################################
def start_purchase
						logger.warn('#### START PURCHASE #####################')
                      if  @purchase
                      else
                                  if @customer
                                         @purchase = Purchase.purchase_default(@customer.id, @website.id )
                                  else
                                         customer = 0
                                          @purchase = Purchase.purchase_default(customer, @website.id )
                                   end
                                   	logger.warn('####################################')
                                   if  session[:affiliate_a_id]
                                   		  if  session[:affiliate_a_id] != '0'
		                                   		@purchase.a_id =  session[:affiliate_a_id]
		                                   		@purchase.save
		                                   		logger.warn('####################################')
		                                   		logger.warn('PURCHASE STAMPED WITH A_ID')
		                                   		logger.warn('####################################')
                                   			else
                                   				logger.warn(' session[:affiliate_a_id] == 0')
                                   			end
                                   	else
                                   			logger.warn('no  session[:affiliate_a_id] ')
                                   	end	 
                        startup_user_session
                        @user_session.purchase_id = @purchase.id
                        @user_session.save
                        delete_user_session_cache
                        session[:purchase_id] = @purchase.id
                       end
                        logger.warn('######## END START PURCHASE ##################')     
end
###########################################################################################################
def prepare_purchase_variables
		@incomplete_symbiont = nil
		@incomplete_symbiont =  @purchase.incomplete_symbiont
end
############################################################################################################
def prepare_purchases_entry_variables
			@purchases_entries =  PurchasesEntry.find(:all,:conditions => ["purchase_id = ?", @purchase.id ])			
			@purchases_entry =  PurchasesEntry.find(:first,:conditions => ["purchase_id = ? and id = ?", @purchase.id , params[:purchases_entry_id] ]) if params[:purchases_entry_id]
			if @purchases_entries
				@purchases_entries_size = @purchases_entries.size 
			else
				@purchases_entries_size = 0
			end
end
############################################################################################################
def prepare_item_prices(item,quantity)
        @item_full_unit_price   =  item.full_unit_price(@customer)
        @item_unit_quantity_tier_discount_price  =  item.unit_quantity_tier_discount_price(@customer,@quantity)
        @item_unit_quantity_and_permanent_savings  =  item.unit_quantity_and_permanent_savings(@customer,@quantity)
        @item_your_unit_price  =  item.your_unit_price(@customer,@quantity)
end
############################################################################################################
def prepare_purchases_entry_totals(purchases_entry)
          @purchases_entry_full_extended_price  =  purchases_entry.full_extended_price(@customer,@item)
          @purchases_entry_symbiont_full_extended_price  =  purchases_entry.symbiont_full_extended_price
          @purchases_entry_your_extended_price  =   purchases_entry.your_extended_price(@customer,@quantity,@item) 
          @purchases_entry_your_extended_price_savings  =  purchases_entry.your_extended_price_savings(@customer,@quantity,@item) 
end
############################################################################################################
def prepare_purchase_totals(purchase)
        @purchase_cart_count   =  purchase.cart_count 
        @purchase_full_price_total  =  purchase.full_price_total(@customer_array)
        @discount_name = purchase.discount_name
        @discountable_items_total = purchase.subtotal_volume_and_permanent_discountable_only_items
        @purchase_discount_savings  = purchase.discount_savings
        @qualifies_for_discount = true if @purchase_discount_savings > 0
    	  @purchase_total_savings  =  purchase.total_savings
        @purchase_total_weight = purchase.total_weight
        @discount_percentage = purchase.discount_percentage
        @purchase_subtotal  =  purchase.subtotal
        @purchase_volume_discount_savings   =  purchase.volume_discount_savings
        @purchase_total_after_volume_discount  =  purchase.total_after_volume_discount
        @purchase_online_discount_savings  =  purchase.online_discount_savings
        @purchase_subtotal_after_all_discounts  =  purchase.subtotal_after_all_discounts
        @purchase_total_after_tax  =  purchase.total_after_tax
        @purchase_shipping   =  purchase.ups_shipping_price
        logger.info "------------------------------------- @purchase_shipping: #{ @purchase_shipping }"
        logger.info "------------------------------------- purchase.final_total_after_shipping: #{purchase.final_total_after_shipping}"

	if @purchase.ups_shipping_price  == 'shipping service unavailable'
		@purchase_final_total_after_shipping = 'shipping service unavailable'
	 else
        if @purchase.quote_tender_entry 
        	@purchase_cod_charge = 8.5 if [12,14].include?(@purchase.quote_tender_entry.tender.id)
        end
        if @purchase_cod_charge
        	@purchase_final_total_after_shipping  =  purchase.final_total_after_shipping + 8.5
        else
        	@purchase_final_total_after_shipping  =  purchase.final_total_after_shipping
        end
    end
end
############################################################################################################
def create_free_catalog_quote_tender_entry
    if @purchase         
            	 @quote_tender_entry = QuoteTenderEntry.find_or_create_by_purchase_id(@purchase.id)
	             @quote_tender_entry.CreditCardNumber = '00000000000'
	             @quote_tender_entry.CreditCardApprovalCode = '0000'
	             @quote_tender_entry.CreditCardExpiration = '0000'
	             @quote_tender_entry.tender_id = '10'
	             @quote_tender_entry.Amount = '0'
	             @quote_tender_entry.purchase_id = @purchase.id
	             @purchase.Comment = 'free_catalog'
	             if @quote_tender_entry.save && @purchase.save
                       delete_purchase_cache
                       redirect_to(:controller => 'cart', :action => 'next_checkout_step')
        	 	 else
                      flash[:notice] = "Error 0000 - please try again or call customer service"
                      redirect_to :back
            end
     end        
end
############################################################################################################
def delete_free_catalog_shipping_service_and_quote_tender_entry       
            	 @purchase.shipping_service_id = 0
            	 @purchase.quote_tender_entry.destroy   if @purchase.quote_tender_entry
            	 logger.debug "--------------------------about to @purchase.save! " 
            	 if @purchase.save! 
                    delete_purchase_cache
                    logger.debug "--------------------------@purchase.quote_tender_entry.destroyed "
                    logger.debug "-------------------------@purchase.shipping_service_id: #{@purchase.shipping_service_id} "
                    redirect_to(:controller => 'cart' , :action => 'next_checkout_step')
        	 	end  
end
############################################################################################################
def create_free_catalog_shipping_service       
            	 @purchase.shipping_service_id = 25
            	 logger.debug "--------------------------about to @purchase.save! " 
            	 if @purchase.save! 
            	 	delete_purchase_cache
            	 	logger.debug "-------------------------@purchase.shipping_service_id: #{@purchase.shipping_service_id} " 
            	    redirect_to(:controller => 'cart' , :action => 'next_checkout_step')
        	 	end  
end
############################################################################################################
def confirm_free_catalog_only
        if @purchase.free_catalog_purchase == false
                if @purchase.shipping_service_id == 12
                        flash[:notice] = "You have added items to your cart that are not included in free shipping, please select a shipping service."
                        redirect_to(:controller => 'ship_tos', :action => 'shipping_services')
                elsif @purchase.quote_tender_entry.tender_id == 10
                        flash[:notice] = "You have added items to your cart that are not free, please select a payment method."
                        redirect_to(:controller => 'quote_tender_entries', :action => 'index')
                end
        end
end
############################################################################################################


end
