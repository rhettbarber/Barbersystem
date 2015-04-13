class DesignerSpecsheetController < ApplicationController
#before_filter :update_specsheet_session
skip_before_filter :verify_authenticity_token, :only => [:update_specsheet_category_items, :specsheet_item_search, :ajax_change_product_choice, :ajax_administer_edit_item ,:different_department_item_chosen_update_category]

@@category_items_per_page = 12


###########################################################################################################
  def index
    @incomplete_symbiont = false
    firebug "test firebug "
    setup_flash_messages_array
    @required_form_elements = [ ]
    @notes = []
    @purchases_entry = @purchase.purchases_entries.find( params[:purchases_entry_id] )         if params[:purchases_entry_id]
    @parameter_item = Item.unscoped.find(params[:item_id]) if params[:item_id]
    @parameter_item_type = @parameter_item.category.category_class.item_type  if @parameter_item
    session['return-to'] = request.fullpath
#                 flash[:notice] = [  session['return-to']  ]
    flash[:notice] = [   ]
    if params[:item_id] and params[:design_id] and !params[:purchases_entry_id]
      a  view_details_from_url
    elsif   @purchases_entry && @incomplete_symbiont == false
      b  flash[:notice] << 'view_details_purchases_entry_and_not_incomplete_symbiont'
      view_details_purchases_entry_and_not_incomplete_symbiont
    elsif  @purchases_entry && @incomplete_symbiont == true
      c  flash[:notice] << 'view_details_purchases_entry_and_incomplete_symbiont'
      view_details_purchases_entry_and_incomplete_symbiont
    elsif @incomplete_symbiont == true  && @purchases_entry.nil?
      d    flash[:notice] << 'view_details_no_purchases_entry_and_incomplete_symbiont'
            view_details_no_purchases_entry_and_incomplete_symbiont
    elsif !params[:item_id] and !params[:purchases_entry_id] and !session[:current_front_design] and  !session[:current_back_design]
      ##################################################################################################
      e        ##################################################################################################
               ##################################################################################################
            @parameter_item_type = 'all_over_design'
            flash[:notice] << 'index_setup_default_view_no_input'
            index_setup_default_view_no_input
#                              item_category_category_class_all_over_item
##################################################################################################
##################################################################################################
##################################################################################################
    elsif params[:item_id] and !params[:purchases_entry_id]
      if @parameter_item_type == 'all_over_design' #and params[:designer] == 'true'
        a      flash[:notice] << 'item_category_category_class_all_over_item'
        item_category_category_class_all_over_item
      elsif @parameter_item_type != 'all_over_design'  and params[:designer] == 'true'
        b    flash[:notice] << 'item_category_category_class_not_all_over_item'
        item_category_category_class_not_all_over_item
      elsif @automatic_opposite_items == true and @incomplete_symbiont == false
        c     flash[:notice] << 'view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont'
        view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont
      elsif @purchases_entry && @incomplete_symbiont == false
        d    flash[:notice] << 'view_details_purchases_entry_and_not_incomplete_symbiont'
        view_details_purchases_entry_and_not_incomplete_symbiont
      elsif  @purchases_entry && @incomplete_symbiont == true
        e    flash[:notice] << 'view_details_purchases_entry_and_incomplete_symbiont'
        view_details_purchases_entry_and_incomplete_symbiont
      elsif @incomplete_symbiont == true  && @purchases_entry.nil?
        f    flash[:notice] << 'view_details_no_purchases_entry_and_incomplete_symbiont'
        view_details_no_purchases_entry_and_incomplete_symbiont
      elsif @parameter_item && @incomplete_symbiont == false
        flash[:notice] << 'view_details_parameter_item_and_no_incomplete_symbiont'
        view_details_parameter_item_and_no_incomplete_symbiont
      else
        g = "g"
      end
#                        render :text =>   '@parameter_item_type: ' +   @parameter_item_type
#                        render :text =>   '@parameter_item.description_before_color_and_size ' +   @parameter_item.description_before_color_and_size
    end
  end
###########################################################################################################


def modal
  render layout: false
end


  def ajax_change_product_choice
                    current_website
                   @from_ajax = true
                  Item.unscoped do
                          @item = Item.find  params[:item_id]
                           @front_design = Item.find params[:front_design_id] unless params[:front_design_id] == ""
                           @back_design = Item.find params[:back_design_id] unless params[:back_design_id] == ""
#                           @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)  if @back_design
#                           @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)   if @front_design
            #       @back_design.category.category_class.item_type == 'all_over_design'
                          if @back_design.is_breast_print?
                                                logger.debug " @back_design.is_breast_print? "
                                               if @item.is_applicable_with?( @front_design )
                                                              logger.debug " @item.is_applicable_with?( @front_design ) "
                                                               @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)  if @back_design
                                                                @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)   if @front_design

                                               else
                                                               logger.debug " NOT  @item.is_applicable_with?( @front_design ) "

                                               end
                          elsif @front_design.is_breast_print?
                                                 logger.debug " @front_design.is_breast_print?"
                                                 if @item.is_applicable_with?( @back_design )
                                                                      logger.debug " @item.is_applicable_with?( @back_design ) "
                                                                      logger.debug " @back_design.category_id:  "  + @back_design.category_id.to_s
                                                                     @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)  if @back_design
                                                                      @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)   if @front_design
                                                 else
                                                                         logger.debug " NOT  @item.is_applicable_with?( @back_design ) "
                                                                         #@back_design = Rails.cache.read "most_popular_compatible_opposite_for_category_id_" + @item.category_id.to_s
                                                                         if @back_design
                                                                                         logger.debug "most_popular_compatible_opposite read from cache"
                                                                         else
                                                                                        @back_design = @item.most_popular_compatible_opposite( @website.default_design_department_ids )
                                                                                        Rails.cache.write "most_popular_compatible_opposite_for_category_id_" + @item.category_id.to_s,  @back_design
                                                                         end
                                                                        @items_back =  Item.where('category_id like ?', @back_design.category_id  )
                                                                        Item.unscoped do
                                                                                          @items_front =    @back_design.find_applicable_crest_print.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
                                                                        end
                                                                       @front_design = @items_front.first
                                                                        if params[:swap] == "1"
                                                                             @back_design_temp = @back_design
                                                                             @back_design = @front_design
                                                                             @front_design = @back_design_temp
                                                                        end
                                                                       @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)  if @back_design
                                                                       @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)   if @front_design
                                                 end
                          elsif      @back_design.category.category_class.item_type == 'all_over_design'
                                                            logger.debug " @back_design.category.category_class.item_type == all_over_design"
                                                            @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
                                                                     if @item.is_applicable_with?( @back_design )
                                                                                          logger.debug " @item.is_applicable_with?( @back ) "

                                                                     else
                                                                                          logger.debug " NOT  @item.is_applicable_with?( @back ) "
                                                                                          @back_design = nil
#                                                                                           @back_design = Rails.cache.read "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s + "_for_website_" + @website.id.to_s
                                                                                           if @back_design
                                                                                                           logger.debug "most_popular_compatible_opposite read from cache"
                                                                                           else
                                                                                                          @back_design = @item.most_popular_compatible_opposite( @website.default_design_department_ids )
                                                                                                          Rails.cache.write "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s  + "_for_website_" + @website.id.to_s,  @back_design
                                                                                           end
                                                                                           if @back_design.category.prefix == 'rp'
                                                                                                            logger.debug " @back_design.category.prefix == rp"
                                                                                                                  Item.unscoped do
                                                                                                                                    @items_front =    @back_design.find_applicable_crest_print.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
                                                                                                                  end
                                                                                                                  @items_back =  Item.where('category_id like ?', @back_design.category_id  )
                                                                                                                  @front_design = @items_front.first
                                                                                                                  logger.debug "@front_design: " +  @front_design.inspect
                                                                                                                  @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)  if @back_design
                                                                                                                  @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)   if @front_design
                                                                                           else
                                                                                                            logger.debug " @back_design.category.prefix IS NOT == rp"
                                                                                           end
                                                                     end
                          else
                                                     logger.debug " NEITHER @front_design.is_breast_print? OR @back_design.is_breast_print? or @back_design.category.category_class.item_type == all_over_design "

                          end
                                  @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
                  end
#               respond_to do |format|
#                          format.js {render :content_type => 'text/javascript'}
#               end
                render :update do |page|
                            page.replace_html 'null_replace',    :partial => 'designer_specsheet/ajax_change_product_choice'
                            page.replace_html 'category_items_back',    :partial => 'designer_specsheet/category_items_back'
                            page.replace_html 'category_items_front',    :partial => 'designer_specsheet/category_items_front'
                end
 end
 ############################################################################################################
def different_department_item_chosen_update_category
      current_website
       @from_ajax = true
       if params[:changed_object] == 'back'
                      @item = Item.find params[:item_id]
                      @back_design = Item.where("category_id = ?",  params[:category_id] ).first
                      if @item.is_applicable_with?( @back_design )
                                      logger.debug "GOOD @item.is_applicable_with?( @back_design ) "
                                      @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName

                      else
                                      logger.debug "BAD  @item.is_applicable_with?( @back_design ) FALSE "
                                      @new_item = @back_design.most_popular_compatible_opposite( @website.default_all_department_ids_with_generic  )
                                      @product_background_image_name =   '/images/item_specsheets/' + @new_item.PictureName  + '.png'

                                      if @back_design.category.category_class.item_type == 'all_over_design'
                                                    logger.debug "@back_design.category.category_class.item_type == 'all_over_design'"
                                                  @product_mask_image_name =   '/images/item_masks/' + @new_item.item_class_item_lookup_code + '.png'
                                                  @front_design = @back_design
                                                  @front_design_image_name     =   '/images/item_specsheets/' + @back_design.ItemLookupCode + '-0.png'
                                                  @back_design_image_name     =    '/images/item_specsheets/' + @back_design.ItemLookupCode + '-1.png'
                                                   @back_advanced_combination = AdvancedCombination.find_or_create_combo( @new_item, @back_design)  if @back_design
                                                   @front_advanced_combination = AdvancedCombination.find_or_create_combo( @new_item, @front_design)   if @front_design
                                      else
                                                  logger.debug "NOT @back_design.category.category_class.item_type == 'all_over_design'"
                                                  @front_design = @back_design.find_applicable_crest_print.sort_by{|a| a.ytdn}.reverse.first      #@back_design
                                                  @back_advanced_combination = AdvancedCombination.find_or_create_combo( @new_item, @back_design)  if @back_design
                                                  @front_advanced_combination = AdvancedCombination.find_or_create_combo( @new_item, @front_design)   if @front_design
                                                  @front_design_image_name     =   '/images/item_specsheets/' + @front_design.PictureName
                                                  @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName

                                      end


                      end

       end
    render :partial => 'designer_specsheet/category_items_front'


#        Item.unscoped do
#                                  @items_front =         @back_design.find_applicable_crest_print.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
#           end


end
 ############################################################################################################
def select_list_update_category_back

               @items_back =  Item.where('category_id like ?', params[:category_id]   )
               @back_design = @items_back.first
                Item.unscoped do
                                  @items_front =    @back_design.find_applicable_crest_print.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
                end
                if @back_design.category.category_class.item_type == 'all_over_design'
                          @front_design = @back_design
                else
                          @front_design = @items_front.first
                end
               @item = Item.find params[:item_id]
               @from_ajax = true

              if params[:swap] == "1"
                   @back_design_temp = @back_design
                   @back_design = @front_design
                   @front_design = @back_design_temp
              end
               @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)  if @back_design
               @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)   if @front_design
               render  :partial => 'designer_specsheet/category_items_back'
end
###########################################################################################################
def select_list_update_category_product
              Item.unscoped do
                           @item = Item.find params[:item_id]
                           @front_design = Item.find params[:front_design_id]
                           @back_design = Item.find params[:back_design_id]
                           @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)  if @back_design
                           @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)   if @front_design
                           @items_product = Rails.cache.read "find_first_of_each_type_from_parameter_category_plus_additive_item_categories_plus_non_symbiont_items_for_category_" + params[:category_id]
                           if @items_product
                                    logger.debug "RAILS FOUND @items_product in CACHE"
                           else
                                     logger.debug "RAILS DID NOT FIND @items_product in CACHE"
                                    @items_product = Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories_plus_non_symbiont_items(  params[:category_id] )
                                    Rails.cache.write "find_first_of_each_type_from_parameter_category_plus_additive_item_categories_plus_non_symbiont_items_for_category_" + params[:category_id], @items_product
                           end
                            @from_ajax = true
                            @selected_category = Category.find params[:category_id]

              end
               render  :partial => 'designer_specsheet/category_items_product'
end
  ###########################################################################################################
     def item_category_category_class_all_over_item
              logger.debug "BEGIN--------------------------------------------------- item_category_category_class_all_over_item"
              #set up default specsheet with no inputs
              @all_over_design = Item.find params[:item_id]
              @back_design = @all_over_design
               @front_design = @all_over_design
              @item = Item.find 15245
               @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)  if @back_design
               @front_advanced_combination = @back_advanced_combination
              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
              @product_mask_image_name =   '/images/item_masks/' + @item.PictureName + '.png'
              @front_design_image_name     =   '/images/item_specsheets/' + @all_over_design.PictureName + '-0.png'
              logger.debug "@front_design_image_name: " + @front_design_image_name
              @back_design_image_name     =    '/images/item_specsheets/' + @all_over_design.PictureName + '-1.png.'
              @department_choices_background = Department.find_all_by_id( ['36' ]  )
              @department_choices_front =  @website.default_design_departments
              @department_choices_back = @website.default_design_departments
               @department_choices_product = @website.default_item_departments
              @items_background =    Item.where("department_id = ?", '36' )    # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
              @items_front  =  Item.order("ItemLookupCode").where('category_id like ?', @back_design.category_id )    #=  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
              @items_back  =  Item.order("ItemLookupCode").where('category_id like ?', @back_design.category_id )    # =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
              @items_product = Rails.cache.read 'opposite_representatives_sorted_by_sales_' + @all_over_design.category.category_class_id.to_s unless cache_on? == false
                                if @items_product
                                          logger.debug "FOUND @items_product USING CACHE"
                                          logger.debug "FOUND @items_product USING CACHE"
                                          logger.debug "FOUND @items_product USING CACHE"
                                          logger.debug "FOUND @items_product USING CACHE"
                                else
                                          logger.debug "ERROR - FAILED TO FIND @items_product USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @all_over_design.category.category_class_id.to_s
                                          @items_product =  @all_over_design.opposite_representatives_sorted_by_sales
                                          Rails.cache.write  'opposite_representatives_sorted_by_sales_' + @all_over_design.category.category_class_id.to_s  , @items_product  unless cache_on? == false
                                end
              @your_unit_price = @item.your_unit_price(@customer,1) if @customer
#              @custom_items = CustomItem.find(:all,:conditions => ["thumbnail is null" ] )
              logger.debug "END--------------------------------------------------- item_category_category_class_all_over_item"
  end
    ###########################################################################################################
  def view_details_parameter_item_and_no_incomplete_symbiont
           logger.debug "BEGIN--------------------------------------------------- view_details_parameter_item_and_no_incomplete_symbiont"
           if params[:item_type] == 'slave'
                      Item.unscoped do
                                #SINGULAR||||||||||||||||||||||||||||||||||||||||||
                                logger.debug "VIEW_DETAILS-SINGULAR-------------------------@parameter_item && @incomplete_symbiont == false"
                                @back_design = Item.find   params[:item_id]
                                @back_design_id = @back_design.id
                                # @design = Item.find params[:item_id]
                                 @items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
                                @front_design =  @items_front.first
                                @front_design_id = @front_design.id
                                @front_design_name = @front_design.ItemLookupCode + '.png'
                                  @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_print_ids
                                @item = Item.find 82
                                logger.warn "###########   ######     #########"
                                logger.warn " @item.item_class_component.item_class.id: " + @item.item_class_component.item_class.id.to_s
                                logger.warn "###########   ######     #########"
                                if @front_design
                                              if @front_design.category
                                                       logger.warn " @front_design.category.id: " +  @front_design.category.id.to_s
                                              end
                                            @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)
                                else
                                              @front_design_name = Slug.generate(@back_design.department.Name) + '.png'
                                end
                                 if @back_design
                                            if @back_design.category
                                                       logger.warn " @back_design.category.id: " +  @back_design.category.id.to_s
                                            end
                                            @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design) 
                                 end
                                #              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
                                @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
                                @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
                                @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
                                @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
                                ##########  DEPARTMENT CHOICES
                                @department_choices_background = Department.find_all_by_id( ['36' ]  )
                  @website = Website.find 3
                                @department_choices_front =    @website.default_design_departments   #@back_design.crest_print_department_records
                                @department_choices_back = @website.default_design_departments
                                  @items_background =    Item.where("department_id = ?", '36' ) 
      #                          @department_choices_product = @back_design.opposite_departments  # IF YOU NEED TO BE SPECIFIC TO  CURRENT DESIGN USE THIS...
                                @department_choices_product = @website.default_item_departments
                                @items_product = Rails.cache.read 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
                                if @items_product
                                    logger.debug "FOUND @items_product USING CACHE"
                                    logger.debug "FOUND @items_product USING CACHE"
                                    logger.debug "FOUND @items_product USING CACHE"
                                    logger.debug "FOUND @items_product USING CACHE"
                                else
                                  logger.debug "ERROR - FAILED TO FIND @items_product USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
                                  @items_product =  @back_design.opposite_representatives_sorted_by_sales
                                  Rails.cache.write  'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s  , @items_product
                                end
#                                @items_background =  Item.order("ItemLookupCode").where('category_id like ?', 677)    #  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'

                                @items_back =  Item.order("ItemLookupCode").where('category_id like ?', @back_design.category_id )   # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @back_design.category_id  ]  , :order => 'ItemLookupCode'   #@back_design.category_id
#                                @items_product =  @items_product.to_a.paginate :per_page => @@category_items_per_page, :page => params[:page]    , :order => 'ItemLookupCode'
                                @your_unit_price = @item.your_unit_price(@customer,1) if @customer
                      end
                                   logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department
           elsif params[:item_type] == 'master'
                                logger.debug "params[:item_type] == 'master'"
                                 @item = Item.find params[:item_id] #|| 82
                                 logger.warn " @item.item_class_component.item_class.id: " + @item.item_class_component.item_class.id.to_s
                                 if params[:back_design_id]
                                                      @back_design = Item.find   params[:back_design_id]      #||    3061
                                 else
                                                       @back_design = Rails.cache.read "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s
                                                       if @back_design
                                                                       logger.debug "most_popular_compatible_opposite read from cache"
                                                       else
                                                                      @back_design = @item.most_popular_compatible_opposite
                                                                      Rails.cache.write "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s,  @back_design
                                                       end
                                 end
                                @back_design_id = @back_design.id
                                Item.unscoped do
                                        @items_front =         @back_design.find_applicable_crest_print.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
                                end

#################################################
                                if @items_front.first
                                              logger.warn "########### @items_front.first NOT FOUND    #########"
                                              logger.warn "########### @items_front.first NOT FOUND    #########"
                                              logger.warn "########### @items_front.first NOT FOUND    #########"
                                                @front_design =  @items_front.first
                                                @front_design_id = @front_design.id
                                                @front_design_name = @front_design.ItemLookupCode + '.png'
                                                @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
                                else
                                              logger.warn "########### @items_front.first NOT FOUND    #########"
                                              logger.warn "########### @items_front.first NOT FOUND    #########"
                                              logger.warn "########### @items_front.first NOT FOUND    #########"
                                end
#################################################


#                                           logger.warn " @front_design.category.id: " +  @front_design.category.id.to_s  if @front_design
#                                           logger.warn " @back_design.category.id: " +  @back_design.category.id.to_s  if @back_design
                                @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design) if @front_design
                                @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design) if @back_design
                                Item.unscoped do
                                  @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_print_ids
                                end
                                #              @front_design_name = Slug.generate(@back_design.department.Name) + '.png'
                                #              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
                                @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
                                @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
                                @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
                                ##########  DEPARTMENT CHOICES
                                @department_choices_background = Department.find_all_by_id( ['36' ]  )
                                @department_choices_front =    @website.default_design_departments   #@back_design.crest_print_department_records
                                @department_choices_back = @website.default_design_departments
      #                          @department_choices_product = @back_design.opposite_departments  # IF YOU NEED TO BE SPECIFIC TO  CURRENT DESIGN USE THIS...
                                @department_choices_product = @website.default_item_departments
                                @items_product = Rails.cache.read 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
                                if @items_product
                                    logger.debug "FOUND @items_product USING CACHE"
                                    logger.debug "FOUND @items_product USING CACHE"
                                    logger.debug "FOUND @items_product USING CACHE"
                                    logger.debug "FOUND @items_product USING CACHE"
                                else
                                  logger.debug "ERROR - FAILED TO FIND @items_product USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
                                  @items_product =  @back_design.opposite_representatives_sorted_by_sales
                                  Rails.cache.write  'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s  , @items_product
                                end
                                @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
                                @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @back_design.category_id  ]  , :order => 'ItemLookupCode'   #@back_design.category_id
                                @items_product =  @items_product.to_a.paginate :per_page => @@category_items_per_page, :page => params[:page]    , :order => 'ItemLookupCode'
                                @your_unit_price = @item.your_unit_price(@customer,1) if @customer
           else
                                       insufficient_parameters
           end
            logger.debug "END--------------------------------------------------- view_details_parameter_item_and_no_incomplete_symbiont"
end
#############################################################################################################
   def index_setup_default_view_no_input
              logger.debug "###################################################"
              logger.debug "BEGIN--------------------------------------------------- index_setup_default_view_no_input"
              logger.debug "BEGIN--------------------------------------------------- index_setup_default_view_no_input"
              logger.debug "BEGIN--------------------------------------------------- index_setup_default_view_no_input"
              @all_over_design = Item.unscoped.find   19765
              @item = Item.find 15245
              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
              @product_mask_image_name =   '/images/item_masks/' + @item.PictureName + '.png'
              @front_design_image_name     =   '/images/item_specsheets/' + @all_over_design.ItemLookupCode + '-0.png'
              @back_design_image_name     =    '/images/item_specsheets/' + @all_over_design.ItemLookupCode + '-1.png'
              @department_choices_background = Department.find_all_by_id( ['36' ]  )
              @website = Website.find 1
              @department_choices_front =  @website.default_design_departments
              @department_choices_back = @website.default_design_departments
              @department_choices_product = Department.find_all_by_id(  '26' )
              @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
              @items_front =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
              @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
              @your_unit_price = @item.your_unit_price(@customer,1) if @customer
#              if @user
#                      @custom_items = @user.custom_items.order("id DESC").find(:all,:conditions => ["thumbnail is null" ] )
#              else
#                      @custom_items = CustomItem.sample_customs   # .limit("5").where("thumbnail is null")
#              end
              logger.debug "END--------------------------------------------------- index_setup_default_view_no_input"
              logger.debug "###################################################"
              logger.debug "###################################################"
  end
############################################################################################################
def view_details_from_url
                          @item = Item.find  params[:item_id]
                          @back_design = Item.find   params[:design_id]
                          Item.unscoped do
                                  @items_front =         @back_design.find_applicable_crest_print.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
                          end
                          if @items_front
                                  @front_design =  @items_front.first
                                  if @front_design
                                          @front_design_id = @front_design.id
                                          @front_design_name = @front_design.ItemLookupCode + '.png'
                                  end
                          end
                          Item.unscoped do
                            @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_print_ids
                          end
                          logger.warn "###########   ######     #########"
                          logger.warn " @item.item_class_component.item_class.id: " + @item.item_class_component.item_class.id.to_s
                          logger.warn " @front_design.category.id: " +  @front_design.category.id.to_s if @front_design
                          logger.warn " @back_design.category.id: " +  @back_design.category.id.to_s
                          logger.warn "###########   ######     #########"
                          @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)
                          @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
                          @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
                          @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
                          @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
                          @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
                          ##########  DEPARTMENT CHOICES
                          @department_choices_background = Department.find_all_by_id( ['36' ]  )
                          @department_choices_front =    @website.default_design_departments   #@back_design.breast_print_department_records
                          @department_choices_back = @website.default_design_departments
                          @department_choices_shirt_style = @back_design.opposite_departments
                          @items_shirt_style = Rails.cache.read 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
                          if @items_shirt_style
                              logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
                              logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
                              logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
                              logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
                          else
                            logger.debug "ERROR - FAILED TO FIND @ITEMS_SHIRT_STYLE USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
                            @items_shirt_style =  @back_design.opposite_representatives_sorted_by_sales
                            Rails.cache.write  'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s  , @items_shirt_style
                          end
                          @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
                          @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'   #@back_design.category_id
                          @items_shirt_style =  @items_shirt_style.to_a.paginate :per_page => @@category_items_per_page, :page => params[:page]    , :order => 'ItemLookupCode'
                          @your_unit_price = @item.your_unit_price(@customer,1) if @customer
end
#############################################################################################################
 def ajax_item_update

       Item.unscoped do
                           @item = Item.find(params[:id_for_editing])
                           @item.accessible = :all if admin?

                          if @item.update_attributes!(params[:item] )

                                               render(:update) { |page|
                                                          if params[:side] == 'front'
                                                                   page.replace_html 'ajax_administer_edit_front_design_empty'  , :partial => 'control_tabs_item_administration/ajax_update_items'  , :locals => {:side => params[:side], :status => "Success" }
                                                          else
                                                                   page.replace_html 'ajax_administer_edit_back_design_empty'  , :partial => 'control_tabs_item_administration/ajax_update_items'  , :locals => {:side => params[:side] , :status => "Success"}
                                                          end
                                              }

                          else
                                                       render(:update) { |page|
                                                          if params[:side] == 'front'
                                                                   page.replace_html 'ajax_administer_edit_front_design_empty'  , :partial => 'control_tabs_item_administration/ajax_update_items'  , :locals => {:side => params[:side], :status => "Failed" }
                                                          else
                                                                   page.replace_html 'ajax_administer_edit_back_design_empty'  , :partial => 'control_tabs_item_administration/ajax_update_items'  , :locals => {:side => params[:side] , :status => "Failed"}
                                                          end
                                              }
                          end



#                          if @item.update_attributes!(params[:item] )
#
#                                               render(:update) { |page|
#                                                          if params[:side] == 'front'
#                                                                   page.replace_html 'item_saved_front'  , :partial => 'control_tabs_item_administration/ajax_update_items'  , :locals => {:side => params[:side], :status => "Success" }
#                                                          else
#                                                                   page.replace_html 'item_saved_back'  , :partial => 'control_tabs_item_administration/ajax_update_items'  , :locals => {:side => params[:side] , :status => "Success"}
#                                                          end
#                                              }
#
#                          else
#
#                                                       render(:update) { |page|
#                                                          if params[:side] == 'front'
#                                                                   page.replace_html 'item_saved_front'  , :partial => 'control_tabs_item_administration/ajax_update_items'  , :locals => {:side => params[:side], :status => "Failed" }
#                                                          else
#                                                                   page.replace_html 'item_saved_back'  , :partial => 'control_tabs_item_administration/ajax_update_items'  , :locals => {:side => params[:side] , :status => "Failed"}
#                                                          end
#                                              }
#                          end
       end
  end
  ###########################################################################################################
def ajax_administer_size_and_position
            Item.unscoped do
                       logger.debug "#########################"
                        logger.debug  params[:front_design_id] == ''
                       logger.debug "#########################"
                          @item = Item.find params[:item_id]
                          if  params[:front_design_id]
                                  @front_design = Item.find params[:front_design_id] unless params[:front_design_id] == ''
                          end
                          if params[:back_design_id]
                                  @back_design = Item.find params[:back_design_id]  unless  params[:back_design_id] == ''
                          end
            end       
                @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design) if @front_design
                 @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design) if @back_design
               render :partial => 'control_tabs_item_administration/ajax_administer_size_and_position'
end
###########################################################################################################
def ajax_administer_edit_item
                  current_website
                  Item.unscoped do
                                  if params[:item_id]
                                            @item = Item.find params[:item_id]
                                  else
                                            @item = Item.find params[:item_id]
                                  end
                  end
#                  @back_design = Item.find params[:design_id]
#                  Item.unscoped do
#                      @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_print_ids
#              end
               render :partial => 'control_tabs_item_administration/ajax_administer_edit_item', :locals => {:side =>  params[:side] }
end
############################################################################################################
  def ajax_administer_crest_print_list
                  @back_design = Item.find params[:back_design_id]
                  Item.unscoped do
                      @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_print_ids
              end
               render :partial => 'control_tabs_item_administration/ajax_administer_crest_print'
end
###########################################################################################################
def ajax_item_details
              logger.debug "params.inspect: " + params.inspect
              @item = Item.find params[:item_id]
              @item_class_components = @item.item_class_component.item_class.all_valid_components
              @selected_item_id = params[:item_id]
              render  :partial => 'designer_specsheet/ajax_item_details'
end
############################################################################################################
def prepare_advanced_combination_variables
                 logger.debug "BEGIN--------------------------------------------------- prepare_combination_variables"
                 logger.debug "BEGIN--------------------------------------------------- prepare_combination_variables"
                 logger.debug "BEGIN--------------------------------------------------- prepare_combination_variables"
                 @front_advanced_combination = AdvancedCombination.find_combo( @item, @front_design)
                 @back_advanced_combination = AdvancedCombination.find_combo( @item, @back_design)
#               if @advanced_combination
#                                 @advanced_combination_front_width     =  @advanced_combination.front_width
#                                  @advanced_combination_front_left      =  @advanced_combination.front_left
#                                  @advanced_combination_front_top       =  @advanced_combination.front_top
#                                  @advanced_combination_back_width =  @advanced_combination.back_width
#                                  @advanced_combination_back_left   =  @advanced_combination.back_left
#                                  @advanced_combination_back_top    =  @advanced_combination.back_top
#                                  @item_prefix_override  =  @advanced_combination.item_prefix_override
#               end
                logger.debug "END--------------------------------------------------- prepare_combination_variables"
                logger.debug "END--------------------------------------------------- prepare_combination_variables"
                logger.debug "END--------------------------------------------------- prepare_combination_variables"
end

  ############################################################################################################
def index_setup_single_all_over_parameter_design
            logger.debug "BEGIN--------------------------------------------------- index_setup_single_all_over_parameter_design"
              @all_over_design = @parameter_item
              @item = Item.find 15245
              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
              @product_mask_image_name =   '/images/item_masks/' + @item.PictureName + '.png'
              @front_design_image_name     =   '/images/item_specsheets/' + @all_over_design.PictureName
              @back_design_image_name     =    '/images/item_specsheets/' + @all_over_design.PictureName.split('.')[0] + '_back.' + @all_over_design.PictureName.split('.')[1]
              @department_choices_background = Department.find_all_by_id( ['36' ]  )
              @department_choices_front =  @website.default_design_departments
              @department_choices_back = @website.default_design_departments
              @department_choices_shirt_style = Department.find_all_by_id(  '26' )
              @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
              @items_front =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
              @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
              @your_unit_price = @item.your_unit_price(@customer,1) if @customer
              @custom_items = CustomItem.find(:all,:conditions => ["thumbnail is null" ] )
              logger.debug "END--------------------------------------------------- index_setup_single_all_over_parameter_design"
  end
  ############################################################################################################

  def view_details_no_purchases_entry_and_incomplete_symbiont
      logger.debug "BEGIN--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
		 @master_purchases_entry = @purchase.master
     if @purchase.symbiote_type == 'master' && @parameter_item
             if @parameter_item.category.category_class.item_type == 'slave'
                     #|||| ITEM FIRST SYMBIONT: #### allows adding the chosen design to the item/design pair
                      #A. master and applicable components and design from params -(how to tell:  @purchase.symbiont_type == 'master' && @parameter_item    )
                      @item = @master_purchases_entry.master_of_symbiont_pair.item
                      @design = @parameter_item  if @purchase.opposite_category_ids.include?(@parameter_item.category.id.to_s)
                      @required_form_elements << 'hidden_design_id_field'   if @design
                    ###sometimes when view details is loaded with a parameter item and this is master symbiote, error occurs..need to redirect
                    	@department = Department.find(@master_purchases_entry.potential_slave_decides_masters_department(@design) )
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
         logger.debug "END--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
end
############################################################################################################
    def item_category_category_class_not_all_over_item
              logger.debug "BEGIN--------------------------------------------------- item_category_category_class_not_all_over_item"
              #set up default specsheet with no inputs
              @all_over_design = Item.find params[:item_id]
              @item = Item.find 15245
              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
              @product_mask_image_name =   '/images/item_masks/' + @item.PictureName + '.png'
              @front_design_image_name     =   '/images/item_specsheets/' + @all_over_design.PictureName
              @back_design_image_name     =    '/images/item_specsheets/' + @all_over_design.PictureName.split('.')[0] + '_back.' + @all_over_design.PictureName.split('.')[1]
              @department_choices_background = Department.find_all_by_id( ['36' ]  )
              @department_choices_front =  @website.default_design_departments
              @department_choices_back = @website.default_design_departments
              @department_choices_shirt_style = Department.find_all_by_id(  '26' )
              @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
              @items_front =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
              @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
              @your_unit_price = @item.your_unit_price(@customer,1) if @customer
              @custom_items = CustomItem.find(:all,:conditions => ["thumbnail is null" ] )
              logger.debug "END--------------------------------------------------- item_category_category_class_not_all_over_item"
  end





def determine_required_form_elements
    @required_form_elements = [ ]
    @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
    @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
    @required_form_elements << 'button_choose'  unless @purchases_entry
    @required_form_elements << 'button_change_size_or_color'  if @purchases_entry
    @required_form_elements << 'icc_collection_select'   if @item_class_components
    @required_form_elements << 'hidden_comment_field'
    @required_form_elements << 'hidden_purchases_entry_id_field'   if  @purchases_entry
end

def update_specsheet
			logger.debug "-------------------------------------begin update_specsheet: #{controller_name}"
			logger.debug "-------------------------------------params: #{params}"
           @item = Item.find(params[:item_id])
			@purchases_entry = PurchasesEntry.find(params[:purchases_entry_id]) if params[:purchases_entry_id]
			if  @purchases_entry && @incomplete_symbiont == true
           		params[:department_id] = @item.default_master_department_id  #new to correct bad department code error
			end
      if params[:design_id]
           if Item.exists?(params[:design_id])
                @design = Item.find(params[:design_id])
            end
      end
      department = Department.find(params[:department_id])

      @specsheet_image = @item.image_url(  department,'item_specsheets/', @design)

                    if @item && @design.nil?
                        if @item.category.category_class.item_type == 'master'
                             @your_unit_price = @item.your_unit_price(@customer,1).to_f + 0.01
                        else
                     		 @your_unit_price = @item.your_unit_price(@customer,1)
            			end
                	end
              prepare_combination_variables(@item,@design)  if @item && @design
              render(:update) { |page|
              page.replace_html 'combo_image', render(:partial => "shared_specsheet/specsheet_image")  if @item && @design
              page.replace_html 'specsheet_image', image_tag(@specsheet_image) if @specsheet_image unless  @item && @design
              page.replace_html 'item_itemlookupcode', @item.ItemLookupCode if @item
              page.replace_html 'item_description', @item.description_before_color_and_size  if @item
              page.replace_html 'design_itemlookupcode', @design.ItemLookupCode          if @design    && @design != 'x'
              page.replace_html 'design_description', @design.Description       if @design    && @design != 'x'
              page.replace_html 'your_unit_price',  @your_unit_price              if  @your_unit_price   unless  @your_unit_price == 0.01
              }
end
############################################################################################################

def update_specsheet_session
               session[:product] = params[:product_id] if params[:product]
               session[:current_design_target] = params[:current_design_target] if params[:current_design_target]
               session[:current_background] = params[:current_background] if params[:current_background]
               session[:current_background_color] = params[:current_background_color] if params[:current_background_color]
               session[:current_front_design_type] = params[:current_front_design_type] if params[:current_front_design_type]
               session[:current_front_design_width] = params[:current_front_design_width] if params[:current_front_design_width]
               session[:current_front_design] = params[:current_front_design] if params[:current_front_design]
               session[:current_back_design_type] = params[:current_back_design_type] if params[:current_back_design_type]
               session[:current_back_design_width] = params[:current_back_design_width] if params[:current_back_design_width]
               session[:current_back_design] = params[:current_back_design] if params[:current_back_design]
end

############################################################################################################
def load_local_browse_variables
		@cached_page = true
		if @department
			@local_department_id = @department.id.to_s
		else
			@local_department_id = '0'
		end

		if @category
			@local_category_id = @category.id.to_s
		else
			@local_category_id = '0'
		end

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
		@fragment_name = @website.name + "/user_type_id/" + @local_user_array_user_type_id + "/shared_item/items/department_id/" + @local_department_id + "/category_id/" + @local_category_id + "/symbiote_item_category_category_class_id/" + @local_purchase_symbiote_item_category_category_class_id  + "/purchase_symbiote_item_shade/" + @local_purchase_symbiote_item_shade
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


def update_specsheet_all_over
			logger.debug "-------------------------------------begin update_specsheet: #{controller_name}"
			logger.debug "-------------------------------------params: #{params}"
           @item = Item.find(params[:item_id])
           # @purchases_entry = PurchasesEntry.find(params[:purchases_entry_id]) if params[:purchases_entry_id]
             @your_unit_price = @item.your_unit_price(@customer,1)
              render(:update) { |page|
              page.replace_html 'item_itemlookupcode', @item.ItemLookupCode if @item
              page.replace_html 'item_description', @item.description_before_color_and_size  if @item
              page.replace_html 'your_unit_price',  @your_unit_price              if  @your_unit_price   unless  @your_unit_price == 0.01
#               page[:product].value =   '/images/item_masks/' +  @item.PictureName + '.png'
              }
end
############################################################################################################

def specsheet_item_search
      ## @website_items and the others are cached collections of all items for each website created at: lib/startup_browsing - startup_specific_items
      startup_specific_items
      item_search_with_rank(@all_websites_all_items, params[:item_keywords])
      @items = @items.paginate(  :per_page => @@category_items_per_page, :page => params[:page] )
      @items_background = @items
      @items_front = @items
      @items_back = @items
      @items_shirt_style = @items
      render(:update) { |page|
               page.replace_html 'category_items_' + params[:choice_type] , :partial => 'designer_specsheet/category_items' , :object => @items, :locals => { :choice_type =>  params[:choice_type] }
      }
      #render :partial => "specsheet_advanced/category_items" ,:layout => 'none', :object => @items , :locals => { :choice_type =>  params[:choice_type] }
end


 def update_custom_items ## this needs pagination..
          @custom_items = CustomItem.find(:all, :conditions => ['thumbnail = ?', 'relational'    ])
          render :update do |page|
            page.replace_html 'custom_items', :partial => 'designer_specsheet/custom_items' , :object => @custom_items
          end
  end







def view_details_purchases_entry_and_not_incomplete_symbiont
      logger.debug "***********************************************************************************"
      logger.debug "***********************************************************************************"
      logger.debug "***********************************************************************************"
      logger.debug "***********************************************************************************"
      logger.debug "BEGIN--------------------------------------------------- view_details_purchases_entry_and_not_incomplete_symbiont"
			logger.debug "ssees-------------------------------------@purchases_entry.symbiotic_item: #{@purchases_entry.symbiotic_item}"
			logger.debug "asdww-------------------------------------@singular_item_customer: #{@singular_item_customer}"
      if @purchases_entry.symbiotic_item == true &&  @singular_item_customer == false
      	   logger.debug "vvsa-------------------------------------purchase-with-complete-symbiont"
            @item = @purchases_entry.master_of_symbiont_pair.item
            @design = @purchases_entry.slave_of_symbiont_pair.item
            logger.debug "sssd-------------------------------------@item.id: #{@item.id}" if @item
            logger.debug "seesa-------------------------------------@design.id: #{@design.id}" if @design
            prepare_combination_variables(@item, @design) if @item && @design
            @item_class_components =  @purchases_entry.slave_of_symbiont_pair.slaves_item_class_components_decision
            @department  =  Department.find(@purchases_entry.master_department_id)
            @required_form_elements << 'hidden_department_id_field'
            @required_form_elements << 'button_change_size_or_color'
            @required_form_elements << 'icc_collection_select'  if   @item_class_components
            @required_form_elements << 'hidden_item_id_field' unless @item_class_components
            @selected_item_id  =  @purchases_entry.master_of_symbiont_pair.item_id if @item.item_class_component
            @required_form_elements << 'hidden_purchases_entry_id_field'   if  @purchases_entry
            #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select or hidden field if unavailable
      elsif @purchases_entry.symbiotic_item == true &&  @singular_item_customer == true
            logger.debug "asdvvaaz ------------------------------------- @purchases_entry.symbiotic_item == true &&  @singular_item_customer == true "
            if @item = @purchases_entry.item.category.category_class.item_type  == 'master'
                   logger.debug "weeeaas ------------------------------------- @purchase.symbiote_type == 'master'  "
                   @item = @purchases_entry.item
                   @item_class_components = @item.item_class_component.item_class.item_class_components if @item.item_class_component
                   @department  =  Department.find(@purchases_entry.item.default_master_department_id)
                   @required_form_elements << 'hidden_department_id_field'
                   @required_form_elements << 'button_change_size_or_color'
                   @required_form_elements << 'icc_collection_select'  if   @item_class_components
                   @required_form_elements << 'hidden_item_id_field' unless @item_class_components
                   @selected_item_id  =  @purchases_entry.item_id if @item.item_class_component
                   @required_form_elements << 'hidden_purchases_entry_id_field'   if  @purchases_entry
                   #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select if available otherwise hidden field
            else
                  logger.debug "vvccxxa ------------------------------------- @purchase.symbiote_type != 'master'  "
                  @item = @purchases_entry.item
            end

     else
           logger.debug "eeasd ------------------------------------- @purchases_entry.symbiotic_item != true or  @singular_item_customer != false "
           @item = @purchases_entry.item   ### just added form elements as needed #########################################################################
           @item_class_components = @item.item_class_component.item_class.item_class_components if @item.item_class_component
           @department  =  Department.find(@purchases_entry.item.default_master_department_id)
           @required_form_elements << 'hidden_department_id_field'
           @required_form_elements << 'button_change_size_or_color'
           @required_form_elements << 'icc_collection_select'  if   @item_class_components
           @required_form_elements << 'hidden_item_id_field' unless @item_class_components
           @selected_item_id  =  @purchases_entry.item_id if @item.item_class_component
           @required_form_elements << 'hidden_purchases_entry_id_field'   if  @purchases_entry
           #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select if available otherwise hidden field
    end
     logger.debug "END--------------------------------------------------- view_details_purchases_entry_and_not_incomplete_symbiont"
      logger.debug "***********************************************************************************"
      logger.debug "***********************************************************************************"
      logger.debug "***********************************************************************************"
      logger.debug "***********************************************************************************"
end
############################################################################################################
def view_details_purchases_entry_and_incomplete_symbiont
       logger.debug "BEGIN--------------------------------------------------- view_details_purchases_entry_and_incomplete_symbiont"
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
         logger.debug "END--------------------------------------------------- view_details_purchases_entry_and_incomplete_symbiont"
end
############################################################################################################
def view_details_no_purchases_entry_and_incomplete_symbiont
    logger.debug "BEGIN--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
    logger.debug "BEGIN--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
    logger.debug "BEGIN--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
    logger.debug "BEGIN--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
		 @master_purchases_entry = @purchase.master
     if @purchase.symbiote_type == 'master' && @parameter_item
             if @parameter_item.category.category_class.item_type == 'slave'
                                 #|||| ITEM FIRST SYMBIONT: #### allows adding the chosen design to the item/design pair
                                  #A. master and applicable components and design from params -(how to tell:  @purchase.symbiont_type == 'master' && @parameter_item    )
                                  @item = @master_purchases_entry.master_of_symbiont_pair.item
                                  @design = @parameter_item  if @purchase.opposite_category_ids.include?(@parameter_item.category.id.to_s)
                                  @required_form_elements << 'hidden_design_id_field'   if @design
                                  ###sometimes when view details is loaded with a parameter item and this is master symbiote, error occurs..need to redirect
                                  @department = Department.find(@master_purchases_entry.potential_slave_decides_masters_department(@design) )
                                  @notes << 'potential slave decided masters department'
                                  @required_form_elements << 'button_choose_this_design'
                                   #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => @design.id
                                    prepare_advanced_combination_variables
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
                                     prepare_advanced_combination_variables
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
                                        #@required_form_elements << 'hidden_item_id_field'
                                       @required_form_elements << 'hidden_department_id_field'
                           end
                      end

                  @selected_item_id = @item.id if @item
                   #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select, or if unavailable, from hidden form field
        end
        logger.debug "END--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
        logger.debug "END--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
        logger.debug "END--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
        logger.debug "END--------------------------------------------------- view_details_no_purchases_entry_and_incomplete_symbiont"
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
def setup_auto_opposites_status_for_view_details
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
        logger.debug "BEGIN--------------------------------------------------- view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont"
        @item = @parameter_item.default_opposite_item
        @design = @parameter_item
        @required_form_elements << 'hidden_design_id_field'   if @design
        @required_form_elements << 'hidden_item_id_field'   if @item
        @required_form_elements << 'hidden_add_combo_field'   if @item and @design
      	@department = @item.department
        @notes << 'view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont-@item.department-'
        @required_form_elements << 'button_choose'
         logger.debug "END--------------------------------------------------- view_details_automatic_opposites_parameter_item_and_no_incomplete_symbiont"
end
############################################################################################################
def  prepare_preload_images_for_view_details(item_class_components,department,item_prefix_override)
	 @preload_images_array = []
		for icc in item_class_components
			 @preload_images_array <<      icc.item.image_url( department  , '/images/item_specsheets/', 'x' ,item_prefix_override )
		end
				@preload_images_array = @preload_images_array.uniq
				@preload_images_array = @preload_images_array.join("','")
				return @preload_images_array =      '\'' +    @preload_images_array.to_s +  '\''
end
###########################################################################################################
def update_specsheet_for_view_details
			logger.debug "-------------------------------------begin update_specsheet_for_view_details: #{controller_name}"
			logger.debug "-------------------------------------params: #{params}"
           @item = Item.find(params[:item_id])
			@purchases_entry = PurchasesEntry.find(params[:purchases_entry_id]) if params[:purchases_entry_id]
			if  @purchases_entry && @incomplete_symbiont == true
           		params[:department_id] = @item.default_master_department_id  #new to correct bad department code error
			end
           if Item.exists?(params[:design_id])
                @design = Item.find(params[:design_id])
            end
      department = Department.find(params[:department_id])

      @specsheet_image = @item.image_url(  department,'item_specsheets/', @design)

                    if @item && @design.nil?
                        if @item.category.category_class.item_type == 'master'
                             @your_unit_price = @item.your_unit_price(@customer,1).to_f + 0.01
                        else
                     		 @your_unit_price = @item.your_unit_price(@customer,1)
            			end
                	end
              prepare_combination_variables(@item,@design)  if @item && @design
              render(:update) { |page|
              page.replace_html 'combo_image', render(:partial => "shared_specsheet/specsheet_image")  if @item && @design
              page.replace_html 'specsheet_image', image_tag(@specsheet_image) if @specsheet_image unless  @item && @design
              page.replace_html 'item_itemlookupcode', @item.ItemLookupCode if @item
              page.replace_html 'item_description', @item.description_before_color_and_size  if @item
              page.replace_html 'design_itemlookupcode', @design.ItemLookupCode          if @design    && @design != 'x'
              page.replace_html 'design_description', @design.Description       if @design    && @design != 'x'
              page.replace_html 'your_unit_price',  @your_unit_price              if  @your_unit_price   unless  @your_unit_price == 0.01
              }
end



#def designer_specsheet_parameter_item_and_no_incomplete_symbiont_deprecate
#              logger.debug "BEGIN--------------------------------------------------- view_details_parameter_item_and_no_incomplete_symbiont"
#              logger.debug "###################################################"
#              logger.debug "###################################################"
#              logger.debug "###################################################"
#              logger.debug "###################################################"
#              logger.debug "###################################################"
#              @show_designer_specsheet = true
#              @all_over_design = Item.find   19765
#              @back_design = Item.find params[:item_id]
#               @breast_print_name = Slug.generate(@back_design.department.Name) + '.png'
#              @item = Item.find 15245
#              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
#              @product_mask_image_name =   '/images/item_masks/' + @item.PictureName + '.png'
#              @front_design_image_name     =   '/images/crest_print/' + @breast_print_name
#              @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
#              @department_choices_background = Department.find_all_by_id( ['36' ]  )
#              @department_choices_front =  @website.default_design_departments
#              @department_choices_back = @website.default_design_departments
#              @department_choices_shirt_style = Department.find_all_by_id(  '26' )
#              @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
#              @items_front =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
#              @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
#              @your_unit_price = @item.your_unit_price(@customer,1) if @customer
#              @custom_items = CustomItem.find(:all,:conditions => ["thumbnail is null" ] )
#              logger.debug "###################################################"
#              logger.debug "###################################################"
#              logger.debug "###################################################"
#              logger.debug "###################################################"
#              logger.debug "###################################################"
#              logger.debug "END--------------------------------------------------- view_details_parameter_item_and_no_incomplete_symbiont"
#end
#############################################################################################################

##############################################  DEPRECATE BELOW ########################################
#  def index_before
#      if params[:item_id]
#            @item = Item.find params[:item_id]
#      else
#            @item = Item.find 15245
#      end
#      @notes = []
#      @purchases_entry = @purchase.purchases_entries.find( params[:purchases_entry_id] )         if params[:purchases_entry_id]
#      @parameter_item = Item.find(params[:item_id]) if params[:item_id]
#      @parameter_item_type = @parameter_item.category.category_class.item_type  if @parameter_item
#
#      @front_design_image_name     =   '/custom_items/thumbnail/' + CustomItem.find( session[:current_front_design] ||  68 ).thumbnail_name_for('relational')
#      @back_design_image_name     =   '/custom_items/thumbnail/' + CustomItem.find( session[:current_back_design] ||  68  ).thumbnail_name_for('relational')
#      @product_mask_image_name =   '/images/item_masks/' + @item.PictureName + '.png'
#      @custom_items = CustomItem.find(:all,:conditions => ["thumbnail is null" ] )
#      #      @department = Department.find_by_id( params[:department_id] ) if params[:department_id]
#      #       @categories = @department.categories if @department
#      @department_choices_background = Department.find_all_by_id( ['36' ]  )
#      @department_choices_front =  @website.default_design_departments
#      @department_choices_back = @website.default_design_departments
#      @department_choices_shirt_style = Department.find_all_by_id(  '26' )
#      @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
#      @items_front =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
#      @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
#      @your_unit_price = @item.your_unit_price(@customer,1)
#      determine_required_form_elements
#  end
#############################################################################################################


#
#
#def junk
#    @front_design_image_name     =   '/custom_items/thumbnail/' + CustomItem.find( params[:custom_item_id] ).thumbnail_name_for('relational')
#    @rear_design_image_name     # @item.image_url(@item.department_id, directory='/images/item_specsheets/',design='x',item_prefix_override="0" )
#    @back_design_image_name     =   '/custom_items/thumbnail/' + CustomItem.find( params[:custom_item_id] ).thumbnail_name_for('relational')
#    @all_over_item_mask_image_name = '/images/item_masks/all-over-front-mask.png'
#        @items_shirt_style =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['department_id like ? and category_id like ?', '26', '681'  ]  , :order => 'ItemLookupCode'
#        @items_shirt_styles_all =  Item.find(:all,  :conditions => ['department_id like ? and category_id like ?', '2', '516'  ] )
#end


#  def update_current_design
#     if  !params[:current_design_selector]
#                if params[:custom_item_id]
#                              flash[:notice] = "session[:current_front_design] was set to #{params[:custom_item_id]} since current_design_selector was not provided."
#                           session[:current_front_design] = params[:custom_item_id]
#                else
#                             flash[:notice] = "session[:current_front_design] was set to 59 since current_design_selector and cutom_item_id was not provided."
#                             session[:current_front_design] = 59 unless session[:current_front_design]
#                end
#     else
#                            if params[:current_design_selector] == 'front_design'
#                                      if  params[:custom_item_id]
#                                                flash[:notice] = "session[:current_front_design] set to : #{params[:custom_item_id]}"
#                                                session[:current_front_design] = params[:custom_item_id]
#                                      else
#                                                session[:current_front_design] = 59 unless session[:current_front_design]
#                                      end
#                            else
#                                  session[:current_front_design] = 59 unless session[:current_front_design]
#                            end
#
#
#                        if  params[:current_design_selector] == 'back_design'
#                                      if  params[:custom_item_id]
#                                                 flash[:notice] = "session[:current_back_design] set to : #{params[:custom_item_id]}"
#                                                session[:current_back_design] = params[:custom_item_id]
#                                      else
#                                                session[:current_back_design] = 59 unless session[:current_back_design]
#                                      end
#                            else
#                                  session[:current_back_design] = 59  unless session[:current_back_design]
#                            end
#                  end
#        end



# def ajax_update_item_detail_thumbnail
##             render  :text => "<div class='test'>the item_id #{params[:item_id]}</div>"
#            @item = Item.find params[:item_id]
#              @item_class_components = @item.item_class_component.item_class.all_valid_components
#
#
#              render  :partial => 'designer_specsheet/ajax_item_details'
#
# end


            #A. item getting item and item_class_component info if applicable
#            @item = @parameter_item
#            @selected_item_id  =  @parameter_item.id
#            @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
#            @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
#            @required_form_elements << 'button_choose'  unless @purchases_entry
#            @required_form_elements << 'icc_collection_select'   if @item_class_components
#            @required_form_elements << 'hidden_department_id_field'
#            if @item.category.use_generic_department == '1'
#                     @department = @item.department
#                    logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.department"
#           end
#               if !@department
#                            if  @item.category.category_class.item_type == 'master'
#                                          @temp_department = @item.default_master_department_id
#                                          @department = Department.find @temp_department
#                                        logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY---------------@department = @item.default_master_department_id "
#                          else
#                                    logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT--SET BY-----SKIPPED BECAUSE (NOT) @item.category.category_class.item_type != 'master' "
#                          end
#                 end

#              render(:update) { |page|
#                                   page.replace_html 'mask_image'  , :text => "test"    # :partial => 'designer_specsheet/ajax_mask_image'
#              }


#              render(:update) { |page|
#                                   page.replace_html 'item_details_container'  , :partial => 'designer_specsheet/ajax_item_details'
#              }
#   render  :text => "<div class='test'>item_id: #{params[:item_id]}</div>"
 #   render  :partial => 'designer_specsheet/category_items'  , :locals => { :choice_type =>  params[:choice_type] }

#              render  :js =>  " $('mask_image').src = '/images/item_masks/' +  @item.PictureName + '.png'"
#              render :js  => "ajax_change_product_choice"

#              @items_shirt_style = Rails.cache.read 'find_first_of_each_type_of_applicable_opposite_category_class_id_' + @all_over_design.category.category_class_id.to_s
#              if @items_shirt_style
#                      logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#                       logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#                        logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#                         logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#              else
#                      logger.debug "ERROR - FAILED TO FIND @ITEMS_SHIRT_STYLE USING CACHE"
#                      @items_shirt_style =  @all_over_design.find_first_of_each_type_of_applicable_opposite               #@all_over_design.find_first_icc_from_each_category_of_applicable_opposites_in_departments( @all_over_design.opposite_department_ids )
#
#                      Rails.cache.write 'find_first_of_each_type_of_applicable_opposite_category_class_id_' + @all_over_design.category.category_class_id.to_s , @items_shirt_style
#              end

#              @items_shirt_style = Rails.cache.read 'TEST_READ'
#              if @items_shirt_style
#                      logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#                       logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#                        logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#                         logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#              else
#                      logger.debug "ERROR - FAILED TO FIND @ITEMS_SHIRT_STYLE USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @all_over_design.category.category_class_id.to_s
#                      @items_shirt_style =  '@all_over_design.TEST STRING FOUND'
#
#                      Rails.cache.write  'TEST_READ'  , @items_shirt_style
#              end

#                          @opposites_to_present = @design.opposite_representatives_sorted_by_sales.where("category_id = ?", params[:current_category_id] )
#                          logger.debug "@design.ItemLookupCode : " + @design.ItemLookupCode
#                          logger.debug "design.category_id : " + @design.category_id.to_s
#                          logger.debug "opposites_to_present.size : " + @opposites_to_present.size.to_s
#                         @items =  @opposites_to_present.paginate :per_page => @@category_items_per_page, :page => params[:page]

#              @main_design = Item.find params[:main_design_id]
#                 prepare_combination_variables(@item,@main_design)

#              @main_design = Item.find params[:main_design_id]
#                 prepare_combination_variables(@item,@main_design)

#              @items_shirt_style =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => [ 'category_id in (?)', [ '491', '507']  ]  , :order => 'ItemLookupCode'





#def view_details_parameter_item_and_no_incomplete_symbiont
#           logger.debug "BEGIN--------------------------------------------------- view_details_parameter_item_and_no_incomplete_symbiont"
#            #SINGULAR||||||||||||||||||||||||||||||||||||||||||
#            logger.debug "VIEW_DETAILS-SINGULAR-------------------------@parameter_item && @incomplete_symbiont == false"
#
#              @back_design = Item.find   params[:item_id]
#             Item.unscoped do
#                            @items_front =         @back_design.find_applicable_crest_print.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
#             end
#              @front_design =  @items_front.first
#              @front_design_id = @front_design.id
#              @front_design_name = @front_design.ItemLookupCode + '.png'
#              Item.unscoped do
#                      @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_print_ids
#              end
#              @item = Item.find 82
#
#                  @front_advanced_combination = AdvancedCombination.find_combo( @item, @front_design)
#                 @back_advanced_combination = AdvancedCombination.find_combo( @item, @back_design)
#
##              @front_design_name = Slug.generate(@back_design.department.Name) + '.png'
##              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
#              @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
#              @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
#              @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
#              @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
#              ##########  DEPARTMENT CHOICES
#              @department_choices_background = Department.find_all_by_id( ['36' ]  )
#              @department_choices_front =    @website.default_design_departments   #@back_design.breast_print_department_records
#              @department_choices_back = @website.default_design_departments
#              @department_choices_shirt_style = @back_design.opposite_departments
#              @items_shirt_style = Rails.cache.read 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
#              if @items_shirt_style
#                        logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#                        logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#                        logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#                        logger.debug "FOUND @ITEMS_SHIRT_STYLE USING CACHE"
#              else
#                      logger.debug "ERROR - FAILED TO FIND @ITEMS_SHIRT_STYLE USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
#                      @items_shirt_style =  @back_design.opposite_representatives_sorted_by_sales
#                      Rails.cache.write  'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s  , @items_shirt_style
#              end
#              @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
#
#              @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'   #@back_design.category_id
#
#             @items_shirt_style =  @items_shirt_style.to_a.paginate :per_page => @@category_items_per_page, :page => params[:page]    , :order => 'ItemLookupCode'
#              @your_unit_price = @item.your_unit_price(@customer,1) if @customer
#              if @user
#                      @custom_items = @user.custom_items.order("id DESC").find(:all,:conditions => ["thumbnail is null" ] )
#              else
#                      @custom_items = CustomItem.sample_customs   # .limit("5").where("thumbnail is null")
#              end
#            logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department
#            logger.debug "END--------------------------------------------------- view_details_parameter_item_and_no_incomplete_symbiont"
#end
##############################################################################################################

#        if params[:choice_type] == 'shirt_style'
#              @opposites_to_present = Rails.cache.read  'opposites_to_present_in_category_'    +  params[:current_category_id]
#                if @opposites_to_present
#                           logger.debug "CACHE FOUND @opposites_to_present "
#                else
#                           logger.debug "CACHE MISS @opposites_to_present "
#                           @design =  Item.find( params[:design_id] )   #.items.first         #Item.find params[:item_id]
#                           @opposites_to_present = @design.find_first_of_each_type_of_applicable_opposite_in_category( params[:current_category_id] ).flatten
#                           Rails.cache.write  'opposites_to_present_in_category_'   +  params[:current_category_id]  , @opposites_to_present
#                end
#              @items =  @opposites_to_present.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', params[:current_category_id]  ]  , :order => 'ItemLookupCode'
#        else
#               @items =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', params[:current_category_id]  ]  , :order => 'ItemLookupCode'
#        end
#
#         @items_background = @items
#         @items_front = @items
#         @items_back = @items
#         @items_shirt_style = @items
#          @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
#         if  params[:page]
#              render(:update) { |page|
#                                   page.replace_html 'category_items_' + params[:choice_type] , :partial => 'designer_specsheet/ajax_category_items' , :object => @items, :locals => { :choice_type =>  params[:choice_type] }
#              }
#         else
#            render(:update) { |page|
#                                   render  :partial => 'designer_specsheet/select_list_update_category'  , :locals => { :choice_type =>  params[:choice_type] }
                                   # page.replace_html 'category_items_' + params[:choice_type] , :partial => 'designer_specsheet/category_items' , :locals => { :choice_type =>  params[:choice_type] }
#              }
#         end




#  def ajax_change_product_choice
#      Item.unscoped do
#              @item = Item.find  params[:item_id]
#               @front_design = Item.find params[:front_design_id] unless params[:front_design_id] == ""
#               @back_design = Item.find params[:back_design_id] unless params[:back_design_id] == ""
#               @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)  if @back_design
#               @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)   if @front_design
##       @back_design.category.category_class.item_type == 'all_over_design'
#
#              if @back_design.is_breast_print?
#                                    logger.debug " @back_design.is_breast_print? "
#                                   if @item.is_applicable_with?( @front_design )
#                                                logger.debug " @item.is_applicable_with?( @front ) "
#
#                                   else
#                                                 logger.debug " NOT  @item.is_applicable_with?( @front ) "
#
#                                   end
#              elsif @front_design.is_breast_print?
#                                     logger.debug " @front_design.is_breast_print?"
#                                     if @item.is_applicable_with?( @back_design )
#                                                  logger.debug " @item.is_applicable_with?( @back ) "
#
#                                     else
#                                                   logger.debug " NOT  @item.is_applicable_with?( @back ) "
#                                                   @back_design = Rails.cache.read "most_popular_compatible_opposite_for_category_id_" + @item.category_id.to_s
#                                                   if @back_design
#                                                                   logger.debug "most_popular_compatible_opposite read from cache"
#                                                   else
#                                                                  @back_design = @item.most_popular_compatible_opposite
#                                                                  Rails.cache.write "most_popular_compatible_opposite_for_category_id_" + @item.category_id.to_s,  @back_design
#                                                   end
#                                     end
#              elsif      @back_design.category.category_class.item_type == 'all_over_design'
#                                logger.debug " @back_design.category.category_class.item_type == all_over_design"
#                                     if @item.is_applicable_with?( @back_design )
#                                                  logger.debug " @item.is_applicable_with?( @back ) "
#
#                                     else
#                                                   logger.debug " NOT  @item.is_applicable_with?( @back ) "
#                                                   @back_design = Rails.cache.read "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s
#                                                   if @back_design
#                                                                   logger.debug "most_popular_compatible_opposite read from cache"
#                                                   else
#                                                                  @back_design = @item.most_popular_compatible_opposite
#                                                                  Rails.cache.write "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s,  @back_design
#                                                   end
#                                     end
#              else
#                                logger.debug " NEITHER @front_design.is_breast_print? OR @back_design.is_breast_print? or @back_design.category.category_class.item_type == all_over_design "
#
#              end
#
#                      @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
#                      @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
#      end
#               respond_to do |format|
#                          format.js {render :content_type => 'text/javascript'}
#               end
# end
############################################################################################################









end
