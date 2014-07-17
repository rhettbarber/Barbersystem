class BrowseController < ApplicationController
  #layout 'none'

  before_filter :initialize_variables
  caches_action :index , :cache_path => Proc.new{ @browse_action_cache_name }
  caches_page :new_designs





def index
          if !@department && !@category
                  browse_not_department_not_category
          elsif  @department && !@category && @incomplete_symbiont == false
                  browse_department_not_category_not_incomplete_symbiont
          # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          elsif  @department && !@category && @incomplete_symbiont == true
                  browse_department_not_category_incomplete_symbiont
          # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          elsif  @department && @category && @incomplete_symbiont == false
                  if @category.has_additives == true  && @show_items == false
                      browse_department_category_not_incomplete_symbiont_category_has_additives
                  else
                      browse_department_category_not_incomplete_symbiont_category_show_items
                  end
          # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          elsif  @department && @category && @incomplete_symbiont == true
                  browse_department_category_incomplete_symbiont
          # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          else
                  logger.debug "BROWSE 6-------------------------------------final else"
                  flash[:notice] = "browse error 701"
                  #redirect_to(:controller => 'browse', :action => 'index')
          end
					logger.debug "-------------------------------------END BROWSE ACTION"
end
############################################################################################################
def browse_not_department_not_category
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug "SUB-ACTION:browse_not_department_not_category-------------------------------------"
end
############################################################################################################
def browse_department_not_category_not_incomplete_symbiont
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug "SUB-ACTION:browse_department_not_category_not_incomplete_symbiont-------------------------------------"
					logger.debug "BROWSE 2-------------------------------------@department && !@category && @incomplete_symbiont == false"
end
############################################################################################################
def browse_department_not_category_incomplete_symbiont
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug "SUB-ACTION:browse_department_not_category_incomplete_symbiont-------------------------------------"
end
############################################################################################################
def browse_department_category_not_incomplete_symbiont_category_has_additives
  bug_browse_department_category_not_incomplete_symbiont_category_has_additives
          @special_rendering = 'browse/browse_department_category_not_incomplete_symbiont_category_has_additives'
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug "SUB-ACTION:browse_department_category_not_incomplete_symbiont_category_has_additives-------------------------------------"
					logger.debug "BROWSE 4a-------------------------------------@category.has_additives == true && @show_items == false"
					### SHOW ITEMS MUST BE ON TO SHOW ITEMS, @show_items will equal true if no params[:si] by default. this will go in the startup_browsing
								logger.debug "browse_department_category_not_incomplete_symbiont_category_has_additives"
								@categories = @category.self_and_non_generic_additives
								render(:partial => "shared_item/categories_and_additives" )
end
############################################################################################################
def browse_department_category_not_incomplete_symbiont_category_show_items
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
					logger.debug "SUB-ACTION:browse_department_category_not_incomplete_symbiont_category_show_items-------------------------------------"
					logger.debug "BROWSE 4b-------------------------------------@category.has_additives != true OR @show_items == true"
          logger.debug "@fragment_name: #{@fragment_name}"
          logger.debug "@category.inspect: " + @category.inspect
					if  @category.category_class.item_type == 'master'
                         logger.debug "Fbrowse_department_category_not_incomplete_symbiont_category_show_items @category.category_class.item_type == 'master'"
                         logger.debug "zzesaiio"
                          @items = Caching::MemoryCache.instance.read  'browse_department_category_not_incomplete_symbiont_category_show_items_with_category_id_of_' + params[:category_id].to_s unless cache_on? == false
                          if !@items
                                   logger.debug "!@items"
                                   logger.debug "@category.inspect: " + @category.inspect
                                  @items  =  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(@category)
                                         Caching::MemoryCache.instance.write  'browse_department_category_not_incomplete_symbiont_category_show_items_with_category_id_of_' + params[:category_id].to_s ,  @items  unless cache_on? == false
                          end
					elsif  @category.category_class.item_type != 'slave'
                        logger.debug "@category.category_class.item_type != 'slave'"
                        logger.debug "RUNNING MODEL METHOD  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories_plus_non_symbiont_items(@category)"
                        logger.debug "@category.inspect: " + @category.inspect
                        @items  =  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories_plus_non_symbiont_items(@category)
                        logger.debug "@items.size in controller: " + @items.size.to_s
					else
                        logger.debug "browse_department_category_not_incomplete_symbiont_category_show_items final else"
    #										@items  =  Item.find(:all,:conditions => ["category_id = ? or category_id in (?) and Inactive != -1 ", @category , @category.additive_category_ids_split ] )   #Item.find_all_by_category_id(@category)  #,:order => "ItemLookupCode ASC"
                        @items = Item.includes(:item_class_component, :item_sales_last_year, :category, :item_sales_this_year, :item_class_sales_this_years_with_item_id).where( "category_id = ? or category_id in (?) and Inactive != -1 ", @category , @category.additive_category_ids_split )
					end
end
############################################################################################################
def browse_department_category_incomplete_symbiont
            logger.debug "BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  "
            logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
            logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
            logger.debug "SUB-ACTION:browse_department_category_incomplete_symbiont-------------------------------------"
            if @category.has_additives == true && @show_items == false
                          logger.debug "BROWSE 4-------------------------------------@category.has_additives == true && @show_items == true"
                            ### SHOW ITEMS MUST BE ON TO SHOW ITEMS, @show_items will equal true if no params[:si] by default. this will go in the startup_browsing
                                        logger.debug "1213 browse_department_category_incomplete_symbiont"
                                        @categories = @category.self_and_additives_in_opposite_ids(@purchase.opposite_category_ids)
                                        render(:partial => "shared_item/categories_and_additives", :layout => controller_name )
						else
                          logger.debug "BROWSE 5-------------------------------------@department && @category && @incomplete_symbiont == true"
                          if  @purchase_symbiote_item_type == 'slave'
                                                  logger.debug "4231 browse_department_category_incomplete_symbiont @purchase_symbiote_item_type == 'slave'"
                                                  logger.debug "2321 FRAGMENT READ FAILED browse_department_category_incomplete_symbiont @purchase_symbiote_item_type == 'slave'"



                                                  @items = Caching::MemoryCache.instance.read  'browse_department_category_incomplete_symbiont_category_id_' + params[:category_id].to_s unless cache_on? == false
                                                  if !@items
                                                      logger.debug "!@items"
                                                      #@items  =  @purchase.symbiote.item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(@category)
                                                      #@items  =  @purchase.symbiote.item.find_applicable_opposites_in_parameter_category_and_additive_categories(@category) ##this would be for master
                                                      @items  =  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(@category)
                                                      Caching::MemoryCache.instance.write  'browse_department_category_incomplete_symbiont_category_id__' + params[:category_id].to_s ,  @items  unless cache_on? == false
                                                   end



                          else
                                                  logger.debug "21313 browse_department_category_incomplete_symbiont else NOT @purchase_symbiote_item_type == 'slave'"
                                                  @items  =  @purchase.symbiote.item.find_applicable_opposite_items_in_parameter_category(@category)
                          end
							end
            logger.debug "END END  END  END  END  END  END  END  END  END  END  END  END  END  END  END  END  "
            logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
            logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
end
############################################################################################################
#def new_designs
#  @items = Caching::MemoryCache.instance.read @website.name + '_new_designs' unless cache_on? == false
#  @items ||= Item.find(:all,:conditions => ["department_id in (?)", @website.default_design_department_ids.split(/,/) ] , :limit => 50, :order => "DateCreated DESC")
#   unless @items
#        logger.warn "NO ITEMS FOUND ON NEW DESIGNS ACTION !!!!"
#    else
#        logger.warn "@items.size: #{@items.size}"
#        Caching::MemoryCache.instance.write @website.name + '_new_designs', @items, :expires_in => 227.minutes  unless cache_on? == false
#   end
##  	render(:partial => "shared_item/new_items", :layout => controller_name )
#end
#############################################################################################################
#def sale_designs
#	  #@items = Caching::MemoryCache.instance.read @website.name + '_sale_designs' unless cache_on? == false
#	  if @website.name == 'dixie_store' or @website.name == 'american_store'
#	  		@items ||= Item.find(:all,:conditions => ["department_id in (?) and SaleType != ?",  ['10','11','12','13','14','15','16','17','18','19','20','24','27']     ,  '0'    ] , :order => "DateCreated DESC")
#	  else
#	  		@items ||= Item.find(:all,:conditions => ["department_id in (?) and SaleType != ?", @website.default_design_department_ids.split(/,/) ,  '0'    ] , :order => "DateCreated DESC")
#	  end
#
#	   unless @items
#	        logger.warn "NO ITEMS FOUND ON NEW DESIGNS ACTION !!!!"
#	    else
#	        logger.warn "@items.size: #{@items.size}"
#	        Caching::MemoryCache.instance.write @website.name + '_sale_designs', @items, :expires_in => 227.minutes  unless cache_on? == false
#	   end
#	  	render(:partial => "shared_item/sale_designs", :layout => controller_name )
#end
#############################################################################################################
#def sale_items
#	    @items = Caching::MemoryCache.instance.read @website.name + '_sale_items' unless cache_on? == false
#	  	@items ||= Item.find(:all,:conditions => ["department_id in (?) and SaleType != ?", [ '2','3','4','6','7','8','9','21','22','26','28' ] ,  '0'    ] ,  :order => "DateCreated DESC")
#	  	#@items ||= Item.find(:all,:conditions => ["department_id in (?)", @website.default_item_department_ids.split(/,/)   ] , :limit => 50, :order => "DateCreated DESC")
#	   unless @items
#	        logger.warn "NO ITEMS FOUND ON NEW DESIGNS ACTION !!!!"
#	    else
#	        logger.warn "@items.size: #{@items.size}"
#	        Caching::MemoryCache.instance.write @website.name + '_sale_items', @items, :expires_in => 227.minutes  unless cache_on? == false
#	   end
#	  	render(:partial => "shared_item/sale_items", :layout => controller_name )
#end
############################################################################################################
def flash_and_completion_status_bar_message_for_browse_applicable_items
			if @purchase_symbiote_type == 'master'
					@completion_status_bar_message = 'Complete your chosen Item by choosing from your design category choices below.'

			else
					@completion_status_bar_message = 'Complete your chosen Design by adding an Item from your choices below.'
			end
		  if @purchase_symbiote_type == 'master'
		       flash[:notice] = "Complete opposites listing" if @items.nil?

		 	else
		        flash[:notice] = "Complete opposites listing" if @items.nil?
		  end
end
###########################################################################################################
#def browse_applicable_items
#			    load_local_browse_applicable_items_variables_for_browse_applicable_items
#      		@content_fragment_name = @website.name + "/user_type_id/" + @local_user_array_user_type_id + "/browse_applicable_items/purchase_symbiote_item_category_category_class_id/" + @local_purchase_symbiote_item_category_category_class_id + "/shade/" + @local_purchase_symbiote_item_shade
#		      if @incomplete_symbiont == true
#                            startup_website_all_items
#														startup_acceptable_item_ids_by_website
#														logger.warn "------------------------------------- @items_content_fragment FRAGMENT NOT READ"
#														logger.warn "----- WARN -------------------------- @items_content_fragment FRAGMENT NOT READ"
#														logger.warn "------------------------------------- @items_content_fragment FRAGMENT NOT READ"
#														logger.warn "--------------- WARN ---------------- @items_content_fragment FRAGMENT NOT READ"
#					                  @items =  @website_all_items
#
#						          	  flash_and_completion_status_bar_message_for_browse_applicable_items
##						          	  render(:partial => "shared_item/browse_applicable_items",:layout => @website.name )
#		        else
#		                flash[:notice] = "This action requires you have an incomplete symbiote in progress"
#		                #redirect_to :controller =>  'browse'
#		        end
#end
###########################################################################################################



end
