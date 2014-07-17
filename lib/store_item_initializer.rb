module StoreItemInitializer
  protected	


############################################################################################################
def startup_specific_items
        current_website unless @website
				# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			  @all_websites_all_items = Caching::MemoryCache.instance.read 'all_websites_all_items'  unless cache_on? == false
				if @all_websites_all_items
						logger.info "-------------------------------------@all_websites_all_items found by cache"
				else
        		@all_websites_all_items = Item.includes('category','department','item_class_component')
        		logger.info "-------------------------------------@all_websites_all_items NOT found by cache"
        		Caching::MemoryCache.instance.write 'all_websites_all_items', @all_websites_all_items, :expires_in => 210.minutes  unless cache_on? == false
        end 
        @website_items = Caching::MemoryCache.instance.read @website.name + '_items'  unless cache_on? == false
				if @website_items
						logger.info "-------------------------------------@website_items found by cache"
				else
        		@website_items = Item.find(:all,:conditions => ["department_id in (?)", @website.default_item_department_ids.split(/,/) ] ,:include => ['category','department','item_class_component'])
        		logger.info "-------------------------------------@website_items NOT found by cache"
        		Caching::MemoryCache.instance.write @website.name + '_items', @website_items, :expires_in => 200.minutes  unless cache_on? == false
        end  
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        @website_designs = Caching::MemoryCache.instance.read @website.name + '_designs'  unless cache_on? == false
				if @website_designs
						logger.info "-------------------------------------@website_designs found by cache"
				else
        		@website_designs = Item.find(:all,:conditions => ["department_id in (?)", @website.default_design_department_ids.split(/,/) ],:include => ['category','department','item_class_component'])
        		logger.info "-------------------------------------@website_designs NOT found by cache"
        		Caching::MemoryCache.instance.write @website.name + '_designs', @website_designs, :expires_in => 227.minutes  unless cache_on? == false
        end       
end
############################################################################################################
def startup_website_all_items
  	logger.info "-------------------------------------BEGIN startuup_website_all_items"
       current_website unless @website
        @website_all_items = Caching::MemoryCache.instance.read @website.name + '_all_items'  unless cache_on? == false
				if @website_all_items
						logger.info "-------------------------------------@website_all_items found by cache"
        else
                    @website_all_items =  Item.includes( :category, :department , :aliasings , :item_class_component  , :item_class_sales_this_years_with_item_id ).order( 'item_class_sales_this_years_with_item_ids.sum_of_quantity DESC' ).where(["items.department_id in (?)", @website.default_all_department_ids_with_generic ]).all
                      #@website_all_items =  Item.find(:all,:conditions => ["items.department_id in (?)", @website.default_all_department_ids_with_generic ],:include => ['category','department','aliasings', 'item_class_component' , 'item_class_sales_this_years_with_item_id' ],:order => 'item_class_sales_this_years_with_item_ids.sum_of_quantity DESC' )
                      # LAST ONE    @website_all_items =  Item.find(:all,:conditions => ["department_id in (?)", @website.default_all_department_ids_with_generic ],:include => ['category','department','aliasings','item_class_component'])
                      #@website_all_items = Item.find(:all,:conditions => ["department_id in (?)", @website.default_all_department_ids_with_generic ],:include => ['category','department','item_class_component'])
                      #    @website_all_items = Item.find(:all,:conditions => ["items.department_id in (?)", @website.default_all_department_ids_with_generic ] ,:include => ['aliasing', 'category','department','item_class_component', 'item_class_sales_this_years_with_item_id' ]  ,:order => 'item_class_sales_this_years_with_item_ids.sum_of_quantity DESC' )  #,:include => ['category','department','item_class_component', 'item_class_sales_this_years_with_item_id' ]  ,:order => 'item_class_sales_this_years_with_item_ids.sum_of_quantity DESC' )
                      #    @website_all_items = Item.find(:all,:conditions => ["items.department_id in (?)", @website.default_all_department_ids_with_generic ]).include(:aliasings) # ,:include => ['category','department','item_class_component', 'item_class_sales_this_years_with_item_id' ]  ,:order => 'item_class_sales_this_years_with_item_ids.sum_of_quantity DESC' )
                      #          @website_all_items = Item.where( "department_id in (?)",  @website.default_all_department_ids_with_generic ).include( :category, :aliasings )
                       logger.info "-------------------------------------@website_all_items NOT found by cache"
                      Caching::MemoryCache.instance.write @website.name + '_all_items', @website_all_items  unless cache_on? == false
        end  
        @website_all_item_ids = Caching::MemoryCache.instance.read @website.name + '_all_item_ids'  unless cache_on? == false
        if !@website_all_item_ids
               logger.info "------------------------------------- @all_website_item_ids not found, finding by activerecord"
                @website_all_item_ids = []
                @website_all_items.each do |item|
                  @website_all_item_ids << item.id
                end
                Caching::MemoryCache.instance.write @website.name + '_all_item_ids', @website_all_item_ids  unless cache_on? == false
        end
        logger.info "------------------------------------- END startuup_website_all_items"
end
############################################################################################################
def startup_browsing_departments
				logger.debug "BEGIN -----------------------------lib/store_item_initializer/startup_browsing_departments"
          @item_departments = Caching::MemoryCache.instance.read @website.name + '_default_item_departments' unless cache_on? == false
          unless @item_departments
                    @item_departments = @website.default_item_departments #this has already been cached in lib\startup_browsing
                    Caching::MemoryCache.instance.write @website.name + '_default_item_departments',  @item_departments  unless cache_on? == false
          end
          @design_departments = Caching::MemoryCache.instance.read @website.name + '_default_design_departments' unless cache_on? == false
          unless @design_departments
                    @design_departments = @website.default_design_departments #this has already been cached in lib\startup_browsing
                    Caching::MemoryCache.instance.write @website.name + '_default_design_departments',  @design_departments  unless cache_on? == false
          end
            @combined_departments = Caching::MemoryCache.instance.read @website.name + '_combined_departments' unless cache_on? == false
            unless @combined_departments
                          @combined_departments = @item_departments.to_set.merge(@design_departments.to_set).to_a
                          Caching::MemoryCache.instance.write @website.name + '_combined_departments',  @combined_departments  unless cache_on? == false
            end
            if @combined_departments.size < 2
                 @department =  @combined_departments[0]
                 @categories = @department.categories if @department
                 @full_width_department_header = true
          end
#          @designer_series_departments = Department.where("id in (?)", RecordGroup.where("Name = ?", 'all_over_shirt_design_department_ids').first.ids )  #.split(',')  )

				 if @incomplete_symbiont == true
                    logger.debug "@purchase_symbiote_item_category_category_class_id: " + @purchase_symbiote_item_category_category_class_id
                    @departments = Caching::MemoryCache.instance.read @website.name + '_opposites_for_category_' + @purchase_symbiote_item_category_category_class_id  unless cache_on? == false
                         unless @departments
                             @departments = @purchase.symbiote.item.category.potential_opposite_departments.intersection(@combined_departments)
                             Caching::MemoryCache.instance.write @website.name + '_opposites_for_category_' + @purchase_symbiote_item_category_category_class_id,  @departments  unless cache_on? == false
                         end
                    #if @purchase_symbiote_item_category_category_class.item_type == 'slave'
					          #              @departments ||= @item_departments
					          #else
                     #             @departments ||= @design_departments
					          #end
				else
							@department_introduction = true
				end
				logger.debug "END -------------------------------lib/store_item_initializer/startup_browsing_departments"
end
#############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################
def startup_browsing
			logger.debug "BEGIN -----------------------------lib/store_item_initializer/startup_browsing"
			startup_browsing_department
			startup_browsing_departments
			startup_browsing_category
      if @department
			          startup_browsing_categories
      else
                  logger.debug "###### not @department"
        end
			startup_browsing_show_items
      #load_category_browser_cache_variables
      #startup_fragment_names
  logger.debug "END -------------------------------lib/store_item_initializer/startup_browsing"
end
##############################################################################################################
############################################################################################################

#def startup_fragment_names
#			logger.debug "BEGIN -----------------------------lib/store_item_initializer/startup_fragment_names"
#    begin
#            @content_fragment_name = @website.name + "/user_type_id/" + @user_array_user_type_id + "/item_browsing/category_browser/department/"  + @department_id + "/department_type/" + @department_type + "/purchase_symbiote_item_category_category_class_id/" + @purchase_symbiote_item_category_category_class_id + "/purchase_symbiote_item_shade/" + @purchase_symbiote_item_shade
#    rescue
#            @content_fragment_name = @website.name + "/content_fragment_name_unknown"
#    end
#
#      begin
#            @category_menu_fragment_name  =  @website.name + "/user_type_id/" + @user_array_user_type_id + "/shared_menu/menu_category/sym_category_class_id/" + @purchase_symbiote_item_category_category_class_id  + "/purchase_symbiote_item_shade/" + @purchase_symbiote_item_shade +   "/department_id/" + @department.id.to_s
#    rescue
#           @category_menu_fragment_name  =  @website.name + "/category_menu_fragment_name_unknown"
#    end
#      begin
#            @standard_topbar_menus_fragment_name  =   @website.name + "/user_type_id/" + @user_array_user_type_id + "/shared_menu/standard_topbar_menu/"  + @department_id + "/department_type/" + @department_type + "/purchase_symbiote_item_category_category_class_id/" + @purchase_symbiote_item_category_category_class_id
#    rescue
#           @standard_topbar_menus_fragment_name  =  @website.name + "/standard_topbar_menus_fragment_name_unknown"
#    end
#        begin
#                     @pi = params[:pi] ||= '0'
#                     @ri  = params[:ri] ||= '0'
#                     @ol  = params[:ol] ||= '0'
#
#                      @pages_tree_menu_fragment_name = @website.name + "/user_type_id/" + @user_array_user_type_id + "/shared_menu/pages_tree_menu/customer_type/" + @customer_array_customer_type + "/root_id/" + @ri + "/parent_id/" + @pi + "/opened_leaf/" + @ol
#      rescue
#                     @pages_tree_menu_fragment_name = @website.name + "/pages_tree_menu_fragment_name_fragment_name_unknown"
#      end
#			logger.debug "END --------------------------------lib/store_item_initializer/startup_fragment_names"
#end
##############################################################################################################
#def load_category_browser_cache_variables
#			if params[:department_type]
#				@department_type = params[:department_type]
#			else
#				@department_type = '0'
#			end
#			if @purchase_symbiote_item_category_category_class_id
#				@local_purchase_symbiote_item_category_category_class_id = @purchase_symbiote_item_category_category_class_id
#			else
#				@local_purchase_symbiote_item_category_category_class_id = '0'
#			end
#			if @user_array_user_type_id
#				@local_user_array_user_type_id = @user_array_user_type_id
#			else
#				@local_user_array_user_type_id = '4'
#			end
#			if @purchase_symbiote_item_shade
#				@local_purchase_symbiote_item_shade = @purchase_symbiote_item_shade
#			else
#				@local_purchase_symbiote_item_shade = '0'
#			end
#			if @department
#				@department_id = @department.id.to_s
#			else
#				@department_id = '0'
#			end
#end
###########################################################################################################
def startup_browsing_department
			logger.debug "BEGIN -----------------------------lib/store_item_initializer/startup_browsing_department"
			if  params[:department_id]     and  params[:department_id] == "all"
                              logger.debug "params department == all"
       elsif  params[:department_id]
                      @department = Caching::MemoryCache.instance.read 'department_' + params[:department_id]  unless cache_on? == false
                      if !@department
                                  if ["all_items", "all_designs"].include?(  params[:department_id] )
                                                logger.debug "all_items or all_designs"
                                  else
                                                  @department = Department.includes(:categories).order("Name ASC" ).where( "id = ?",  params[:department_id]).first
                                                  Caching::MemoryCache.instance.write 'department_' + params[:department_id] , @department , :expires_in => 227.minutes  unless cache_on? == false
                                  end
                      end
			end
			logger.debug "END --------------------------------lib/store_item_initializer/startup_browsing_department"
end
#############################################################################################################
def startup_browsing_category
				logger.debug "BEGIN -----------------------------lib/store_item_initializer/startup_browsing_category"
				if  params[:category_id]
						@category = Caching::MemoryCache.instance.read 'category_' + params[:category_id]  unless cache_on? == false
						if !@category
							 @category ||= Category.includes(:category_class).find( params[:category_id] )
							 Caching::MemoryCache.instance.write 'category_' + params[:category_id] , @category, :expires_in => 227.minutes  unless cache_on? == false
						end	
				end
				logger.debug "END --------------------------------lib/store_item_initializer/startup_browsing_category"
end
#############################################################################################################
def startup_browsing_categories_department_category_find_categories
					logger.debug "BEGIN -----------------------------lib/store_item_initializer/startup_browsing_categories_department_category_find_categories"
					if admin?
						 @categories = Caching::MemoryCache.instance.read  'admin_symbiont_opposite_categories_in_' + @category.category_class_id.to_s + '_department_' + @department.id.to_s  unless cache_on? == false
        					if !@categories
        							logger.debug "admin_symbiont_opposite_categories_in_ - CACHE NOT READ"
        							@categories ||= Category.find( :all, :conditions => ["id in (?) or id in (?) and department_id = ?", @category.additive_category_ids_split, @purchase.opposite_category_ids , @department  ], :order => "Name ASC")
        							Caching::MemoryCache.instance.write  'admin_symbiont_opposite_categories_in_' + @category.category_class_id.to_s + '_department_' + @department.id.to_s , @categories , :expires_in => 227.minutes
        					else
        							logger.debug "admin_symbiont_opposite_categories_in_ - CACHE READ"
        					end
        			else
        			    	@categories = Caching::MemoryCache.instance.read  'symbiont_opposite_categories_in_' + @category.category_class_id.to_s + '_department_' + @department.id.to_s unless cache_on? == false
        			    	if !@categories
        			    				logger.debug "symbiont_opposite_categories_in_ - CACHE NOT READ"
        			    				@categories ||= Category.find( :all, :conditions => ["id in (?)and department_id = ?",  @purchase.opposite_category_ids , @department  ], :order => "Name ASC")
        			    				Caching::MemoryCache.instance.write  'symbiont_opposite_categories_in_' + @category.category_class_id.to_s + '_department_' + @department.id.to_s , @categories , :expires_in => 227.minutes  unless cache_on? == false
        			    	else
        			    				logger.debug "symbiont_opposite_categories_in_ - CACHE READ"
        			    	end
        			end
        			 if @categories 
        					logger.debug "startup_browsing_categories_department_category_find_categories - @categories.size" #{@categories.size}"
        			else
        					logger.debug "NO CATEGORIES FOUND"
        			end
        			logger.debug "END --------------------------------lib/store_item_initializer/startup_browsing_categories_department_category_find_categories"
end
#############################################################################################################
def startup_browsing_categories 
		logger.debug "BEGIN ------------------------------lib/store_item_initializer/startup_browsing_categories"
		# For loading @catgories for the categoy menu bar only
		# Currently only fragment caching is employed because Memcaching is not easily expired due to differing departments. This works fine.
#    firebug '@website.name ' + @website.name if @website
#    firebug '@user_array_user_type_id' + @user_array_user_type_id if @user_array_user_type_id
#    firebug '@purchase_symbiote_item_category_category_class_id ' + @purchase_symbiote_item_category_category_class_id if @purchase_symbiote_item_category_category_class_id
#    firebug '@purchase_symbiote_item_shade' + @purchase_symbiote_item_shade if @purchase_symbiote_item_shade
#    firebug '@department' + @department.id.to_s if @department
#    begin
#            @category_menu_fragment_name  =  @website.name + "/user_type_id/" + @user_array_user_type_id + "/shared_menu/menu_category/sym_category_class_id/" + @purchase_symbiote_item_category_category_class_id  + "/purchase_symbiote_item_shade/" + @purchase_symbiote_item_shade +   "/department_id/" + @department.id.to_s
#    rescue
#           @category_menu_fragment_name  =  @website.name + "/unknown_fragment_name"
#    end
#		unless read_fragment(@category_menu_fragment_name )
					if @department
									  if @incomplete_symbiont == true
									  				logger.debug "startup_browsing_categories - @incomplete_symbiont == true" 
									  				if @category
									  										logger.debug "startup_browsing_categories - @category" 
													 	   					#@categories = Caching::MemoryCache.instance.read 'symbiont_opposite_categories_in_' + @category.category_class_id.to_s + '_department_' + @department.id.to_s  unless cache_on? == false
												  			 	   	  		if !@categories && @department && @category
																						startup_browsing_categories_department_category_find_categories
														      				else
														      						logger.debug "startup_browsing_categories - @categories FOUND VIA CACHE :@categories.size: " + @categories.size.to_s
														      				end
											  		else
											  					logger.debug "startup_browsing_categories NOT @category"
											  					@categories ||= Category.order("Name ASC").where("id in (?) and department_id = ?", @purchase.opposite_category_ids , @department) if @department
											  					if @categories
											  							logger.debug "startup_browsing_categories - @categories FOUND by ActiveRecord, about to write to cache"
											  							#Caching::MemoryCache.instance.write  'symbiont_opposite_categories_in_' + @department.id.to_s , @categories , :expires_in => 227.minutes
											  					else
											  							logger.debug "startup_browsing_categories - @categories NOT FOUND by ActiveRecord"
											  					end
											  		end
									  else				
													logger.debug "startup_browsing_categories @incomplete_symbiont NOT  true" 
													@categories = Caching::MemoryCache.instance.read 'categories_in_department_' + @department.id.to_s unless cache_on? == false
												    if @department && !@categories
												    		logger.debug "startup_browsing_categories - @department && !@categories"
												        	 @categories ||= Category.where( "department_id = ? and web_category = '1'", params[:department_id] ).order('Name ASC'  )
												         	Caching::MemoryCache.instance.write  'categories_in_department_' + @department.id.to_s , @categories , :expires_in => 227.minutes
												    end
									  end
						else
									logger.warn  "NOT @department"
						end
#			else
#				logger.debug "skipped finding @categories because read_fragment(@category_menu_fragment_name )"
#			end
			logger.debug "END --------------------------------lib/store_item_initializer/startup_browsing_categories"
end
#############################################################################################################
def startup_browsing_show_items
		   	if params[:si] == '0' 
		  			@show_items = false
		  	else
		  			@show_items = true
		  	end 
end
#############################################################################################################
##############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################

#def startup_default_item_and_design_departments_deprecate
#		logger.warn "BEGIN -----------------------------lib/store_item_initializer/startup_items"
#		@item_departments = Caching::MemoryCache.instance.read @website.name + '_default_item_departments' unless cache_on? == false
#		if @item_departments
#      			logger.warn "-------------------------------------@item_departments read from cache"
#      else
#		      	@item_departments = @website.default_item_departments
#		      	if @item_departments
#			      		logger.warn "-------------------------------------@item_departments read from activerecord"
#			      		Caching::MemoryCache.instance.write @website.name + '_default_item_departments', @item_departments, :expires_in => 227.minutes  unless cache_on? == false
#		      	else
#		      			logger.warn "-------------------------------------@item_departments NOT read from activerecord"
#		      	end
#    	end
#     	@design_departments = Caching::MemoryCache.instance.read @website.name + '_default_design_departments'  unless cache_on? == false
#		if @design_departments
#      			logger.warn "-------------------------------------@design_departments read from cache"
#      else
#      			@design_departments = @website.default_design_departments
#		      	if @design_departments
#		      				logger.warn "-------------------------------------@design_departments read from activerecord"
#		      				Caching::MemoryCache.instance.write @website.name + '_default_design_departments', @design_departments, :expires_in => 227.minutes  unless cache_on? == false
#		      	else
#		      				logger.warn "-------------------------------------@design_departments NOT read from activerecord"
#		      	end
#    	end
#    	logger.warn "END -------------------------------lib/store_item_initializer/startup_items"
#end





end
