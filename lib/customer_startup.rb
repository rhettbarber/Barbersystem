module CustomerStartup
  protected	
############################################################################################################	
def startup_customer
		logger.warn "BEGIN ------------------------------lib/customer_startup/startup_customer"
    find_customer
    if @customer
                    unless cache_on? == false
                              @customer_array_viewable_page_types = Caching::MemoryCache.instance.read  request.session_options[:id] + '_customer_array_viewable_page_types'
                     end
                      if !@customer_array_viewable_page_types
                              @customer_array_viewable_page_types = @customer.customer_viewable_page_types
                                        Caching::MemoryCache.instance.write  request.session_options[:id] + '_customer_array_viewable_page_types', @customer_array_viewable_page_types unless cache_on? == false
                      end
              # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        @customer_array_customer_type = Caching::MemoryCache.instance.read  request.session_options[:id] + '_customer_array_customer_type' unless cache_on? == false
                        if !@customer_array_customer_type
                                        @customer_array_customer_type = @customer.customer_type
                                        Caching::MemoryCache.instance.write  request.session_options[:id] + '_customer_array_customer_type', @customer_array_customer_type unless cache_on? == false
                        end
                        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        @licensed_for ||= @customer.licensed_for
                        @customer_price_level ||= @customer.PriceLevel
                        @customer_current_discount ||= @customer.CurrentDiscount
                        @customer_type = Caching::MemoryCache.instance.read  request.session_options[:id] + '_customer_type_id'
                        if !@customer_type
                                        @customer_type = @customer.customer_type_record.id
                                      Caching::MemoryCache.instance.write  request.session_options[:id] + '_customer_type_id', @customer_type unless cache_on? == false
                        end
                        if @customer.PriceLevel == 2 or @customer.PriceLevel == 3
                                  logger.warn "@customer.PriceLevel == 2 or @customer.PriceLevel == 3"
                                  @singular_item_customer = true
                        else
                                  logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
                                  @singular_item_customer = false
                        end
                        @customer_array = @customer
		else
                    logger.warn "still not @customer"
                    if @website.name == "barber_store"
                                  @customer_array_viewable_page_types = [1,8]
                                  @customer_array_customer_type =  'Blank-Transfer'
                                  @singular_item_customer = true
                                  @licensed_for ||=    'No License'
                                  @customer_price_level ||=  2
                                  @customer_current_discount ||= 0
                                  @customer_array = []
                                  @customer_array = Customer.new
                                  @customer_array.CustomText4 = 0
                                  @customer_array.CurrentDiscount = 0
                                  @customer_array.PriceLevel = 2
                                  @customer_type = 3
                    else
                                logger.warn "@singular_item_customer = false because not @customer or barber_store"
                                @customer_array_viewable_page_types = [1,8]
                                @customer_array_customer_type = 'Retail'
                                @singular_item_customer = false
                                @licensed_for ||=    'No License'
                                @customer_price_level ||=  0
                                @customer_current_discount ||= 0
                                @customer_array = []
                                @customer_array = Customer.new
                                @customer_array.CustomText4 = 0
                                @customer_array.CurrentDiscount = 0
                                @customer_array.PriceLevel = 0
                                @customer_type = 0
                      end

    end

          Purchase.customer = @customer_array

            logger.debug "@customer_array.inspect: " + @customer_array.inspect
            logger.warn "END --------------------------------lib/customer_startup/startup_customer"
end
# ############################################################################################################
def startup_customer_before
		logger.warn "BEGIN ------------------------------lib/customer_startup/startup_customer"
    find_customer
    if @customer
                    @customer_array ||= @customer
                     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                    unless cache_on? == false
                              @customer_array_viewable_page_types = Caching::MemoryCache.instance.read  request.session_options[:id] + '_customer_array_viewable_page_types'
                     end
                      if !@customer_array_viewable_page_types
                              @customer_array_viewable_page_types = @customer.customer_viewable_page_types
                                        Caching::MemoryCache.instance.write  request.session_options[:id] + '_customer_array_viewable_page_types', @customer_array_viewable_page_types unless cache_on? == false
                      end
              # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        @customer_array_customer_type = Caching::MemoryCache.instance.read  request.session_options[:id] + '_customer_array_customer_type' unless cache_on? == false
                        if !@customer_array_customer_type
                                        @customer_array_customer_type = @customer.customer_type
                                        Caching::MemoryCache.instance.write  request.session_options[:id] + '_customer_array_customer_type', @customer_array_customer_type unless cache_on? == false
                        end
                        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        @licensed_for ||= @customer.licensed_for
                        @customer_price_level ||= @customer.PriceLevel
                        @customer_current_discount ||= @customer.CurrentDiscount
                        @customer_type = Caching::MemoryCache.instance.read  request.session_options[:id] + '_customer_type_id'
                        if !@customer_type
                                        @customer_type = @customer.customer_type_record.id
                                      Caching::MemoryCache.instance.write  request.session_options[:id] + '_customer_type_id', @customer_type unless cache_on? == false
                        end
                        if @customer.PriceLevel == 2 or @customer.PriceLevel == 3
                                  logger.warn "@customer.PriceLevel == 2 or @customer.PriceLevel == 3"
                                  @singular_item_customer = true
                        else
                                  logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
                                  @singular_item_customer = false
                        end
		else
                    logger.warn "still not @customer"
                    logger.warn "@singular_item_customer = false because not @customer"
                    @customer_array_viewable_page_types = [1,8]
                    @customer_array_customer_type = 'Retail'
                    @singular_item_customer = false
                    unless @customer_array
                          @customer_array = []
                          @customer_array = Customer.new
                          @customer_array.CustomText4 = 0
                          @customer_array.PriceLevel = 0
                          @customer_type = 0
                     end
      end
            logger.warn "END --------------------------------lib/customer_startup/startup_customer"
end
############################################################################################################
def find_customer   
	logger.warn "BEGIN ------------------------------lib/customer_startup/find_customer"

  no_cache_controllers = ['customers']

     if session[:customer_id]
                    logger.warn " session customer_id exists"
                 if  no_cache_controllers.include? controller_name
                                   logger.warn "excluded this controller from caching customer"
                 else
                                  logger.warn "attempting to read customer cacher"
                                  @customer = Caching::MemoryCache.instance.read  request.session_options[:id].to_s +  '_customer_' + session[:customer_id].to_s   unless cache_on? == false
                 end
                    if @customer
                                  logger.warn "@customer found via cache"
                    else
                                       logger.warn "@customer was not found with cache --attempting to find via activerecord- "
                                     @customer = Customer.find session[:customer_id]   if session[:customer_id]
                                       logger.warn "@customer found via activerecord- " if @customer
                   end

   end
  s = "S"
  if @user and !@customer
              logger.warn "@user and !customer"
              logger.warn "@user and !customer"
              logger.warn "@user and !customer"
              logger.warn "@user and !customer"
              logger.warn "@user and !customer"
              if @user.customer
                                logger.warn "@user.customer"
                                logger.warn "@user.customer"
                                logger.warn "@user.customer"
                                logger.warn "@user.customer"
                                logger.warn "@user.customer"
                                logger.warn "@user.customer"
                                logger.warn "@user.customer"
                               @customer ||= @user.customer
                               session[:customer_id] = @customer.id.to_s
                               #Caching::MemoryCache.instance.write  request.session_options[:id] + '_customer_' + session[:customer_id] , @customer unless cache_on? == false
              else
                                logger.warn "NOT @user.customer"
                                logger.warn "NOT @user.customer"
                                logger.warn "NOT @user.customer"
                                logger.warn "NOT @user.customer"
                                logger.warn "NOT @user.customer"
               end
  elsif @user and @customer
                   logger.warn "@user and @customer"
                   logger.warn "@user and @customer"
                   logger.warn "@user and @customer"
                   logger.warn "@user and @customer"
                   logger.warn "@user and @customer"
  else
                  logger.warn "!@user and !customer"
                  logger.warn "!@user and !customer"
                  logger.warn "!@user and !customer"
                  logger.warn "!@user and !customer"
                  logger.warn "!@user and !customer"
   end
  
	logger.warn "END --------------------------------lib/customer_startup/find_customer"
end	
############################################################################################################ 
 
end
