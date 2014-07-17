class SpecsheetSomewhatFixedController < ApplicationController
 before_filter :initialize_variables
 #caches_action :index , :cache_path => Proc.new{ 'action/' + @specsheet_fragment_name }

############################################################################################################
############################################################################################################
 def update_specsheet
   logger.debug "-------------------------------------begin update_specsheet: #{controller_name}"
   logger.debug "-------------------------------------params: #{params}"
   @item = Item.find(params[:item_id])
   @purchases_entry = PurchasesEntry.find(params[:purchases_entry_id]) if params[:purchases_entry_id]
   if  @purchases_entry && @incomplete_symbiont == true
     params[:department_id] = @item.default_master_department_id  #new to correct bad department code error
   end
   if Item.exists?(params[:design_id])
     @design = Item.find(params[:design_id])
   end
   @department = Department.find(params[:department_id])
   if  params[:show_wide_specsheet]
     if @item and !@design and params[:show_wide_specsheet] == 'true'
       @show_wide_specsheet = false
       if @item.item_class_component
         if @item.item_class_component.item_class.wide_specsheet == 1
           @show_wide_specsheet = true
         end
         if @show_wide_specsheet == true
           @specsheet_image =  @item.image_url( @department  , 'item_specsheets/', @design, '0' ).gsub('.png', '_wide.png' )
         else

           @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
         end
       else
         @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
       end
     else
       @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
     end
   else
     @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
   end
   if @item #&& @design.nil?
     if @item.category.category_class.item_type == 'master'
       @your_unit_price = @item.your_unit_price(@customer,1).to_f + 0.01
     else
       @your_unit_price = @item.your_unit_price(@customer,1)
     end
   end
   prepare_combination_variables(@item,@design)  if @item && @design
   end






############################################################################################################
def view_details_purchases_entry_and_not_incomplete_symbiont
			logger.warn "ssees-------------------------------------@purchases_entry.symbiotic_item: #{@purchases_entry.symbiotic_item}"
			logger.warn "asdww-------------------------------------@singular_item_customer: #{@singular_item_customer}"
      if @purchases_entry.symbiotic_item == true &&  @singular_item_customer == false
      	logger.warn "vvsa-------------------------------------purchase-with-complete-symbiont"
            @item = @purchases_entry.master_of_symbiont_pair.item
            @design = @purchases_entry.slave_of_symbiont_pair.item
          logger.warn "sssd-------------------------------------@item.id: #{@item.id}" if @item
      	logger.warn "seesa-------------------------------------@design.id: #{@design.id}" if @design
            @item_class_components =  @purchases_entry.slave_of_symbiont_pair.slaves_item_class_components_decision
            @department  =  Department.find(@purchases_entry.master_department_id)
            @required_form_elements << 'hidden_department_id_field'
            @required_form_elements << 'button_change_size_or_color'
            @required_form_elements << 'icc_collection_select'  if   @item_class_components
            @required_form_elements << 'hidden_item_id_field' unless @item_class_components
            @selected_item_id  =  @purchases_entry.master_of_symbiont_pair.item_id if @item.item_class_component
            #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select or hidden field if unavailable
     else
           @item = @purchases_entry.item   ### just added form elements as needed #########################################################################
           @item_class_components = @item.item_class_component.item_class.all_active_components if @item.item_class_component
           @department  =  Department.find(@purchases_entry.item.default_master_department_id)
           @required_form_elements << 'hidden_department_id_field'
           @required_form_elements << 'button_change_size_or_color'
           @required_form_elements << 'icc_collection_select'  if   @item_class_components
           @required_form_elements << 'hidden_item_id_field' unless @item_class_components
           @selected_item_id  =  @purchases_entry.item_id if @item.item_class_component
           #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select if available otherwise hidden field
    end
end
############################################################################################################
def view_details_purchases_entry_and_incomplete_symbiont
       if  @purchases_entry.id == @purchase.master.id
            @item = @purchase.master.item
            @department = Department.find @item.default_master_department_id
            @item_class_components = @item.item_class_component.item_class.all_valid_components  if @item.item_class_component ##error. inactive items showing
            @selected_item_id  =  @purchase.master.item_id
            @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
            @required_form_elements << 'icc_collection_select'   if @item_class_components
            @required_form_elements << 'hidden_department_id_field'   if @item_class_components
            @required_form_elements << 'button_choose_this_item'
       else
               @flash_messages << "please complete your item before editing other items"
               @custom_redirect = 'display_cart'
        end
end
############################################################################################################
def view_details_no_purchases_entry_and_incomplete_symbiont
		 @master_purchases_entry = @purchase.master
     if @purchase.symbiote_type == 'master' && @parameter_item
             if @parameter_item.category.category_class.item_type == 'slave'
                            #|||| ITEM FIRST SYMBIONT: #### allows adding the chosen design to the item/design pair
                           #A. master and applicable components and design from params -(how to tell:  @purchase.symbiont_type == 'master' && @parameter_item    )
                           @item = @master_purchases_entry.master_of_symbiont_pair.item
                           @design = @parameter_item   if @purchase.opposite_category_ids.include?(@parameter_item.category.id.to_s)
                           @required_form_elements << 'hidden_design_id_field'   if @design
                            ###sometimes when view details is loaded with a parameter item and this is master symbiote, error occurs..need to redirect
                            begin
                                      @department = Department.find(@master_purchases_entry.potential_slave_decides_masters_department(@design) )
                            rescue
                                    @department = Department.find(2 )
                            end
                            @notes << 'potential slave decided masters department'
                             @required_form_elements << 'button_choose_this_design'
                              #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => @design.id
            	else
                            @flash_messages << 'Please complete your item with a compatible design'
                            @custom_redirect = 'back'
							end
    elsif @purchase.symbiote_type == 'slave'  && @parameter_item
                   #|||| DESIGN FIRST SYMBIONT: ###{allows adding the chosen item or item_class_component to the item/design pair}
                   #B. slave - getting master and components from param - (how to tell:  @purchase.symbiont_type == 'slave'  && @parameter_item  )
                  @design = @master_purchases_entry.opposite_entry.item
                  if @purchase.opposite_category_ids.include?(@parameter_item.category.id.to_s)
                                 @item = @parameter_item
                                @item_class_components  =  @design.opposites_applicable_item_class_components(@item)            if @parameter_item.item_class_component
                  else
                                  # flash[:notice] = 'This items category id ' + @parameter_item.category.id.to_s + ' was not found in your symbiotes category_class.opposite_category_ids.'
                                   flash[:notice] = 'Item not compatible. Choose an opposite below, place on hold or forget this design.'
                                  @custom_redirect = 'back'
                  end
                  if @department == nil
                                    @department = @item.department if @item
                                    #flash[:notice] = 'slave incomplete symbiote and no @department.'
                                    # @custom_redirect = 'back'

                                    you_could_add_elements_below_but_you_need_to_bring_department_from_entry_link
                                    #@required_form_elements << 'button_choose_this_item'
                                    #@required_form_elements << 'icc_collection_select'   if @item_class_components
                                    ##     @required_form_elements << 'hidden_item_id_field'
                                    #@required_form_elements << 'hidden_department_id_field'

                  else
                                    @slaves_master_department_decision = @purchase.slave.design_decides_potential_masters_department(@department)
                                     if   @slaves_master_department_decision == 0
                                                   flash[:notice] = 'slaves opposite master default department id not set up, or self.item.category.category_class.appearing_sections.includes (parameter_department.letter_section_code).'
                                                  @custom_redirect = 'back'
                                     else
                                                    @department = Department.find(@slaves_master_department_decision ) if @department
                                                    @required_form_elements << 'button_choose_this_item'
                                                    @required_form_elements << 'icc_collection_select'   if @item_class_components
                                                     #     @required_form_elements << 'hidden_item_id_field'
                                                   @required_form_elements << 'hidden_department_id_field'
                                       end
                      end

                  @selected_item_id = @item.id if @item
                   #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select, or if unavailable, from hidden form field
     end
end
############################################################################################################
  def view_details_parameter_item_and_no_incomplete_symbiont
		#SINGULAR||||||||||||||||||||||||||||||||||||||||||
    logger.warn "VIEW_DETAILS-SINGULAR-------------------------@parameter_item && @incomplete_symbiont == false"
    #A. item getting item and item_class_component info if applicable
    @item = @parameter_item
    @selected_item_id  =  @parameter_item.id
    @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
    @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
    @required_form_elements << 'button_choose'  unless @purchases_entry
    @required_form_elements << 'icc_collection_select'   if @item_class_components
    @required_form_elements << 'hidden_department_id_field'
    if @item.category.use_generic_department == '1'
   	 @department = @item.department
   	 logger.warn "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.department"
   end
       if !@department
            if  @item.category.category_class.item_type == 'master'
       			@temp_department = @item.default_master_department_id
            		@department = Department.find @temp_department
           		logger.warn "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.default_master_department_id "
       		else
       			logger.warn "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY-----SKIPPED BECAUSE (NOT) @item.category.category_class.item_type != 'master' "
   			end
       end

    logger.warn "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department

end
############################################################################################################
def view_details_your_unit_price
						if @item && @design.nil?
	                if @item.category.category_class.item_type == 'master' &&  @singular_item_customer == false
	                     @your_unit_price = @item.your_unit_price(@customer,1) + 0.01
	                else
	               		 @your_unit_price = @item.your_unit_price(@customer,1)
	                end
            else
									@your_unit_price = @item.your_unit_price(@customer,1) if @item
						end
          				@your_unit_price = @item.symbiont_your_unit_price(@design,@customer,1) if  @item && @design
end
############################################################################################################
def setup_auto_opposites_status
		@automatic_opposite_items =  false
		if @parameter_item
				if @parameter_item.has_exactly_one_opposite_category_with_one_item_class == true and @parameter_item.category.category_class.item_type == 'slave'
								logger.warn "------------------------@parameter_item.has_exactly_one_opposite_category == true"
								@automatic_opposite_items =  true
				else
								logger.warn "------------------------@parameter_item.has_exactly_one_opposite_category == false"
				end
		else
				logger.warn "-----------------------NOT @parameter_item"
		end
end
############################################################################################################
def view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont #none because there is no symbote in progress, complete symbionts have no need of auto opposite
        @item = @parameter_item.default_opposite_product
        @design = @parameter_item
        @required_form_elements << 'hidden_design_id_field'   if @design
        @required_form_elements << 'hidden_item_id_field'   if @item
        @required_form_elements << 'hidden_add_combo_field'   if @item and @design
      	@department = @item.department
        @notes << 'view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont-@item.department-'
        @required_form_elements << 'button_choose'
end
############################################################################################################
def index
#	begin

        @notes = []
        if params[:purchases_entry_id]
              if params[:purchases_entry_id] == 'symbiote'
                    logger.warn "params[:purchases_entry_id] == symbiote"
                    @purchases_entry = @purchase.symbiote
              else
                    logger.warn "params[:purchases_entry_id] NOT = symbiote"
                    @purchases_entry = @purchase.purchases_entries.find( params[:purchases_entry_id] )
               end
               #        @purchases_entry_slave = @purchases_entry.slave_of_symbiont_pair if @purchases_entry
               #        @purchases_entry_master = @purchases_entry.master_of_symbiont_pair if @purchases_entry
        else
              @parameter_item = Item.includes(:category, :category_class, :item_class_component).find(params[:item_id]) if params[:item_id]

        end
        @parameter_item_type = @parameter_item.category.category_class.item_type  if @parameter_item
        @required_form_elements = [ ]
        setup_flash_messages_array
        setup_auto_opposites_status
        if @automatic_opposite_items == true and @incomplete_symbiont == false
       					view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont
        elsif @purchases_entry && @incomplete_symbiont == false
       					view_details_purchases_entry_and_not_incomplete_symbiont
			  elsif  @purchases_entry && @incomplete_symbiont == true
								view_details_purchases_entry_and_incomplete_symbiont
        elsif @incomplete_symbiont == true  && @purchases_entry.nil?
								view_details_no_purchases_entry_and_incomplete_symbiont
        elsif @parameter_item && @incomplete_symbiont == false
         				view_details_parameter_item_and_no_incomplete_symbiont
                #view_details_parameter_item_and_no_incomplete_symbiont_first_popular
        else
          f
        end
      	# Setup Pricing
      	view_details_your_unit_price
      	# Add final required form elements
         @required_form_elements << 'hidden_purchases_entry_id_field'   if  @purchases_entry
        # - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		     if @custom_redirect == 'back'
		            redirect_back_or_default( '/' + @website.name + '/browse_applicable_items' )
         else
               logger.debug "NO CUSTOM REDIRECT"
				        flash[:notice] = @flash_messages
				        prepare_preload_images(@item_class_components, @department, @item_prefix_override) if @item_class_components
				        prepare_combination_variables(@item,@design)  if @item && @design
				        logger.warn "VIEW_DETAILS-FINAL DEPARMENT-------------------------#{@department.id}" if @department
				        #render(:partial => "specsheet/specsheet",:locals => {:item => @item,  :department => @department  ,:design => @design }, :layout => controller_name  )  unless action_name == 'enlarge_combo'
		      end
#	rescue
#		logger.info "- RESCUE ------------------------------------- Item Not Found on view_details"
#		 flash[:notice] = "Item not found"
#		redirect_back_or_default(:controller => @website.name, :action => 'browse')
#	end
end
###########################################################################################################
###########################################################################################################
###########################################################################################################
###########################################################################################################
###########################################################################################################
###########################################################################################################
###########################################################################################################
###########################################################################################################
def load_local_browse_applicable_items_variables
			if @purchase_symbiote_item_category_category_class_id
				@local_purchase_symbiote_item_category_category_class_id = @purchase_symbiote_item_category_category_class_id
			else
				@local_purchase_symbiote_item_category_category_class_id = '0'
			end
			if @user_array_user_type_id
				@local_user_array_user_type_id = @user_array_user_type_id
			else
				@local_user_array_user_type_id = '4'
			end
			if @purchase_symbiote_item_shade
				@local_purchase_symbiote_item_shade = @purchase_symbiote_item_shade
			else
				@local_purchase_symbiote_item_shade = '0'
			end
end
###########################################################################################################
def flash_and_completion_status_bar_message
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
def browse_applicable_items
			load_local_browse_applicable_items_variables
		      if @incomplete_symbiont == true
						      			@content_fragment_name = @website.name + "/user_type_id/" + @local_user_array_user_type_id + "/shared_item/item_list_thumbnails/purchase_symbiote_item_category_category_class_id/" + @local_purchase_symbiote_item_category_category_class_id + "/shade/" + @local_purchase_symbiote_item_shade
										@items_content_fragment = read_fragment(@content_fragment_name ) unless cache_on? == false
									unless  @items_content_fragment
														startup_acceptable_item_ids_by_website
														startup_website_all_items
														logger.warn "------------------------------------- @items_content_fragment FRAGMENT NOT READ"
														logger.warn "----- WARN -------------------------- @items_content_fragment FRAGMENT NOT READ"
														logger.warn "------------------------------------- @items_content_fragment FRAGMENT NOT READ"
														logger.warn "--------------- WARN ---------------- @items_content_fragment FRAGMENT NOT READ"
					                  					@items =  @website_all_items
							         else
							            				logger.warn "------------------------------------- @items_content_fragment FRAGMENT READ"
														logger.warn "----- WARN -------------------------- @items_content_fragment FRAGMENT READ"
														logger.warn "------------------------------------- @items_content_fragment FRAGMENT READ"
														logger.warn "--------------- WARN ---------------- @items_content_fragment FRAGMENT READ"
						            end
						          	  flash_and_completion_status_bar_message
						          	  render(:partial => "shared_item/browse_applicable_items",:layout => @website.name )
		        else
		                flash[:notice] = "This action requires you have an incomplete symbiote in progress"
		                redirect_to :controller => @website.name,  :action => 'browse'
		        end
end
###########################################################################################################
#def load_browse_cache_variables
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
def browse
		@website_hidden_categories = @website.hidden_website_category_ids
     @display_complete_message = false
		  if @incomplete_symbiont
                                if  @category
                                                  if  @purchase.opposite_category_ids.include?( @category.id.to_s )
                                                                @display_complete_message = true
                                                  else
                                                                  flash[:notice] = "Please complete your in-progress Item or place it on hold to continue"  #######################################  (incomplete symbiont in progress and parameter item incompatible)
                                                                  @end_direction = true
                                                                  redirect_to  :controller => @website.name,  :action => 'display_cart'
                                                  end
                                elsif @department
                                            @opposite_categories = @purchase_symbiote_item.find_applicable_categories_by_department(@department.id)
                                            if  @opposite_categories.size > 0
                                                                  @display_complete_message = true
                                            else
                                                                  flash[:notice] = "Please complete your in-progress Item or place it on hold to continue"  #######################################  (incomplete symbiont in progress and parameter item incompatible)
                                                                   @end_direction = true
                                                                  redirect_to  :controller => @website.name,  :action => 'display_cart'
                                            end

                                end


                                  if  @display_complete_message == true
                                                if @purchase_symbiote_item_type == 'master'
                                                      @completion_status_bar_message = 'Complete your chosen Item by selecting from one of the design categories below'
                                              else
                                                        @completion_status_bar_message = 'Complete your chosen Design by selecting from one of the Item categories below'
                                              end
                                  end

			else

                             if params[:department_type]
                                          @department_introduction = true
                                             if  params[:department_type] == 'designs'
                                                    @departments = nil
                                                    @design_departments ||= @website.default_design_departments #this has already been cached in lib\startup_browsing
                                              elsif  params[:department_type] == 'items'
                                                    @departments = nil
                                                    @item_departments ||= @website.default_item_departments #this has already been cached in lib\startup_browsing
                                              end
                            end
		        end
		       	 #load_browse_cache_variables
		        	#@content_fragment_name = @website.name + "/user_type_id/" + @user_array_user_type_id + "/item_browsing/browse/department/"  + @department_id + "/department_type/" + @department_type + "/purchase_symbiote_item_category_category_class_id/" + @purchase_symbiote_item_category_category_class_id + "/purchase_symbiote_item_shade/" + @purchase_symbiote_item_shade
					            @combined_departments = @item_departments.to_set.merge(@design_departments.to_set).to_a
					             logger.warn "202020202020202020202020 "
					            logger.warn "@combined_departments: " + @combined_departments.inspect
					            logger.warn "@combined_departments.size: " + @combined_departments.size.to_s
					            logger.warn "@combined_departments[0].inspect: " + @combined_departments[0].inspect
					            if @combined_departments.size < 2 and !@department
					                   @department =  @combined_departments[0]
					                   @full_width_department_header = true
					            else
					                        #load_browse_cache_variables
					                        # @content_fragment_name = @website.name + "/user_type_id/" + @user_array_user_type_id + "/item_browsing/browse/department/"  + @department_id + "/department_type/" + @department_type + "/purchase_symbiote_item_category_category_class_id/" + @purchase_symbiote_item_category_category_class_id + "/purchase_symbiote_item_shade/" + @purchase_symbiote_item_shade
					                             #		            render(:partial => "shared_browse/main",:layout => @website.name )
					                          if !@category
					                                @category = Category.new
					                          end
					            end
		            render(:partial => "shared_browse/main",:layout => controller_name ) unless  @end_direction == true
end
############################################################################################################
def  prepare_preload_images(item_class_components,department,item_prefix_override)
    logger.debug "BEGIN prepare_preload_images"
	 @preload_images_array = []
		for icc in item_class_components
			 @preload_images_array <<      icc.item.image_url( department  , '/images/item_specsheets/', 'x' ,item_prefix_override ) if icc.item
		end
				@preload_images_array = @preload_images_array.uniq
				@preload_images_array = @preload_images_array.join("','")
    logger.debug "END prepare_preload_images"
				return @preload_images_array =      '\'' +    @preload_images_array.to_s +  '\''
end
###########################################################################################################
def update_specsheet
			logger.warn "-------------------------------------begin update_specsheet: #{controller_name}"
			logger.warn "-------------------------------------params: #{params}"
      @item = Item.find(params[:item_id])

      if params[:purchases_entry_id]
            if params[:purchases_entry_id] == 'symbiote'
                  logger.warn "params[:purchases_entry_id] == symbiote"
                  @purchases_entry = @purchase.symbiote
            else
                  logger.warn "params[:purchases_entry_id] NOT = symbiote"
                  @purchases_entry = @purchase.purchases_entries.find( params[:purchases_entry_id] )
            end
      end


			if  @purchases_entry && @incomplete_symbiont == true
           		params[:department_id] = @item.default_master_department_id  #new to correct bad department code error
			end
           if Item.exists?(params[:design_id])
                @design = Item.find(params[:design_id])
            end
            @department = Department.find(params[:department_id])
          if  params[:show_wide_specsheet]
                               if @item and !@design and params[:show_wide_specsheet] == 'true'
                                              @show_wide_specsheet = false
                                              if @item.item_class_component
                                                                                         if @item.item_class_component.item_class.wide_specsheet == 1
                                                                                                     @show_wide_specsheet = true
                                                                                          end
                                                                                if @show_wide_specsheet == true
                                                                                               @specsheet_image =  @item.image_url( @department  , 'item_specsheets/', @design, '0' ).gsub('.png', '_wide.png' )
                                                                                 else

                                                                                                @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
                                                                                  end
                                               else
                                                                @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
                                               end
                                 else
                                                  @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
                                 end
               else
                                @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
               end
                    if @item #&& @design.nil?
                        if @item.category.category_class.item_type == 'master'
                             @your_unit_price = @item.your_unit_price(@customer,1).to_f + 0.01
                        else
                     		 @your_unit_price = @item.your_unit_price(@customer,1)
            			end
                	end
              prepare_combination_variables(@item,@design)  if @item && @design
              #render(:update) { |page|
              #page.replace_html 'combo_image', render(:partial => "specsheet/specsheet_image")  if @item && @design
              #page.replace_html 'specsheet_image', image_tag(@specsheet_image) if @specsheet_image unless  @item && @design
              #page.replace_html 'item_itemlookupcode', @item.ItemLookupCode if @item
              #page.replace_html 'item_extended_description', @item.ExtendedDescription if @item
              #page.replace_html 'item_description', @item.description_before_color_and_size  if @item
              #page.replace_html 'design_itemlookupcode', @design.ItemLookupCode          if @design    && @design != 'x'
              #page.replace_html 'design_description', @design.Description       if @design    && @design != 'x'
              #page.replace_html 'your_unit_price',  number_with_precision(  @your_unit_price , :precision => 2 )             if  @your_unit_price   unless  @your_unit_price == 0.01
              #}
end
############################################################################################################
def new_designs
  @items = Caching::MemoryCache.instance.read @website.name + '_new_designs' unless cache_on? == false
  @items ||= Item.find(:all,:include => "category", :conditions => ["items.department_id in (?) and categories.Name != ?", @website.default_design_department_ids.split(/,/) , 'pocket prints'    ] , :limit => 50, :order => "DateCreated DESC")
   unless @items
        logger.warn "NO ITEMS FOUND ON NEW DESIGNS ACTION !!!!"
    else
        logger.warn "@items.size: #{@items.size}"
        Caching::MemoryCache.instance.write @website.name + '_new_designs', @items, :expires_in => 227.minutes  unless cache_on? == false
   end
  	render(:partial => "shared_item/new_items", :layout => controller_name )
end
############################################################################################################
def sale_designs
	  #@items = Caching::MemoryCache.instance.read @website.name + '_sale_designs' unless cache_on? == false
	  if @website.name == 'dixie_store' or @website.name == 'american_store'
	  		@items ||= Item.find(:all,:conditions => ["department_id in (?) and SaleType != ?",  ['10','11','12','13','14','15','16','17','18','19','20','24','27']     ,  '0'    ] , :order => "DateCreated DESC")
	  else
	  		@items ||= Item.find(:all,:conditions => ["department_id in (?) and SaleType != ?", @website.default_design_department_ids.split(/,/) ,  '0'    ] , :order => "DateCreated DESC")
	  end

	   unless @items
	        logger.warn "NO ITEMS FOUND ON NEW DESIGNS ACTION !!!!"
	    else
	        logger.warn "@items.size: #{@items.size}"
	        Caching::MemoryCache.instance.write @website.name + '_sale_designs', @items, :expires_in => 227.minutes  unless cache_on? == false
	   end
	  	render(:partial => "shared_item/sale_designs", :layout => controller_name )
end
############################################################################################################
def sale_items
	    @items = Caching::MemoryCache.instance.read @website.name + '_sale_items' unless cache_on? == false
	  	@items ||= Item.find(:all,:conditions => ["department_id in (?) and SaleType != ?", [ '2','3','4','6','7','8','9','21','22','26','28' ] ,  '0'    ] ,  :order => "DateCreated DESC")
	  	#@items ||= Item.find(:all,:conditions => ["department_id in (?)", @website.default_item_department_ids.split(/,/)   ] , :limit => 50, :order => "DateCreated DESC")
	   unless @items
	        logger.warn "NO ITEMS FOUND ON NEW DESIGNS ACTION !!!!"
	    else
	        logger.warn "@items.size: #{@items.size}"
	        Caching::MemoryCache.instance.write @website.name + '_sale_items', @items, :expires_in => 227.minutes  unless cache_on? == false
	   end
	  	render(:partial => "shared_item/sale_items", :layout => controller_name )
end
############################################################################################################
  def view_details_parameter_item_and_no_incomplete_symbiont_first_popular
    xx
    #SINGULAR||||||||||||||||||||||||||||||||||||||||||
    logger.warn "BEGIN view_details_parameter_item_and_no_incomplete_symbiont_first_popular"
    logger.warn "VIEW_DETAILS-SINGULAR-------------------------@parameter_item && @incomplete_symbiont == false"
    #@master_purchases_entry = @purchase.master
    @item = @parameter_item
    if @parameter_item.category.category_class.item_type == 'master' && @parameter_item
      if @parameter_item.category.category_class.item_type == 'slave'
        #|||| ITEM FIRST SYMBIONT: #### allows adding the chosen design to the item/design pair
        #A. master and applicable components and design from params -(how to tell:  @purchase.symbiont_type == 'master' && @parameter_item    )
        @item = @master_purchases_entry.master_of_symbiont_pair.item
        @design = @parameter_item   if @purchase.opposite_category_ids.include?(@parameter_item.category.id.to_s)
        @required_form_elements << 'hidden_design_id_field'   if @design
        ###sometimes when view details is loaded with a parameter item and this is master symbiote, error occurs..need to redirect
        begin
          @department = Department.find(@master_purchases_entry.potential_slave_decides_masters_department(@design) )
        rescue
          @department = Department.find(2 )
        end
        @notes << 'potential slave decided masters department'
        @required_form_elements << 'button_choose_this_design'
        #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => @design.id
      else
        @flash_messages << 'Please complete your item with a compatible design'
        @custom_redirect = 'back'
      end
    elsif @parameter_item.category.category_class.item_type == 'slave'
      #|||| DESIGN FIRST SYMBIONT: ###{allows adding the chosen item or item_class_component to the item/design pair}
      #B. slave - getting master and components from param - (how to tell:  @purchase.symbiont_type == 'slave'  && @parameter_item  )
      @design = @item.default_opposite_product
      if @purchase.opposite_category_ids.include?(@parameter_item.category.id.to_s)
        @item = @parameter_item
        @item_class_components  =  @design.opposites_applicable_item_class_components(@item)            if @parameter_item.item_class_component
      else
        # flash[:notice] = 'This items category id ' + @parameter_item.category.id.to_s + ' was not found in your symbiotes category_class.opposite_category_ids.'
        flash[:notice] = 'Item not compatible. Choose an opposite below, place on hold or forget this design.'
        @custom_redirect = 'back'
      end
      if @department == nil
        @department = @item.department if @item
        #flash[:notice] = 'slave incomplete symbiote and no @department.'
        # @custom_redirect = 'back'
      else
        @slaves_master_department_decision = @purchase.slave.design_decides_potential_masters_department(@department)
        if   @slaves_master_department_decision == 0
          flash[:notice] = 'slaves opposite master default department id not set up, or self.item.category.category_class.appearing_sections.includes (parameter_department.letter_section_code).'
          @custom_redirect = 'back'
        else
          @department = Department.find(@slaves_master_department_decision ) if @department
          @required_form_elements << 'button_choose_this_item'
          @required_form_elements << 'icc_collection_select'   if @item_class_components
          #     @required_form_elements << 'hidden_item_id_field'
          @required_form_elements << 'hidden_department_id_field'
        end
      end

      @selected_item_id = @item.id if @item
      #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select, or if unavailable, from hidden form field
    end

    ssaa
    # #A. item getting item and item_class_component info if applicable
    # @item = @parameter_item
    # @selected_item_id  =  @parameter_item.id
    # @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
    # @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
    # @required_form_elements << 'button_choose'  unless @purchases_entry
    # @required_form_elements << 'icc_collection_select'   if @item_class_components
    # @required_form_elements << 'hidden_department_id_field'
    # if @item.category.use_generic_department == '1'
    #	 @department = @item.department
    #	 logger.warn "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.department"
    #end
    #    if !@department
    #         if  @item.category.category_class.item_type == 'master'
    #    			@temp_department = @item.default_master_department_id
    #         		@department = Department.find @temp_department
    #        		logger.warn "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.default_master_department_id "
    #    		else
    #    			logger.warn "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY-----SKIPPED BECAUSE (NOT) @item.category.category_class.item_type != 'master' "
    #			end
    #      end
    logger.warn "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department
    logger.warn "END view_details_parameter_item_and_no_incomplete_symbiont_first_popular"
  end
############################################################################################################

#
#
#def load_local_browse_variables
#		@cached_page = true
#		if @department
#			@local_department_id = @department.id.to_s
#		else
#			@local_department_id = '0'
#		end
#
#		if @category
#			@local_category_id = @category.id.to_s
#		else
#			@local_category_id = '0'
#		end
#
#		if @purchase_symbiote_item_category_category_class_id
#			@local_purchase_symbiote_item_category_category_class_id = @purchase_symbiote_item_category_category_class_id
#		else
#			@local_purchase_symbiote_item_category_category_class_id = '0'
#		end
#
#		if @user_array_user_type_id
#			@local_user_array_user_type_id = @user_array_user_type_id
#		else
#			@local_user_array_user_type_id = '4'
#		end
#
#		if @purchase_symbiote_item_shade
#			@local_purchase_symbiote_item_shade = @purchase_symbiote_item_shade
#		else
#			@local_purchase_symbiote_item_shade = '0'
#		end
#		@fragment_name = @website.name + "/user_type_id/" + @local_user_array_user_type_id + "/shared_item/items/department_id/" + @local_department_id + "/category_id/" + @local_category_id + "/symbiote_item_category_category_class_id/" + @local_purchase_symbiote_item_category_category_class_id  + "/purchase_symbiote_item_shade/" + @local_purchase_symbiote_item_shade
#end
############################################################################################################
#def browse_not_department_not_category
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn "SUB-ACTION:browse_not_department_not_category-------------------------------------"
#					redirect_to(:controller => @website.name, :action => 'browse')
#end
#############################################################################################################
#def browse_department_not_category_not_incomplete_symbiont
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn "SUB-ACTION:browse_department_not_category_not_incomplete_symbiont-------------------------------------"
#					logger.warn "BROWSE 2-------------------------------------@department && !@category && @incomplete_symbiont == false"
#					logger.warn "-----------read_fragment(@website.name + /user_type_id/ + @local_user_array_user_type_id + /shared_item/items/department_id/ + @local_department_id +  /symbiote_item_category_category_class_id/ + @local_purchase_symbiote_item_category_category_class_id) "
#					# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#					unless read_fragment(@fragment_name)
#							logger.warn "FRAGMENT READ FAILED browse_department_not_category_not_incomplete_symbiont"
#							@categories = Category.find_all_by_department_id(@department)
#					else
#							logger.warn "FRAGMENT READ browse_department_not_category_not_incomplete_symbiont"
#					end
#			   		render(:partial => "shared_item/categories", :layout => controller_name )
#end
#############################################################################################################
#def browse_department_not_category_incomplete_symbiont
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn "SUB-ACTION:browse_department_not_category_incomplete_symbiont-------------------------------------"
#					logger.warn "BROWSE 3-------------------------------------@department && !@category && @incomplete_symbiont == true"
#					unless read_fragment(@fragment_name)
#						logger.warn "FRAGMENT READ FAILED browse_department_not_category_incomplete_symbiont"
#						@categories = @purchase.symbiote.item.find_applicable_categories_by_department(@department)
#					else
#							logger.warn "FRAGMENT READ browse_department_not_category_incomplete_symbiont"
#					end
#   					render(:partial => "shared_item/categories", :layout => controller_name )
#end
#############################################################################################################
#def browse_department_category_not_incomplete_symbiont_category_has_additives
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn "SUB-ACTION:browse_department_category_not_incomplete_symbiont_category_has_additives-------------------------------------"
#					logger.warn "BROWSE 4a-------------------------------------@category.has_additives == true && @show_items == false"
#					### SHOW ITEMS MUST BE ON TO SHOW ITEMS, @show_items will equal true if no params[:si] by default. this will go in the startup_browsing
#					unless read_fragment(@fragment_name)
#								logger.warn "FRAGMENT READ FAILED browse_department_category_not_incomplete_symbiont_category_has_additives"
#								@categories = @category.self_and_non_generic_additives
#								render(:partial => "shared_item/categories_and_additives", :layout => controller_name )
#					else
#								logger.warn "FRAGMENT READ browse_department_category_not_incomplete_symbiont_category_has_additives"
#					end
#end
#############################################################################################################
#def browse_department_category_not_incomplete_symbiont_category_show_items
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn "SUB-ACTION:browse_department_category_not_incomplete_symbiont_category_show_items-------------------------------------"
#					logger.warn "BROWSE 4b-------------------------------------@category.has_additives != true OR @show_items == true"
#					if  @category.category_class.item_type == 'master'
#								unless read_fragment(@fragment_name )
#										logger.warn "@fragment_name: #{@fragment_name}"
#										logger.warn "FRAGMENT READ FAILED browse_department_category_not_incomplete_symbiont_category_show_items @category.category_class.item_type == 'master'"
#										@items  =  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(@category)
#								else
#										logger.warn "FRAGMENT READ browse_department_category_not_incomplete_symbiont_category_show_items @category.category_class.item_type == 'master'"
#								end
#					elsif  @category.category_class.item_type != 'slave'
#								#@website.name + "/user_type_id/" + @local_user_array_user_type_id + "/shared_item/items/department_id/" + @local_department_id + "/category_id/" + @local_category_id + "/symbiote_item_category_category_class_id/" + @local_purchase_symbiote_item_category_category_class_id + "/purchase_symbiote_item_shade/0"
#								unless read_fragment(@fragment_name  )
#										logger.warn "FRAGMENT READ FAILED browse_department_category_not_incomplete_symbiont_category_show_items  @category.category_class.item_type != 'slave'"
#										@items  =  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories_plus_non_symbiont_items(@category)
#								else
#										logger.warn "FRAGMENT READ browse_department_category_not_incomplete_symbiont_category_show_items  @category.category_class.item_type != 'slave'"
#								end
#					else
#								unless read_fragment(@fragment_name)
#										logger.warn "FRAGMENT READ FAILED browse_department_category_not_incomplete_symbiont_category_show_items final else"
#										@items  =  Item.find(:all,:conditions => ["category_id = ? or category_id in (?) and Inactive != -1 ", @category , @category.additive_category_ids_split ] )   #Item.find_all_by_category_id(@category)  #,:order => "ItemLookupCode ASC"
#								else
#										logger.warn "FRAGMENT READ browse_department_category_not_incomplete_symbiont_category_show_items final else"
#								end
#					end
#					render(:partial => "shared_item/items", :layout => controller_name )
#end
#############################################################################################################
#def browse_department_category_incomplete_symbiont
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#					logger.warn " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#						logger.warn "SUB-ACTION:browse_department_category_incomplete_symbiont-------------------------------------"
#							if  @purchase.opposite_category_ids.include?( @category.id.to_s )
#                              if @category.has_additives == true && @show_items == false
#                                    logger.warn "BROWSE 4-------------------------------------@category.has_additives == true && @show_items == true"
#                                        ### SHOW ITEMS MUST BE ON TO SHOW ITEMS, @show_items will equal true if no params[:si] by default. this will go in the startup_browsing
#                                        unless read_fragment(@fragment_name)
#                                            logger.warn "FRAGMENT READ FAILED browse_department_category_incomplete_symbiont"
#                                              @categories = @category.self_and_additives_in_opposite_ids(@purchase.opposite_category_ids)
#                                              render(:partial => "shared_item/categories_and_additives", :layout => controller_name )
#                                      else
#                                              logger.warn "FRAGMENT READ browse_department_category_incomplete_symbiont"
#                                      end
#
#                              else
#                                      logger.warn "BROWSE 5-------------------------------------@department && @category && @incomplete_symbiont == true"
#                                      if  @purchase_symbiote_item_type == 'slave'
#                                          unless read_fragment(@fragment_name)
#                                              logger.warn "FRAGMENT READ FAILED browse_department_category_incomplete_symbiont @purchase_symbiote_item_type == 'slave'"
#                                              @items  =  @purchase.symbiote.item.find_applicable_opposites_in_parameter_category_and_additive_categories(@category)
#                                          else
#                                              logger.warn "FRAGMENT READ browse_department_category_incomplete_symbiont @purchase_symbiote_item_type == 'slave'"
#                                          end
#                                      else
#                                          unless read_fragment(@fragment_name)
#                                              logger.warn "FRAGMENT READ FAILED browse_department_category_incomplete_symbiont else NOT @purchase_symbiote_item_type == 'slave'"
#                                            @items  =  @purchase.symbiote.item.find_applicable_opposite_items_in_parameter_category(@category)
#                                          else
#                                              logger.warn "FRAGMENT READ browse_department_category_incomplete_symbiont else NOT @purchase_symbiote_item_type == 'slave'"
#                                          end
#                                      end
#                                        render(:partial => "shared_item/items", :layout => controller_name )
#                                end
#								else
#                      flash[:notice] = "Please complete your in-progress Item or place it on hold to continue"  #######################################  (incomplete symbiont in progress and parameter item incompatible)
#                      redirect_to  :controller => @website.name,  :action => 'display_cart'
#								end
#end
#############################################################################################################
#def browse
#					logger.warn "-------------------------------------BEGIN BROWSE ACTION"
#					logger.warn "----@purchase_symbiote_item_shade:#{@purchase_symbiote_item_shade}---"
#					load_local_browse_variables
#					if !@department && !@category
#									browse_not_department_not_category
#					elsif  @department && !@category && @incomplete_symbiont == false
#									browse_department_not_category_not_incomplete_symbiont
#					# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#					elsif  @department && !@category && @incomplete_symbiont == true
#									browse_department_not_category_incomplete_symbiont
#					# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#					elsif  @department && @category && @incomplete_symbiont == false
#									logger.warn "BROWSE 4-------------------------------------@department && @category && @incomplete_symbiont == false"
#									logger.warn "BROWSE 4-------------------------------------@category.category_class.item_type: #{@category.category_class.item_type}"
#									logger.warn "4---1:#{@local_department_id}-----2:#{@local_user_array_user_type_id}-------3:#{@local_department_id}-------4:#{@local_category_id}------5:#{@local_purchase_symbiote_item_category_category_class_id}----6:#{@local_purchase_symbiote_item_shade}---"
#									if @category.has_additives == true && @show_items == false
#											browse_department_category_not_incomplete_symbiont_category_has_additives
#									else
#											browse_department_category_not_incomplete_symbiont_category_show_items
#									end
#					# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#					elsif  @department && @category && @incomplete_symbiont == true
#									browse_department_category_incomplete_symbiont
#					# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#					else
#									logger.warn "BROWSE 6-------------------------------------final else"
#									flash[:notice] = "browse error 701"
#									redirect_to(:controller => @website.name, :action => 'index')
#					end
#					logger.warn "-------------------------------------END BROWSE ACTION"
#end
############################################################################################################





















































































#before_filter :redirect_unless_admin
#@@all_over_shirt_design_departments = ['10','11','38']
#############################################################################################################
#  def index
##	begin
#        @all_over_designer_series = true
#        @notes = []
#        @purchases_entry = @purchase.purchases_entries.find( params[:purchases_entry_id] )         if params[:purchases_entry_id]
#        @parameter_item = Item.find(params[:item_id]) if params[:item_id]
#        @parameter_item_type = @parameter_item.category.category_class.item_type  if @parameter_item
#        @required_form_elements = [ ]
#        setup_flash_messages_array
#        setup_auto_opposites_status_for_view_details
#        if @automatic_opposite_items == true and @incomplete_symbiont == false
#       					view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont
#        elsif @purchases_entry && @incomplete_symbiont == false
#       					view_details_purchases_entry_and_not_incomplete_symbiont
#			  elsif  @purchases_entry && @incomplete_symbiont == true
#								view_details_purchases_entry_and_incomplete_symbiont
#        elsif @incomplete_symbiont == true  && @purchases_entry.nil?
#								view_details_no_purchases_entry_and_incomplete_symbiont
#        elsif @parameter_item && @incomplete_symbiont == false
#         				view_details_parameter_item_and_no_incomplete_symbiont
#        end
#      	# Setup Pricing
#      	view_details_your_unit_price
#      	# Add final required form elements
#         @required_form_elements << 'hidden_purchases_entry_id_field'   if  @purchases_entry
#        # - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#		     if @custom_redirect == 'back'
#		            redirect_back_or_default( '/' + @website.name + '/browse_applicable_items' )
#		     else
#				        flash[:notice] = @flash_messages
#				        prepare_preload_images_for_view_details(@item_class_components, @department, @item_prefix_override) if @item_class_components
#				        prepare_combination_variables(@item,@design)  if @item && @design
#				        logger.debug "VIEW_DETAILS-FINAL DEPARMENT-------------------------#{@department.id}" if @department
#                       render(:partial => "specsheet/specsheet",:locals => {:item => @item,  :department => @department  ,:design => @design }, :layout => controller_name  )  unless action_name == 'enlarge_combo'
#		      end
##	rescue
##		logger.info "- RESCUE ------------------------------------- Item Not Found on view_details"
##		 flash[:notice] = "Item not found"
##		redirect_back_or_default(:controller => @website.name, :action => 'browse')
##	end
#end
############################################################################################################
#



end
