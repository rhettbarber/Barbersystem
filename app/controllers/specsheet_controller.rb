class SpecsheetController < ApplicationController
 before_filter :initialize_variables
 #caches_action :index , :cache_path => Proc.new{ 'action/' + @specsheet_fragment_name }


          # when purchases_entry exists... set item back to 0 to make incomplete symbiote.
def choose_a_different_shirt_style

end


 def update_crest_prints_list
                   @main_design = Item.find params[:main_design_id]

                    if params[:item_ids_to_remove]
                                category_id = params[:category_id]
                                params[:item_ids_to_remove].split(",").each do |item_id|
                                               logger.debug "category_id: " + category_id  + "  item_id: " + item_id
                                               new_crest_print =  CrestPrint.where(:item_id =>  item_id , :category_id => category_id  ).destroy_all
                                end
                    end

                    if params[:item_ids]
                                category_id = params[:category_id]
                                params[:item_ids].split(",").each do |item_id|
                                               logger.debug "category_id: " + category_id  + "  item_id: " + item_id
                                               new_crest_print =  CrestPrint.find_or_create_by_item_id_and_category_id( item_id , category_id )
                                end
                    end

                  if params[:item_id_to_default]
                          category_id = params[:category_id]
                          item_id = params[:item_id_to_default]

                          CrestPrint.update_all ['default_crest = ?',0 ], ['category_id = ?', category_id ]

                          crest_print =  CrestPrint.where(:item_id =>  item_id , :category_id => category_id  ).first
                          crest_print.default_crest = 1
                          crest_print.save
                  end

                 render layout: false
 end


 def admin_crest_prints_list
               #session[:show_admin] = true
               @main_design = Item.find params[:main_design_id]
               #Item.unscoped do
               #  @main_design_applicable_front_designs_ids =  @main_design.applicable_crest_print_ids
               #end
               render :layout =>  'dialog'
 end


   def crest_prints_list
               #session[:show_admin] = true
               @main_design = Item.find params[:main_design_id]
               #Item.unscoped do
               #  @main_design_applicable_front_designs_ids =  @main_design.applicable_crest_print_ids
               #end
               render :layout =>  'dialog'
   end

############################################################################################################
 def index
            #	begin
            #@crest_print =  CrestPrint.where(:item_id =>  params[:crest_id]  ).first
            if  params[:purchases_entry_id] and !@purchase
                                   redirect_back_or_default( '/store/category_items' )
             else
                                 @notes = []
                                 @purchases_entry = @purchase.purchases_entries.find( params[:purchases_entry_id] )         if  params[:purchases_entry_id]
                                  #        @purchases_entry_slave = @purchases_entry.slave_of_symbiont_pair if @purchases_entry
                                  #        @purchases_entry_master = @purchases_entry.master_of_symbiont_pair if @purchases_entry
                                 @parameter_design = Item.find(params[:design_id]) if params[:design_id]
                                 @parameter_item = Item.find(params[:item_id]) if params[:item_id]
                                 @parameter_item_type = @parameter_item.category.category_class.item_type  if @parameter_item
                                 @required_form_elements = [ ]


                                 at_side

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
                                 elsif @parameter_item && !@parameter_design && @incomplete_symbiont == false
                                   view_details_parameter_item_and_no_incomplete_symbiont
                                 elsif @parameter_item && @parameter_design &&  @incomplete_symbiont == false
                                   view_details_parameter_item_and_parameter_design_and_no_incomplete_symbiont
                                 end

                                @back_design = @design
                                @crest_prints =  @back_design.applicable_crest_prints if @back_design


                              # Setup Pricing
                                 view_details_your_unit_price
                              # Add final required form elements
                                 @required_form_elements << 'hidden_purchases_entry_id_field'   if  @purchases_entry
                              # - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                                 if @custom_redirect
                                       #logger.debug "@custom_redirect: " + @custom_redirect.to_s
                                       redirect_to( @custom_redirect )
                                 else
                                       flash[:notice] = @flash_messages
                                       prepare_preload_images(@item_class_components, @department, @item_prefix_override) if @item_class_components
                                       prepare_combination_variables(@item,@design)  if @item && @design
                                       logger.debug "VIEW_DETAILS-FINAL DEPARMENT-------------------------#{@department.id}" if @department
                                       #render(:partial => "shared_specsheet/specsheet",:locals => {:item => @item,  :department => @department  ,:design => @design }, :layout => controller_name  )  unless action_name == 'enlarge_combo'
                                 end
                              #	rescue
                              #		logger.info "- RESCUE ------------------------------------- Item Not Found on view_details"
                              #		 flash[:notice] = "Item not found"
                              #		redirect_back_or_default(:controller => @website.name, :action => 'browse')
                              #	end
                              #   logger.warn "@item.ItemLookupCode: " + @item.ItemLookupCode.inspect
             end
 end
############################################################################################################
############################################################################################################
 def view_details_purchases_entry_and_not_incomplete_symbiont
             logger.debug "begin specsheet view_details_purchases_entry_and_not_incomplete_symbiont"
             logger.debug "ssees-------------------------------------@purchases_entry.symbiotic_item: #{@purchases_entry.symbiotic_item}"
             logger.debug "asdww-------------------------------------@singular_item_customer: #{@singular_item_customer}"
             if @purchases_entry.symbiotic_item == true &&  @singular_item_customer == false
                           logger.debug "vvsa-------------------------------------purchase-with-complete-symbiont"

                           if params[:item_class_component_item_id]
                                     @selected_item_id  =  params[:item_class_component_item_id]
                                     @item =  Item.find  params[:item_class_component_item_id]
                           else
                                     @selected_item_id  =  @purchases_entry.master_of_symbiont_pair.item_id
                                     @item = @purchases_entry.master_of_symbiont_pair.item
                           end


                           #@item = @purchases_entry.master_of_symbiont_pair.item
                           @design = @purchases_entry.slave_of_symbiont_pair.item
                           logger.debug "sssd-------------------------------------@item.id: #{@item.id}" if @item
                           logger.debug "seesa-------------------------------------@design.id: #{@design.id}" if @design



                           @item_class_components =  @purchases_entry.slave_of_symbiont_pair.slaves_item_class_components_decision
                           @department  =  Department.find(@purchases_entry.master_department_id)
                           @required_form_elements << 'hidden_department_id_field'
                           @required_form_elements << 'button_change_size_or_color'
                           @required_form_elements << 'icc_collection_select'  if   @item_class_components
                           @required_form_elements << 'hidden_item_id_field' unless @item_class_components
                           #@selected_item_id  =  @purchases_entry.master_of_symbiont_pair.item_id if @item.item_class_component
                           #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select or hidden field if unavailable
             else
                           @item = @purchases_entry.item   ### just added form elements as needed #########################################################################
                           @item_class_components = @item.item_class_component.item_class.all_active_components if @item.item_class_component
                           @department  =  Department.find(@purchases_entry.item.default_master_department_id)
                           @required_form_elements << 'hidden_department_id_field'
                           @required_form_elements << 'button_change_size_or_color'
                           @required_form_elements << 'icc_collection_select'  if   @item_class_components
                           @required_form_elements << 'hidden_item_id_field' unless @item_class_components

                           #@selected_item_id  =  @purchases_entry.item_id if @item.item_class_component

                           if params[:item_class_component_item_id]
                             @selected_item_id  =  params[:item_class_component_item_id]
                           else
                             @selected_item_id  =  @purchase.master.item_id
                           end
                           #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select if available otherwise hidden field
             end
 end
############################################################################################################
 def view_details_purchases_entry_and_incomplete_symbiont
                   logger.debug "begin specsheet view_details_purchases_entry_and_incomplete_symbiont"

                    # scenerio_view_details_purchases_entry_and_incomplete_symbiont

                   if  @purchases_entry.id == @purchase.master.id
                                         if params[:item_class_component_item_id]
                                                     @item = Item.find params[:item_class_component_item_id]
                                          else
                                                      @item = @purchase.master.item
                                           end


                                         @department = Department.find @item.default_master_department_id
                                         @item_class_components = @item.item_class_component.item_class.all_valid_components  if @item.item_class_component ##error. inactive items showing

                                         if params[:item_class_component_item_id]
                                                      @selected_item_id  =  params[:item_class_component_item_id]
                                         else
                                                      @selected_item_id  =  @purchase.master.item_id
                                         end


                                         the_design_id = params[:design_id]
                                         @design  = Item.find( the_design_id )


                                         @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
                                         @required_form_elements << 'icc_collection_select'   if @item_class_components
                                         @required_form_elements << 'hidden_department_id_field'   if @item_class_components
                                         @required_form_elements << 'button_choose_this_design'
                                         #@required_form_elements << 'button_choose_this_item'
                   else


                                       if params[:item_class_component]
                                                       the_item_id  = params[:item_class_component][:item_id]
                                       elsif params[:item_id]
                                                      the_item_id = params[:item_id]
                                       end
                                       @item = Item.find( the_item_id )

                                       the_design_id = params[:design_id]
                                       @design  = Item.find( the_design_id )

                                       @department = Department.find @item.default_master_department_id
                                       @item_class_components = @item.item_class_component.item_class.all_valid_components  if @item.item_class_component ##error. inactive items showing

                                       if params[:item_class_component_item_id]
                                                  @selected_item_id  =  params[:item_class_component_item_id]
                                       else
                                                  @selected_item_id  =  @purchase.master.item_id
                                       end


                                       @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
                                       @required_form_elements << 'icc_collection_select'   if @item_class_components
                                       @required_form_elements << 'hidden_department_id_field'   if @item_class_components
                                       @required_form_elements << 'button_choose_this_item'

                                   #
                                   # @flash_messages << "please complete your item before editing other items"
                                   # @custom_redirect = :back
                   end
 end
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
############################################################################################################
 def view_details_no_purchases_entry_and_incomplete_symbiont
           logger.debug "begin specsheet view_details_no_purchases_entry_and_incomplete_symbiont"
           @master_purchases_entry = @purchase.master
           if @purchase.symbiote_type == 'master' && @parameter_item
                             if @parameter_item.category.category_class.item_type == 'slave'
                                            logger.debug "@parameter_item.category.category_class.item_type == slave"
                                           #|||| ITEM FIRST SYMBIONT: #### allows adding the chosen design to the item/design pair
                                           #A. master and applicable components and design from params -(how to tell:  @purchase.symbiont_type == 'master' && @parameter_item    )
                                           @item = @master_purchases_entry.master_of_symbiont_pair.item
                                            @item_class_components  = @item.item_class_component.item_class.all_valid_components

                                            @required_form_elements << 'icc_collection_select'   if @item_class_components

                                              @selected_item_id = @item.id if @item



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
                                         @custom_redirect =   "/store"   # :back
                              end
           elsif @purchase.symbiote_type == 'slave'  && @parameter_item
                                          logger.debug "@purchase.symbiote_type == slave  && @parameter_item"
                                         #|||| DESIGN FIRST SYMBIONT: ###{allows adding the chosen item or item_class_component to the item/design pair}
                                         #B. slave - getting master and components from param - (how to tell:  @purchase.symbiont_type == 'slave'  && @parameter_item  )
                                         @design = @master_purchases_entry.opposite_entry.item
                                         if @purchase.opposite_category_ids.include?(@parameter_item.category.id.to_s)  == true    or @purchase.opposite_category_ids.include?(params[:category_id])  == true
                                                    logger.debug "@parameter_item is compatible opposite"
                                                   @item = @parameter_item
                                                   @item_class_components  =  @design.opposites_applicable_item_class_components(@item)            if @parameter_item.item_class_component
                                         else
                                                   logger.debug "@parameter_item is not a compatible opposite"
                                                   # flash[:notice] = 'This items category id ' + @parameter_item.category.id.to_s + ' was not found in your symbiotes category_class.opposite_category_ids.'
                                                   flash[:notice] = 'Please complete your product by choosing from the menu.'
                                                   @custom_redirect = '/store'
                                         end
                                         if @department == nil
                                                   @department = @item.department if @item
                                                   #flash[:notice] = 'slave incomplete symbiote and no @department.'
                                                   # @custom_redirect = 'back'
                                         else
                                                     @slaves_master_department_decision = @purchase.slave.design_decides_potential_masters_department( @department )
                                                     if   @slaves_master_department_decision == 0
                                                       flash[:notice] = 'slaves opposite master default department id not set up, or self.item.category.category_class.appearing_sections.includes (parameter_department.letter_section_code).'
                                                       @custom_redirect = :back
                                                     else
                                                       @department = Department.find(@slaves_master_department_decision ) if @department
                                                     end
                                         end
                                         @required_form_elements << 'button_choose_this_item'
                                         @required_form_elements << 'icc_collection_select'   if @item_class_components
                                         #     @required_form_elements << 'hidden_item_id_field'
                                         @required_form_elements << 'hidden_department_id_field'
                                         if params[:item_class_component_item_id]
                                                     @selected_item_id = params[:item_class_component_item_id]
                                         else
                                                      @selected_item_id = @item.id if @item
                                        end
                                         #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select, or if unavailable, from hidden form field
           else
                              logger.debug "not within parameters"
           end
 end
############################################################################################################
#  http://192.168.0.125:2001/specsheet?department_id=2&item_class_component_item_id=54&crest_id=22753&design_id=4378&item_id=54
#  http://192.168.0.125:2001/specsheet?department_id=2&item_class_component_item_id=54&crest_id=22753&design_id=4378&item_id=54
 def view_details_parameter_item_and_parameter_design_and_no_incomplete_symbiont
                   logger.debug "VIEW_DETAILS-SINGULAR-------------------------@parameter_item && @incomplete_symbiont == false"
                 #A. item getting item and item_class_component info if applicable
                 @design = @parameter_design
                 @item = @parameter_item
                 @selected_item_id  =  @parameter_item.id
                 @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
                 @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
                 @required_form_elements << 'button_choose'  unless @purchases_entry
                 @required_form_elements << 'icc_collection_select'   if @item_class_components
                 @required_form_elements << 'hidden_department_id_field'
                 @required_form_elements << 'hidden_add_combo_field'   if @item and @design
                 if @item.category.use_generic_department == '1'
                                 @department = @item.department
                                 logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.department"
                 end
                 if !@department
                                   if  @item.category.category_class.item_type == 'master'
                                                   @temp_department = @item.default_master_department_id
                                                   @department = Department.find @temp_department
                                                   logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.default_master_department_id "
                                   else
                                                   logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY-----SKIPPED BECAUSE (NOT) @item.category.category_class.item_type != 'master' "
                                   end
                 end
                 logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department
 end
############################################################################################################
 def view_details_parameter_item_and_no_incomplete_symbiont
                 #SINGULAR||||||||||||||||||||||||||||||||||||||||||
                 logger.debug "VIEW_DETAILS-SINGULAR-------------------------@parameter_item && @incomplete_symbiont == false"
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
                                   logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.department"
                 end
                 if !@department
                                   if  @item.category.category_class.item_type == 'master'
                                                     @temp_department = @item.default_master_department_id
                                                     @department = Department.find @temp_department
                                                     logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.default_master_department_id "
                                   else
                                                     logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY-----SKIPPED BECAUSE (NOT) @item.category.category_class.item_type != 'master' "
                                   end
                 end
                 logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department
 end
############################################################################################################
 def view_details_your_unit_price
   if @item && @design.nil?
     if @item.category.category_class.item_type == 'master' &&  @singular_item_customer == false
       @your_unit_price = @item.your_unit_price(@customer_array,1) + 0.01
     else
       @your_unit_price = @item.your_unit_price(@customer_array,1)
     end
   else
     @your_unit_price = @item.your_unit_price(@customer_array,1) if @item
   end
   @your_unit_price = @item.symbiont_your_unit_price(@design,@customer_array,1) if  @item && @design


 end
############################################################################################################
 def setup_auto_opposites_status
   @automatic_opposite_items =  false
   if @parameter_item
     if @parameter_item.has_exactly_one_opposite_category_with_one_item_class == true and @parameter_item.category.category_class.item_type == 'slave'
       logger.debug "------------------------@parameter_item.has_exactly_one_opposite_category == true"
       @automatic_opposite_items =  true
     else
       logger.debug "------------------------@parameter_item.has_exactly_one_opposite_category == false"
     end
   else
     logger.debug "-----------------------NOT @parameter_item"
   end
 end
############################################################################################################
 def view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont #none because there is no symbote in progress, complete symbionts have no need of auto opposite
   logger.debug "begin specsheet view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont"
   @item = @parameter_item.default_opposite_item
   @design = @parameter_item
   @required_form_elements << 'hidden_design_id_field'   if @design
   @required_form_elements << 'hidden_item_id_field'   if @item
   @required_form_elements << 'hidden_add_combo_field'   if @item and @design
   @department = @item.department
   @notes << 'view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont-@item.department-'
   @required_form_elements << 'button_choose'
 end
############################################################################################################
 def  prepare_preload_images(item_class_components,department,item_prefix_override)
   @preload_images_array = []
    item_class_components.each do |icc|
     @preload_images_array <<      icc.item.image_url( department  , '/images/item_specsheets/', 'x' ,item_prefix_override )  if icc.item and icc.item.category
   end
   @preload_images_array = @preload_images_array.uniq
   @preload_images_array = @preload_images_array.join("','")
   return @preload_images_array =      '\'' +    @preload_images_array.to_s +  '\''
 end
###########################################################################################################
###########################################################################################################
 def update_specsheet
       logger.debug "-------------------------------------begin update_specsheet: #{controller_name}"
       logger.debug "-------------------------------------params: #{params}"
       @item = Item.find(params[:item_id])
       @purchases_entry = PurchasesEntry.find(params[:purchases_entry_id]) if params[:purchases_entry_id]

       at_side

       if  @purchases_entry && @incomplete_symbiont == true
                 params[:department_id] = @item.default_master_department_id  #new to correct bad department code error
       end
       if Item.exists?(params[:design_id])
                  @design = Item.find(params[:design_id])
       end
       @department = Department.find(params[:department_id])
       if  params[:show_wide_specsheet]
                           if @item and !@design and params[:show_wide_specsheet] # == 'true'
                                             @show_wide_specsheet = false
                                             if @item.item_class_component
                                                               #if @item.item_class_component.item_class.wide_specsheet == 1
                                                               #   odddd
                                                               #  @show_wide_specsheet = true
                                                               #end
                                                               #if @show_wide_specsheet == true
                                                               #         bbb
                                                               #         @specsheet_image =  @item.image_url( @department  , 'item_specsheets/', @design, '0' ).gsub('.png', '_wide.png' )
                                                               #else

                                                                          #<% @product_background_image_name =  '/images/item_specsheets/' + @item.PictureName.gsub(".jpg", "")  + '.jpg' %>
                                                                          @specsheet_image =   '/images/item_specsheets/' + @item.PictureName.gsub(".jpg", "")  + '.jpg'
                                                                          #@specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
                                                               #end
                                             else
                                                                #dddd
                                                                @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
                                             end
                           else
                                            @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
                           end
       else
                          no_show_wide_specsheet_param
                          @specsheet_image = @item.image_url(  @department,'item_specsheets/', @design, '0' )
       end
       if @item #&& @design.nil?
         if @item.category.category_class.item_type == 'master'
           @your_unit_price = @item.your_unit_price(@customer_array,1).to_f + 0.01
         else
           @your_unit_price = @item.your_unit_price(@customer_array,1)
         end
       end
       prepare_combination_variables(@item,@design)  if @item && @design
   end

end
