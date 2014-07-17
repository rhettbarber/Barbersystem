module StoreItemSymbiontInitializer


############################################################################################################
def master_acceptable_item_ids #produces the designs that will go with selected item
		logger.info "------------------------------------master_acceptable_item_ids BEGIN "
		if @purchase.symbiote.item
					if @purchase.symbiote.item.shade == 'colored'
							logger.info "- DEBUG 1 ------------------------------------ @purchase.symbiote.item.shade = 'colored'"
							@acceptable_item_ids  = @purchase.opaque_opposite_item_ids #.to_set.intersection(@website_all_item_ids.to_set)
					else
		       		logger.info "- DEBUG 2 ------------------------------------ @purchase.symbiote.item.shade != 'colored'"
							@acceptable_item_ids  = @purchase.all_opposite_item_ids #.to_set.intersection(@website_all_item_ids.to_set)
		   		end
		   		if @acceptable_item_ids
		   				logger.info "------------------------------------@acceptable_item_ids: #{@acceptable_item_ids.size} "
		   				logger.info "------------------------------------@acceptable_item_ids: #{@acceptable_item_ids.size} "
		   		else
		   				logger.info "------------------------------------ NO @acceptable_item_ids FOUND"
		   				logger.info "------------------------------------ NO @acceptable_item_ids FOUND"
		   		end
	    end
	    logger.info "------------------------------------master_acceptable_item_ids END "
end
############################################################################################################
def slave_acceptable_item_ids #produces the items that will go with selected design

			logger.info "------------------------------------slave_acceptable_item_ids BEGIN "
     if @purchase.symbiote.item.SubDescription2.downcase == 'opaque'
     		logger.warn "- DEBUG 3 ------- @purchase.symbiote_type != 'master'----@purchase.symbiote.item.SubDescription2.downcase == 'opaque'"
				@acceptable_item_ids  = @purchase.all_opposite_item_ids.to_set.intersection(Item.first_of_components_item_ids.to_set).intersection(@website_all_item_ids.to_set)
			else
					logger.warn "- DEBUG 4 ------- @purchase.symbiote_type != 'master'----@purchase.symbiote.item.SubDescription2.downcase != 'opaque'"
			 	 	#@acceptable_item_ids  = @purchase.all_opposite_item_ids.to_set.intersection(Item.first_of_light_components_item_ids.to_set).intersection(@website_all_item_ids.to_set)
					@light_items_set = Item.first_of_light_components_item_ids.to_set
          v = "v"
					@acceptable_item_ids  = @purchase.opposite_result_item_ids_only(@light_items_set).intersection(@website_all_item_ids.to_set).intersection(@light_items_set)
   		end
   		logger.info "------------------------------------slave_acceptable_item_ids END "
end
############################################################################################################
def no_symbiote_acceptable_item_ids
		logger.info "------------------------------------no_symbiote_acceptable_item_ids BEGIN "
		logger.info "------------------------------------- not @incomplete_symbiont, finding all acceptable item ids for this website"
		@opposites_cache_expiry_time = 227.minutes
		@non_website_specific_acceptable_item_ids = []
		@non_website_specific_acceptable_item_ids =   Item.non_component_item_ids  + Item.first_of_components_item_ids
		@acceptable_item_ids = @non_website_specific_acceptable_item_ids.to_set.intersection(@website_all_item_ids.to_set)
		Caching::MemoryCache.instance.write @website.name + '_acceptable_item_ids_symbiote_class_id_0', @acceptable_item_ids ,:expires_in => @opposites_cache_expiry_time   unless cache_on? == false
		logger.info "------------------------------------no_symbiote_acceptable_item_ids END "
end
############################################################################################################
def startup_acceptable_item_ids_by_website
	@opposites_cache_expiry_time = 227.minutes
	logger.info "------------------------------------- BEGIN startup_acceptable_item_ids_by_website"
	unless params[:search_type_name] == 'articles'
		if @incomplete_symbiont
			@acceptable_item_ids = Caching::MemoryCache.instance.read @website.name + '_acceptable_item_ids_symbiote_class_id_' + @purchase_symbiote_item_category_category_class_id ,:expires_in => @opposites_cache_expiry_time    unless cache_on? == false
		else
			@acceptable_item_ids = Caching::MemoryCache.instance.read @website.name + '_acceptable_item_ids_symbiote_class_id_0' ,:expires_in => @opposites_cache_expiry_time   unless cache_on? == false
		end

		@find_acceptable_item_ids = false
		if @acceptable_item_ids
				if @acceptable_item_ids.class == Set
							@find_acceptable_item_ids = true if @acceptable_item_ids.empty?
				else
					@find_acceptable_item_ids = true if @acceptable_item_ids.size == 0
				end
		else
				@find_acceptable_item_ids = true
		end
		logger.info "---------------------------------------------@find_acceptable_item_ids: #{@find_acceptable_item_ids }"

		if @find_acceptable_item_ids == true
			logger.info "- DEBUG 111 --------------------------------------------@acceptable_item_ids NOT FROM CACHE"
				if @incomplete_symbiont
			            if @purchase.symbiote_type == 'master'
												master_acceptable_item_ids
			             else
		                    slave_acceptable_item_ids
			             end
				          Caching::MemoryCache.instance.write @website.name + '_acceptable_item_ids_symbiote_class_id_' + @purchase_symbiote_item_category_category_class_id, @acceptable_item_ids ,:expires_in => @opposites_cache_expiry_time  unless cache_on? == false
				else
					no_symbiote_acceptable_item_ids
				end
		else
				logger.info "- DEBUG 1231 --------------------------------------------@acceptable_item_ids.size READ FROM CACHE"
				logger.info "- DEBUG 1231 --------------------------------------------@acceptable_item_ids.size FROM CACHE: #{@acceptable_item_ids.size}"
				logger.info "- DEBUG 1232 --------------------------------------------@acceptable_item_ids: #{@acceptable_item_ids}"
				logger.info "- DEBUG 1232 --------------------------------------------@acceptable_item_ids.inspect: #{@acceptable_item_ids.inspect}"
		end
	end
end
############################################################################################################
def startup_symbiont
	logger.warn "-------------------------------------begin startup_symbiont"
  logger.warn " session[:reset_symbiont_status]: " +  session[:reset_symbiont_status].to_s
  #session[:reset_symbiont_status] = true
  # if session[:reset_symbiont_status]  or  session[:incomplete_symbiont].nil?
                logger.warn "session[:reset_symbiont_status]  or  session[:incomplete_symbiont].nil?"
                if @purchase
                          logger.warn "@purchase"
                          @incomplete_symbiont = @purchase.incomplete_symbiont
                          if @incomplete_symbiont
                                      logger.warn "@incomplete_symbiont"

                                      session[:incomplete_symbiont] = true



                                      @purchase_symbiote_purchases_entry_id  ||= @purchase.symbiote.id
                                      session[:purchase_symbiote_purchases_entry_id] =  @purchase_symbiote_purchases_entry_id
                                      logger.warn "set session[:purchase_symbiote_purchases_entry_id] = @purchase_symbiote_purchases_entry_id: " + @purchase_symbiote_purchases_entry_id.inspect


                                      @purchase_symbiote_item ||= @purchase.symbiote.item
                                      session[:purchase_symbiote_item] =  @purchase_symbiote_item
                                      logger.warn "set session[:purchase_symbiote_item] = @purchase_symbiote_item: " + @purchase_symbiote_item.inspect

                                      @purchase_symbiote_item_id ||= @purchase.symbiote.item.id.to_s
                                      session[:purchase_symbiote_item_id] =  @purchase_symbiote_item_id

                                      @purchase_symbiote_item_category_id ||= @purchase_symbiote_item.category_id
                                      session[:purchase_symbiote_item_category_id] =  @purchase_symbiote_item_category_id

                                      @purchase_symbiote_item_category_category_class ||= @purchase_symbiote_item.category.category_class
                                      session[:purchase_symbiote_item_category_category_class] =  @purchase_symbiote_item_category_category_class

                                      @purchase_symbiote_item_category_category_class_id ||= @purchase_symbiote_item.category.category_class.id.to_s
                                      logger.warn "set session[:purchase_symbiote_item_category_category_class_id] = @purchase_symbiote_item_category_category_class_id: " + @purchase_symbiote_item_category_category_class_id
                                      session[:purchase_symbiote_item_category_category_class_id] = @purchase_symbiote_item_category_category_class_id

                                      @purchase_symbiote_item_type ||= @purchase.symbiote_type
                                      session[:purchase_symbiote_item_type] =  @purchase_symbiote_item_type

                                      @purchase_symbiote_item_shade ||= @purchase_symbiote_item.shade
                                      session[:purchase_symbiote_item_shade] =  @purchase_symbiote_item_shade

                                      #
                                      #var cookie_content = {
                                      #    "ItemLookupCode":"11001LA",
                                      #    "Description":"Short Sleeve T",
                                      #    "Dimensions":"Large White",
                                      #    "image_url":"/images/item_thumbnails/11001_lmrp_ash.png",
                                      #    "potential_department_ids" :  "10,11"  ,
                                      #    "opposite_category_ids":  "631,633",
                                      #    "other3":"other3value"
                                      #};

                                      #Example cookie
                                      #cookies[:barber_stuff] = { :value => "{\"ItemLookupCode\":\"11001LA\",\"Description\":\"Short Sleeve T\",\"Dimensions\":\"Large White\",\"image_url\":\"/images/item_thumbnails/11001_lmrp_ash.png\",\"potential_department_ids\":\"10,11\",\"opposite_category_ids\":\"631,633\",\"other3\":\"other3value\"}", :expires => 5.hours.from_now }

                                      #cookies[:barber_preferences] = { :value => "{\"ItemLookupCode\":\"#{@purchase_symbiote_item.ItemLookupCode}\",\"Description\":\"#{@purchase_symbiote_item.description_before_color_and_size}\",\"Dimensions\":\"#{@purchase_symbiote_item.dimensions}\",\"image_url\":\"/images/item_thumbnails/#{@purchase_symbiote_item.PictureName}.png\",\"potential_opposite_department_ids\":\"#{@purchase_symbiote_item.category.potential_opposite_department_ids.to_a.join(',') }\",\"opposite_category_ids\":\"#{@purchase_symbiote_item.category.category_class.opposite_category_ids  }\",\"other3\":\"other3value\"}", :expires => 5.hours.from_now }
                                      #
                                      #@purchase_symbiote_item.image_url(   @purchase_symbiote_item.department ,'item_thumbnails/','x' )

                                      #add_cookie_fix_from_store_controller

                                      #cookies[:barber_stuff] = { :ItemLookupCode => "11001la", :expires => 5.hours.from_now }
                                     if @purchase.symbiote.master_department_id == 0
                                               @purchase_symbiote_item_image =  "/images/item_specsheets/" + @purchase_symbiote_item.PictureName.gsub(".png", "").gsub(".jpg", "") + ".jpg"
                                     else
                                              @purchase_symbiote_item_image =   @purchase_symbiote_item.image_url( @purchase.symbiote.master_department_id  ,'item_thumbnails/','x').gsub(".png", "").gsub(".jpg", "") + ".jpg"
                                     end
                                      if @incomplete_symbiont
                                                        if @purchase_symbiote_item_type == "slave"
                                                                        logger.warn "writing cookie @incomplete_symbiont and @purchase_symbiote_item_type == slave"
                                                                        cookies[:barber_preferences] = { :value => "{\"ItemLookupCode\":\"#{@purchase_symbiote_item.ItemLookupCode}\",\"Description\":\"#{@purchase_symbiote_item.description_before_color_and_size}\",\"Dimensions\":\"#{@purchase_symbiote_item.dimensions}\",\"image_url\":\"#{@purchase_symbiote_item_image}\",\"potential_opposite_department_ids\":\"#{@purchase_symbiote_item.category.potential_opposite_department_ids.to_a.join(",")}\",\"opposite_category_ids\":\"#{@purchase_symbiote_item.category.category_class.opposite_category_ids}\",\"item_id\":\"#{@purchase_symbiote_item.id}\",\"item_type\":\"#{@purchase_symbiote_item_type}\",\"purchase_symbiote_purchases_entry_id\":\"#{@purchase_symbiote_purchases_entry_id}\"}", :expires => 5.hours.from_now }
                                                        else
                                                                         logger.warn "writing cookie @incomplete_symbiont and @purchase_symbiote_item_type not equal slave"
                                                                        cookies[:barber_preferences] = { :value => "{\"ItemLookupCode\":\"#{@purchase_symbiote_item.ItemLookupCode}\",\"Description\":\"#{@purchase_symbiote_item.description_before_color_and_size}\",\"Dimensions\":\"#{@purchase_symbiote_item.dimensions}\",\"image_url\":\"#{@purchase_symbiote_item_image}\",\"potential_opposite_department_ids\":\"#{@purchase_symbiote_item.category.potential_opposite_department_ids.to_a.join(",")}\",\"opposite_category_ids\":\"#{@purchase_symbiote_item.category.category_class.opposite_category_ids}\",\"item_id\":\"#{@purchase_symbiote_item.id}\",\"item_type\":\"#{@purchase_symbiote_item_type}\",\"purchase_symbiote_purchases_entry_id\":\"#{@purchase_symbiote_purchases_entry_id}\"}", :expires => 5.hours.from_now }
                                                         end
                                        end

                          else
                                        logger.warn "writing cookie not @incomplete_symbiont with ItemLookupCode 0"
                                        cookies[:barber_preferences] = { :value => "{\"ItemLookupCode\":\"0\"}" }

                                        logger.warn "NOT @incomplete_symbiont"
                                        set_symbiont_variables_to_zero
                          end
                else
                      logger.warn "!@purchase so writing cookie with ItemLookupCode 0"
                      cookies[:barber_preferences] = { :value => "{\"ItemLookupCode\":\"0\"}" }
                      logger.warn "!@purchase"
                      set_symbiont_variables_to_zero
                end
   #else
   #        logger.debug "!@purchase but found session info - initialize variables using session"
   #end
  @incomplete_symbiont = session[:incomplete_symbiont]
  @purchase_symbiote_item  = session[:purchase_symbiote_item]
  @purchase_symbiote_item_id  = session[:purchase_symbiote_item_id]
  @purchase_symbiote_item_category_category_class = session[:purchase_symbiote_item_category_category_class]
  @purchase_symbiote_item_category_category_class_id = session[:purchase_symbiote_item_category_category_class_id]
  @purchase_symbiote_item_type  = session[:purchase_symbiote_item_type]
  @purchase_symbiote_item_shade = session[:purchase_symbiote_item_shade]
  session[:reset_symbiont_status] = false
  if @incomplete_symbiont.nil?
    should_always_return_at_incomplete_symbiont
  end
  logger.warn  "@incomplete_symbiont:" + @incomplete_symbiont.to_s
  logger.warn "-------------------------------------end startup_symbiont"
end


def set_symbiont_variables_to_zero
              session[:incomplete_symbiont] = false
              session[:purchase_symbiote_purchases_entry_id] =  "0"
              session[:purchase_symbiote_item] =  "0"
              session[:purchase_symbiote_item_id] =  "0"
              session[:purchase_symbiote_item_category_id] =  "0"
              session[:purchase_symbiote_item_category_category_class] =  "0"
              session[:purchase_symbiote_item_category_category_class_id] = "0"
              session[:purchase_symbiote_item_type] =  "0"
              session[:purchase_symbiote_item_shade] =  "0"
end





def startup_symbiont_details_deprecate
          logger.debug "BEGIN startup_symbiont_details"
	        logger.debug "-------------------------------------price_level_block NOT IN EFFECT"
		    if  @incomplete_symbiont
                  @purchase_symbiote_item ||= @purchase.symbiote.item
                  session[:purchase_symbiote_item] =  @purchase_symbiote_item

                  @purchase_symbiote_item_id ||= @purchase.symbiote.item.id.to_s
                  session[:purchase_symbiote_item_id] =  @purchase_symbiote_item_id

                  @purchase_symbiote_item_category_id ||= @purchase_symbiote_item.category_id.to_s
                  session[:purchase_symbiote_item_category_id] =  @purchase_symbiote_item_category_id

                  @purchase_symbiote_item_category_category_class ||= @purchase_symbiote_item.category.category_class
                  session[:purchase_symbiote_item_category_category_class] =  @purchase_symbiote_item_category_category_class

                  @purchase_symbiote_item_category_category_class_id ||= @purchase_symbiote_item.category.category_class.id.to_s
                  logger.debug "set session[:purchase_symbiote_item_category_category_class_id] = @purchase_symbiote_item_category_category_class_id: " + @purchase_symbiote_item_category_category_class_id
                  session[:purchase_symbiote_item_category_category_class_id] = @purchase_symbiote_item_category_category_class_id

                  @purchase_symbiote_item_type ||= @purchase.symbiote_type
                  session[:purchase_symbiote_item_type] =  @purchase_symbiote_item_type

                  @purchase_symbiote_item_shade ||= @purchase_symbiote_item.shade
                  session[:purchase_symbiote_item_shade] =  @purchase_symbiote_item_shade
        else
                  session[:purchase_symbiote_item] =  "0"
                  session[:purchase_symbiote_item_id] =  "0"
                  session[:purchase_symbiote_item_category_category_class] =  "0"
                  session[:purchase_symbiote_item_category_category_class_id] = "0"
                  session[:purchase_symbiote_item_type] =  "0"
                  session[:purchase_symbiote_item_shade] =  "0"
        end
		    @purchase_symbiote_item_id ||= '0'
		    @purchase_symbiote_item_category_category_class_id ||= '0'
			@purchase_symbiote_item_shade ||= '0'
		     logger.debug "-------------------------------------end @purchase.symbiote.item"
#	else
#		logger.debug "-------------------------------------price_level_block IN EFFECT"
#		logger.debug "-------------------------------------@block_specifier_filters == true or price_level_block == true on startup_symbiont"
#		logger.debug "-------------------------------------price_level_block: #{price_level_block}"
#		logger.debug "-------------------------------------@user.email: #{@user.email}" if @user
#		logger.debug "-------------------------------------@customer.PriceLevel: #{@customer.PriceLevel}" if @customer
#	end
	logger.debug "##################################################"
  logger.debug "@incomplete_symbiont: " + @incomplete_symbiont.to_s
  logger.debug "##################################################"
  logger.debug "-------------------------------------@purchase_symbiote_item_shade:#{@purchase_symbiote_item_shade}---"
	logger.debug "-------------------------------------end startup_symbiont_details"
end
###########################################################################################################





# def self.included(base)
#     base.before_filter :redirect_unless_admin
#   end



end
