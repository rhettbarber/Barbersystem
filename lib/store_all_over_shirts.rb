module StoreAllOverShirts

# composite -gravity center 6727_o_rp.png -geometry 5000x5000 11085-REBEL_front.jpg  compose_over.png // standard web size relation to 240x240

@@category_items_per_page = 12
@@choice_types = ['background', 'front', 'back', 'shirt_style']

  def compose_production_strings_experimental
        @front_print_production_string = 'composite -gravity center 6727_o_rp.png -geometry 5000x5000 11085-REBEL_front.jpg  compose_over.png'
        @back_print_production_string = 'composite -gravity center 6727_o_rp.png -geometry 5000x5000 11085-REBEL_front.jpg  compose_over.png'

  end

  def find_design_choices
        #list all design departments #667 is the category id for Backgrounds -> dixie
        @department_choices_background = Department.find_all_by_id( ['36' ]  )
        @department_choices_front =  @website.default_design_departments
        @department_choices_back = @website.default_design_departments
        @department_choices_shirt_style = Department.find_all_by_id( ['37' ]  )
        #list all design categories
        #list all designs
        #list background items
        #list front items
        #list back images
        #lsit shirt chices

    @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
    @items_front =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @item.category_id ]  , :order => 'ItemLookupCode'
    @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @item.category_id ]  , :order => 'ItemLookupCode'
    @items_shirt_style =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @item.category_id ]  , :order => 'ItemLookupCode'

#        if @item
#                @items =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @item.category_id ]  , :order => 'ItemLookupCode'
#        else
#                @items =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', params[:category_id]  ]  , :order => 'ItemLookupCode'
#        end
#        @back_designs = @items
end

  def update_category_select_list
    update_category_display
#    department = Department.find(params[:department_id])
#    @categories  = department.categories
#    render :update do |page|
#        page.replace_html 'categories', :partial => 'shared_specsheet_advanced/category_select', :object => @categories
#    end
  end

    def update_category_display
      find_design_choices
    @current_category_id = params[:category_id]
    @department = Department.find(params[:department_id])
    @categories  = @department.categories
    conditions = ['category_id like ?', params[:category_id] ]
    @items =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => conditions  , :order => 'ItemLookupCode'
    render :update do |page|
      page.replace_html 'search_results_front_design', :partial => 'shared_specsheet_advanced/search_results_front_design' , :object => @items
    end
  end


def advanced_form_data
    @required_form_elements = [ ]
    @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
    @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
    @required_form_elements << 'button_choose'  unless @purchases_entry
    @required_form_elements << 'button_change_size_or_color'  if @purchases_entry
    @required_form_elements << 'icc_collection_select'   if @item_class_components
    @required_form_elements << 'hidden_comment_field'
    @required_form_elements << 'hidden_purchases_entry_id_field'   if  @purchases_entry
end

def find_main_design
         @purchases_entry = @purchase.purchases_entries.find( params[:purchases_entry_id] )         if params[:purchases_entry_id]
         @parameter_item = Item.find(params[:item_id]) if params[:item_id]
         @parameter_item_type = @parameter_item.category.category_class.item_type  if @parameter_item
      if @parameter_item
             @item = @parameter_item
             @selected_item_id  =  @parameter_item.id
             @background_url =  "/images/item_backgrounds/solid-rebel-flag-background.png"
    else
            @item = @purchases_entry.item
            @selected_item_id  =  @item.id

    end
end

def determine_background
        if @parameter_item
                     @background_url =  "/images/item_backgrounds/solid-rebel-flag-background.png"
        else
                    @background = Background.find( @purchases_entry.background_number  )
                    if @background
                            @background_url = @background.image_url
                    else
                           @background_url =  "/images/item_backgrounds/solid-rebel-flag-background.png"
                    end
        end
        @backgrounds = Background.paginate :page => params[:page], :order => 'created_at DESC' , :per_page => @@category_items_per_page
end




















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
              }
end
############################################################################################################





























def view_details_all_over_shirts_before
    logger.debug "VIEW_DETAILS_ALL_OVER_SHIRTS-------------------------@parameter_item && @incomplete_symbiont == false"
    if @parameter_item
             @item = @parameter_item
             @selected_item_id  =  @parameter_item.id
             @background_url =  "/images/item_backgrounds/solid-rebel-flag-background.png"
    else
              @item = @purchases_entry.item
              @selected_item_id  =  @item.id
            logger.warn "********************************************************"
            logger.warn "********************************************************"
            logger.warn "********************************************************"
            logger.warn "#{ @purchases_entry.background_number}"
            logger.warn "********************************************************"
            logger.warn "********************************************************"
            logger.warn "********************************************************"
            logger.warn "********************************************************"
            @background = Background.find( @purchases_entry.background_number  )
            if @background
                    @background_url = @background.image_url
            else
                   @background_url =  "/images/item_backgrounds/solid-rebel-flag-background.png"
            end
    end
    @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
    @required_form_elements << 'hidden_item_id_field'   if @item unless @item_class_components
    @required_form_elements << 'button_choose'  unless @purchases_entry
    @required_form_elements << 'button_change_size_or_color'  if @purchases_entry
    @required_form_elements << 'icc_collection_select'   if @item_class_components
    @required_form_elements << 'hidden_comment_field'
    @required_form_elements << 'hidden_purchases_entry_id_field'   if  @purchases_entry
     #@backgrounds = Background.find_all_by_category_id( @item.category_id )
     @backgrounds = Background.paginate :page => params[:page], :order => 'created_at DESC' , :per_page => 3
      respond_to do |format|
          format.html {
             render(:partial => "shared_specsheet_all_over/specsheet",:locals => {:item => @item,  :department => @department  ,:design => @design }, :layout => controller_name  )
          }
          format.js {
            render :update do |page|
              page.replace 'results', :partial => 'backgrounds/search_results'
            end
          }
      end
  logger.debug "VIEW_DETAILS_ALL_OVER_SHIRTS-------------------------"
end









end