class StoreController < ApplicationController
#before_filter :initialize_variables, :only => [ :ajax_browse, :browse, :design_department_select, :select_department ]
#before_filter :browse_startup, :only => [  :browse ]
before_filter  :initialize_variables  , :only => [ :sale_designs,  :new_designs, :category_items, :category_items_menu    ]

skip_before_filter :verify_authenticity_token  #, :only => [:update_specsheet,:update_advanced_combination ]
#http://192.168.0.125:3006/store/specsheet?item_type=slave&item_id=3725&department_id=10#
#http://192.168.0.125:3006/store/specsheet?item_type=slave&item_id=3725&department_id=10#

layout 'application', :except => [ :items_menu    ]
layout 'none', :only => [ :close_window   ]

#caches_public_page :items_menu
caches_public_page :category_items
caches_public_page :category_items_menu


############################################################################################################
def close_window
        #render  'store/close_window.js'

end
############################################################################################################
 def category_items_menu

 end
############################################################################################################
  def items_menu
                current_website
                startup_customer
                startup_purchase
                startup_symbiont

                render  'store/items_menu.js'
  end
############################################################################################################
  def category_items
                  logger.debug "begin category_items"
                  #@department = Department.order("departments.Name ASC" ).includes(:categories).where( "departments.id = ? and categories.visible = ?",  params[:department_id], true ).first
                  #@category =   Category.find  params[:category_id]       if  params[:category_id]
                  #logger.debug "@category.inspect: " + @category.inspect
                  #@items = Item.includes(:item_class_component, :item_sales_last_year, :category, :item_sales_this_year, :item_class_sales_this_years_with_item_id).where( "category_id = ? or category_id in (?) and Inactive != -1 ", @category , @category.additive_category_ids_split )    if  @category
                  @items = Item.includes(:item_class_component,  :category).where( "category_id = ? or category_id in (?) ", @category , @category.additive_category_ids_split )    if  @category

                  logger.debug "end category_items"
                  #render layout: false
  end
############################################################################################################
  def update_advanced_combination
                  @advanced_combination = AdvancedCombination.find(params[:id])
                  @advanced_combination = AdvancedCombination.new(params[:advanced_combination]) unless @advanced_combination   if admin?

                  if @advanced_combination.update_attributes( params[:advanced_combination]   )
                                  logger.debug "great, updated combination"
                                  @updated = true
                  else
                                  @updated = false
                                  logger.debug "failed to updated combination"
                  end
  end
 ############################################################################################################
  def new_designs

              @new_designs ||= Item.limit(55).order("DateCreated DESC").where("department_id in (?) and category_id NOT in (?)", @website.default_design_department_ids.split(/,/)  , @website.breast_print_category_ids      ).all


              unless @new_designs
                            logger.warn "NO ITEMS FOUND ON index ACTION !!!!"
              else
                            logger.warn "@new_designs.size: #{@new_designs.size}"
                            #FMCache.write  new_designs_cache_string ,   @items
              end

                @items   = @new_designs


                # #new_designs_cache_string = "records_" + @website.name +  "_new_designs_week_" +  Website.week_number
                # #logger.debug "new_designs_cache_string: " + new_designs_cache_string
                # #@items = FMCache.read new_designs_cache_string
                # @new_designs  ||= Item.limit(50).order("DateCreated DESC").where("department_id in (?)", @website.default_design_department_ids.split(/,/) )
                # unless @new_designs
                #               logger.warn "NO ITEMS FOUND ON NEW DESIGNS ACTION !!!!"
                # else
                #               logger.warn "@items.size: #{@new_designs.size}"
                #               #FMCache.write  new_designs_cache_string ,   @items
                # end
  end
  ############################################################################################################
  def sale_designs
                    #  THIS IS FRAGMENT CACHED USING STRING :  @sale_designs_cache_name
                    sale_designs_cache_string =     "view_" + @website.name +  "_sales_designs_week_" +  Website.week_number
                    @initial_items = Caching::MemoryCache.instance.read  sale_designs_cache_string

                   if @initial_items
                                  logger.debug "@initial_items FOUND BY CACHE"
                   else
                                  @initial_items ||= Item.includes(:category).order("DateCreated DESC").where("department_id in (?) and SaleType != ?", @website.default_design_department_ids.split(/,/) ,  '0'    )
                                  Caching::MemoryCache.instance.write sale_designs_cache_string , @initial_items
                                   logger.debug "@initial_items NOT FOUND BY CACHE"
                   end
                    @paginated_results  =  @initial_items.to_a.paginate(:page => params[:page], :per_page => 6  )
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





#
#  def department_category_list
#    current_website
#    if params[:department_id] and params[:category_id]
#      @department = Department.order("departments.Name ASC" ).includes(:categories).where( "departments.id = ? and categories.visible = ?",  params[:department_id], true )
#      @category =    params[:category_id]
#    else
#      if params[:item_type] == 'item'
#        @departments = @website.default_item_departments
#      else
#        @departments = @website.default_design_departments
#      end
#    end
#
#    #render layout: false
#  end
#
#
#
#
#
#
#
#
#
#
#  def browse
#    if !@department && !@category
#      aa
#      browse_not_department_not_category
#    elsif  @department && !@category
#      bb
#      browse_department_not_category
#    elsif  @department && @category
#      #if params[:applicable] == '0'
#      show_items
#      #else
#      #        show_applicable_items_only_off
#      #end
#    elsif  @department && @category
#      d
#      browse_department_category_incomplete_symbiont
#    else
#      e
#      logger.debug "BROWSE 6-------------------------------------final else"
#      flash[:notice] = "browse error 701"
#      #redirect_to(:controller => 'browse', :action => 'index')
#    end
#    render layout: false
#  end
#
#
#  def show_items
#    #if @category.has_additives == true
#    #      #@categories = @category.self_and_non_generic_additives
#    @items = Item.includes(:item_class_component, :item_sales_last_year, :category, :item_sales_this_year, :item_class_sales_this_years_with_item_id).where( "category_id = ? or category_id in (?) and Inactive != -1 ", @category , @category.additive_category_ids_split )
#    #else
#    #      @items = Item.includes(:item_class_component, :item_sales_last_year, :category, :item_sales_this_year, :item_class_sales_this_years_with_item_id).where( "category_id = ? and Inactive != -1 ", @category )
#    #end
#    #@items  =  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(@category)
#  end
#
#
#
#
#  ############################################################################################################
#  def show_applicable_items_only
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug "SUB-ACTION:browse_department_category_and_show_items-------------------------------------"
#    logger.debug "BROWSE 4b-------------------------------------@category.has_additives != true OR @show_items == true"
#    logger.debug "@fragment_name: #{@fragment_name}"
#    logger.debug "@category.inspect: " + @category.inspect
#    if  @category.category_class.item_type == 'master'
#      logger.debug "Fbrowse_department_category_not_incomplete_symbiont_category_show_items @category.category_class.item_type == 'master'"
#      logger.debug "zzesaiio"
#      @items = Caching::MemoryCache.instance.read  'browse_department_category_not_incomplete_symbiont_category_show_items_with_category_id_of_' + params[:category_id].to_s unless cache_on? == false
#      if !@items
#        logger.debug "!@items"
#        logger.debug "@category.inspect: " + @category.inspect
#        @items  =  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(@category)
#        Caching::MemoryCache.instance.write  'browse_department_category_not_incomplete_symbiont_category_show_items_with_category_id_of_' + params[:category_id].to_s ,  @items  unless cache_on? == false
#      end
#    elsif  @category.category_class.item_type != 'slave'
#      logger.debug "@category.category_class.item_type != 'slave'"
#      logger.debug "RUNNING MODEL METHOD  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories_plus_non_symbiont_items(@category)"
#      logger.debug "@category.inspect: " + @category.inspect
#      @items  =  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories_plus_non_symbiont_items(@category)
#      logger.debug "@items.size in controller: " + @items.size.to_s
#    else
#      logger.debug "browse_department_category_and_show_items final else"
#      #										@items  =  Item.find(:all,:conditions => ["category_id = ? or category_id in (?) and Inactive != -1 ", @category , @category.additive_category_ids_split ] )   #Item.find_all_by_category_id(@category)  #,:order => "ItemLookupCode ASC"
#      @items = Item.includes(:item_class_component, :item_sales_last_year, :category, :item_sales_this_year, :item_class_sales_this_years_with_item_id).where( "category_id = ? or category_id in (?) and Inactive != -1 ", @category , @category.additive_category_ids_split )
#    end
#  end
#  ############################################################################################################
#
#
#
#  def grid
#    render layout: false
#  end
#
#
#  def test
#    render layout: false
#  end
#
#  def ajax_browse
#    index
#    render layout: false
#  end
#
#
#
#
#  def determine_crest_print
#    @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_print_ids
#    @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse
#    @front_design.is_crest_print?
#  end
#
#  def crest_prints_list
#    session[:show_admin] = true
#    @main_design = Item.find params[:main_design_id]
#    Item.unscoped do
#      @main_design_applicable_front_designs_ids =  @main_design.applicable_crest_print_ids
#    end
#    render layout: false
#  end
#
#
#  def modal
#    render layout: false
#  end
#
#  def departments_containing_categories
#    #gon.categories = Category.limit(10)
#    #render layout: false
#  end
#
#  def select_department
#    render layout: false
#  end
#
#  def select_category
#    @department = Department.order("departments.Name ASC" ).includes(:categories).where( "departments.id = ? and categories.visible = ?",  params[:department_id], true )
#    render layout: false
#  end
#
#
#  def update_advanced_combination
#    @advanced_combination = AdvancedCombination.find(params[:id])
#    @advanced_combination = AdvancedCombination.new(params[:advanced_combination]) unless @advanced_combination   if admin?
#    if @advanced_combination.update_attributes( params[:advanced_combination]   )
#      logger.debug "great, updated combination"
#      @updated = true
#    else
#      @updated = false
#      logger.debug "failed to updated combination"
#    end
#  end
#
#
#############################################################################################################
#  def browse_not_department_not_category
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug "SUB-ACTION:browse_not_department_not_category-------------------------------------"
#  end
#############################################################################################################
#  def browse_department_not_category_not_incomplete_symbiont
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug "SUB-ACTION:browse_department_not_category_not_incomplete_symbiont-------------------------------------"
#    logger.debug "BROWSE 2-------------------------------------@department && !@category && @incomplete_symbiont == false"
#  end
#############################################################################################################
#  def browse_department_not_category_incomplete_symbiont
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug "SUB-ACTION:browse_department_not_category_incomplete_symbiont-------------------------------------"
#  end
#############################################################################################################
#  def browse_department_category_not_incomplete_symbiont_category_has_additives
#    bug_browse_department_category_not_incomplete_symbiont_category_has_additives
#    @special_rendering = 'browse/browse_department_category_not_incomplete_symbiont_category_has_additives'
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug "SUB-ACTION:browse_department_category_not_incomplete_symbiont_category_has_additives-------------------------------------"
#    logger.debug "BROWSE 4a-------------------------------------@category.has_additives == true && @show_items == false"
#    ### SHOW ITEMS MUST BE ON TO SHOW ITEMS, @show_items will equal true if no params[:si] by default. this will go in the startup_browsing
#    logger.debug "browse_department_category_not_incomplete_symbiont_category_has_additives"
#    @categories = @category.self_and_non_generic_additives
#    render(:partial => "shared_item/categories_and_additives" )
#  end
#############################################################################################################
#############################################################################################################
#  def browse_department_category_incomplete_symbiont
#    logger.debug "BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  BEGIN  "
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug "SUB-ACTION:browse_department_category_incomplete_symbiont-------------------------------------"
#    if @category.has_additives == true && @show_items == false
#      logger.debug "BROWSE 4-------------------------------------@category.has_additives == true && @show_items == true"
#      ### SHOW ITEMS MUST BE ON TO SHOW ITEMS, @show_items will equal true if no params[:si] by default. this will go in the startup_browsing
#      logger.debug "1213 browse_department_category_incomplete_symbiont"
#      @categories = @category.self_and_additives_in_opposite_ids(@purchase.opposite_category_ids)
#      render(:partial => "shared_item/categories_and_additives", :layout => controller_name )
#    else
#      logger.debug "BROWSE 5-------------------------------------@department && @category && @incomplete_symbiont == true"
#      if  @purchase_symbiote_item_type == 'slave'
#        logger.debug "4231 browse_department_category_incomplete_symbiont @purchase_symbiote_item_type == 'slave'"
#        logger.debug "2321 FRAGMENT READ FAILED browse_department_category_incomplete_symbiont @purchase_symbiote_item_type == 'slave'"
#
#
#
#        @items = Caching::MemoryCache.instance.read  'browse_department_category_incomplete_symbiont_category_id_' + params[:category_id].to_s unless cache_on? == false
#        if !@items
#          logger.debug "!@items"
#          #@items  =  @purchase.symbiote.item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(@category)
#          #@items  =  @purchase.symbiote.item.find_applicable_opposites_in_parameter_category_and_additive_categories(@category) ##this would be for master
#          @items  =  Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(@category)
#          Caching::MemoryCache.instance.write  'browse_department_category_incomplete_symbiont_category_id__' + params[:category_id].to_s ,  @items  unless cache_on? == false
#        end
#
#
#
#      else
#        logger.debug "21313 browse_department_category_incomplete_symbiont else NOT @purchase_symbiote_item_type == 'slave'"
#        @items  =  @purchase.symbiote.item.find_applicable_opposite_items_in_parameter_category(@category)
#      end
#    end
#    logger.debug "END END  END  END  END  END  END  END  END  END  END  END  END  END  END  END  END  "
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#    logger.debug " SUB-ACTION  SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION SUB-ACTION"
#  end
#############################################################################################################
#  def design
#    #setup_default_view_no_input
#  end
#
#
#
#
#
















  #def category_items
  #  logger.warn "#################################################################"
  #  logger.warn "#################################################################"
  #  logger.warn "#################################################################"
  #  logger.warn "@purchase_symbiote_item: " + @purchase_symbiote_item.inspect
  #  logger.warn "#################################################################"
  #  logger.warn "#################################################################"
  #  logger.warn "#################################################################"
  #  g = "g"
  #  category_items
  #end
  #
  #
  #
  #def category_items_gallery
  #  category_items
  #  #render layout: false
  #end




  #
  #
  #
  #def scroll
  #  @view = false
  #  #@departments_categories = DepartmentsCategory.all
  #  @items = DepartmentsCategoriesItem.order("department_name").page(params[:page]).per_page(10)
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render json: @items }
  #    format.js
  #  end
  #end
  #
  #def scroll_json
  #  @departments_categories = DepartmentsCategory.all
  #  respond_to do |format|
  #    format.html
  #    format.json{
  #      render :json => @departments_categories.to_json
  #    }
  #  end
  #end
  #
  #
  #
  #
  #
  #
  #
  #def browse_startup
  #  current_website
  #  startup_browsing_department
  #  #startup_browsing_departments
  #  startup_browsing_category
  #  #startup_browsing_categories if @department
  #  #startup_browsing_show_items
  #  #load_category_browser_cache_variables
  #  #startup_fragment_names
  #end
  #




#
#  def specsheet
#            if @incomplete_symbiont
#                       if @purchase_symbiote_item_type == "slave"
#                                           specsheet_slave_symbiote
#                       elsif  @purchase_symbiote_item_type == "master"
#                                          specsheet_master_symbiote
#                       end
#            else
#                    wrong
#            end
#
#  end
#
#
#
#
#
#
#
#
#############################################################################################################
#  def specsheet_master_symbiote
#
#
#    Item.unscoped do
#      @back_design = Item.find   params[:item_id]
#      @items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse
#      @front_design =  @items_front.first
#      @front_design_name = @front_design.ItemLookupCode + '.png'
#      @item =   @purchase_symbiote_item
#      if @front_design
#        @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)
#      else
#        #@front_design_name = Slug.generate(@back_design.department.Name) + '.png'
#      end
#      if @back_design
#        @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
#      end
#      @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
#      @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
#      @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
#    end
#
#
#    @master_purchases_entry = @purchase.master
#    @parameter_item = Item.includes(:category, :category_class, :item_class_component).find(params[:item_id]) if params[:item_id]
#    if @purchase.symbiote_type == 'master' && @parameter_item
#                if @parameter_item.category.category_class.item_type == 'slave'
#                        #|||| ITEM FIRST SYMBIONT: #### allows adding the chosen design to the item/design pair
#                        #A. master and applicable components and design from params -(how to tell:  @purchase.symbiont_type == 'master' && @parameter_item    )
#                        @item = @master_purchases_entry.master_of_symbiont_pair.item
#                        @design = @parameter_item   if @purchase.opposite_category_ids.include?(@parameter_item.category.id.to_s)
#                        @required_form_elements << 'hidden_design_id_field'   if @design
#                        ###sometimes when view details is loaded with a parameter item and this is master symbiote, error occurs..need to redirect
#                        begin
#                                @department = Department.find(@master_purchases_entry.potential_slave_decides_masters_department(@design) )
#                        rescue
#                               @department = Department.find(2 )
#                        end
#                        @notes << 'potential slave decided masters department'
#                        @required_form_elements << 'button_choose_this_design'
#                        #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => @design.id
#                else
#                        @flash_messages << 'Please complete your item with a compatible design'
#                        @custom_redirect = 'back'
#                end
#    elsif @purchase.symbiote_type == 'slave'  && @parameter_item
#              #|||| DESIGN FIRST SYMBIONT: ###{allows adding the chosen item or item_class_component to the item/design pair}
#              #B. slave - getting master and components from param - (how to tell:  @purchase.symbiont_type == 'slave'  && @parameter_item  )
#              @design = @master_purchases_entry.opposite_entry.item
#              if @purchase.opposite_category_ids.include?(@parameter_item.category.id.to_s)
#                          @item = @parameter_item
#                          @item_class_components  =  @design.opposites_applicable_item_class_components(@item)            if @parameter_item.item_class_component
#              else
#                            # flash[:notice] = 'This items category id ' + @parameter_item.category.id.to_s + ' was not found in your symbiotes category_class.opposite_category_ids.'
#                            flash[:notice] = 'Item not compatible. Choose an opposite below, place on hold or forget this design.'
#                            @custom_redirect = 'back'
#              end
#              if @department == nil
#                          @department = @item.department if @item
#                          #flash[:notice] = 'slave incomplete symbiote and no @department.'
#                          # @custom_redirect = 'back'
#              else
#                        @slaves_master_department_decision = @purchase.slave.design_decides_potential_masters_department(@department)
#                        if   @slaves_master_department_decision == 0
#                                flash[:notice] = 'slaves opposite master default department id not set up, or self.item.category.category_class.appearing_sections.includes (parameter_department.letter_section_code).'
#                                @custom_redirect = 'back'
#                        else
#                                @department = Department.find(@slaves_master_department_decision ) if @department
#                                @required_form_elements << 'button_choose_this_item'
#                                @required_form_elements << 'icc_collection_select'   if @item_class_components
#                                #     @required_form_elements << 'hidden_item_id_field'
#                                @required_form_elements << 'hidden_department_id_field'
#                        end
#              end
#
#              @selected_item_id = @item.id if @item
#              #>>>>>>>>>>>>>>>>>>>> OUTPUT>>>>>>>>>> :item_id => item_id  ## from collection select, or if unavailable, from hidden form field
#    end
#  end
#############################################################################################################
#
#
#


































  #
  #
  #
  #
  #
  #  def specsheet_master_symbiote_basic
  #              Item.unscoped do
  #                @back_design = Item.find   params[:item_id]
  #                @items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse
  #                @front_design =  @items_front.first
  #                @front_design_name = @front_design.ItemLookupCode + '.png'
  #                @item =   @purchase_symbiote_item
  #                if @front_design
  #                  @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)
  #                else
  #                  #@front_design_name = Slug.generate(@back_design.department.Name) + '.png'
  #                end
  #                if @back_design
  #                  @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
  #                end
  #                @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
  #                @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
  #                @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
  #              end
  #  end
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #def specsheet_ss
  #        current_website
  #        Item.unscoped do
  #                @back_design = Item.find   params[:item_id]
  #                @items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse
  #                @front_design =  @items_front.first
  #                @front_design_name = @front_design.ItemLookupCode + '.png'
  #                @item = Item.find 82
  #                if @front_design
  #                       @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)
  #                else
  #                        #@front_design_name = Slug.generate(@back_design.department.Name) + '.png'
  #                end
  #                if @back_design
  #                        @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
  #                end
  #                @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
  #                @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
  #                @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
  #        end
  #end
  #
  #
  #
  #
  #
  #
  #
  #
  #def specsheet_old
  #  logger.debug "BEGIN --------------------------------------------------- view_details_parameter_item"
  #  if params[:item_type]
  #    if params[:item_type] == 'slave'
  #      specsheet_slave
  #    elsif params[:item_type] == 'master'
  #      specsheet_master
  #    else
  #      c
  #      specsheet_singular
  #    end
  #  else
  #    specsheet_singular
  #  end
  #  logger.debug "END --------------------------------------------------- view_details_parameter_item"
  #end
  #
  #
  #
  #def specsheet_master
  #  current_website
  #  @item = Item.find params[:item_id]
  #  @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName + '.jpg'    #.gsub('.jpg', '').gsub('.png', '')  + '.jpg'
  #  @back_design  = Item.find params[:design_id]  if params[:design_id]
  #  @back_design  =  @item.most_popular_compatible_opposite( @website.default_all_department_ids_with_generic  )      unless  @back_design
  #end
  #
  #def specsheet_slave
  #  current_website
  #  Item.unscoped do
  #    @back_design = Item.find   params[:item_id]
  #    @items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse
  #    @front_design =  @items_front.first
  #    @front_design_name = @front_design.ItemLookupCode + '.png'
  #    @item = Item.find 82
  #    if @front_design
  #      @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)
  #    else
  #      #@front_design_name = Slug.generate(@back_design.department.Name) + '.png'
  #    end
  #    if @back_design
  #      @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
  #    end
  #    @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
  #    @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
  #    @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
  #  end
  #  logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department
  #end
  #
  #
  #def specsheet_singular
  #  current_website
  #  Item.unscoped do
  #    @back_design = Item.find   params[:item_id]
  #    @item = @back_design
  #    #@items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse
  #    #@front_design =  @items_front.first
  #    #@front_design_name = @front_design.ItemLookupCode + '.png'
  #    #@item = Item.find 82
  #    #if @front_design
  #    #          @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)
  #    #else
  #    #          #@front_design_name = Slug.generate(@back_design.department.Name) + '.png'
  #    #end
  #    #if @back_design
  #    #            @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
  #    #end
  #    #@product_background_image_name =   '/images/item_specsheets/' + @item.PictureName   # + '.png'
  #    #@front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
  #    @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
  #  end
  #  logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department
  #end
  #
  #
  #
  #
  #
  #
  #
  #
  #
  #def specsheet_BEFORE
  #  logger.debug "BEGIN--------------------------------------------------- view_details_parameter_item"
  #  if params[:item_type] == 'slave'
  #    Item.unscoped do
  #      #SINGULAR||||||||||||||||||||||||||||||||||||||||||
  #      logger.debug "VIEW_DETAILS-SINGULAR-------------------------@parameter_item && @incomplete_symbiont == false"
  #      @back_design = Item.find   params[:item_id]
  #      @back_design_id = @back_design.id
  #      # @design = Item.find params[:item_id]
  #      Item.unscoped do
  #        @items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
  #        @front_design =  @items_front.first
  #        @front_design_id = @front_design.id
  #        @front_design_name = @front_design.ItemLookupCode + '.png'
  #      end
  #      @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_print_ids
  #      @item = Item.find 82
  #      logger.warn "###########   ######     #########"
  #      logger.warn " @item.item_class_component.item_class.id: " + @item.item_class_component.item_class.id.to_s
  #      logger.warn "###########   ######     #########"
  #      if @front_design
  #        if @front_design.category
  #          logger.warn " @front_design.category.id: " +  @front_design.category.id.to_s
  #        end
  #        @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)
  #      else
  #        @front_design_name = Slug.generate(@back_design.department.Name) + '.png'
  #      end
  #      if @back_design
  #        if @back_design.category
  #          logger.warn " @back_design.category.id: " +  @back_design.category.id.to_s
  #        end
  #        @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
  #      end
  #      #              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
  #      @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
  #      @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
  #      @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
  #      @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
  #      ##########  DEPARTMENT CHOICES
  #      @department_choices_background = Department.find_all_by_id( ['36' ]  )
  #      @website = Website.find 3
  #      @department_choices_front =    @website.default_design_departments   #@back_design.crest_print_department_records
  #      @department_choices_back = @website.default_design_departments
  #      @items_background =    Item.where("department_id = ?", '36' )
  #      #                          @department_choices_product = @back_design.opposite_departments  # IF YOU NEED TO BE SPECIFIC TO  CURRENT DESIGN USE THIS...
  #      @department_choices_product = @website.default_item_departments
  #      @items_product = Rails.cache.read 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
  #      if @items_product
  #        logger.debug "FOUND @items_product USING CACHE"
  #        logger.debug "FOUND @items_product USING CACHE"
  #        logger.debug "FOUND @items_product USING CACHE"
  #        logger.debug "FOUND @items_product USING CACHE"
  #      else
  #        logger.debug "ERROR - FAILED TO FIND @items_product USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
  #        @items_product =  @back_design.opposite_representatives_sorted_by_sales
  #        Rails.cache.write  'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s  , @items_product
  #      end
  #      #                                @items_background =  Item.order("ItemLookupCode").where('category_id like ?', 677)    #  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
  #
  #      @items_back =  Item.order("ItemLookupCode").where('category_id like ?', @back_design.category_id )   # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @back_design.category_id  ]  , :order => 'ItemLookupCode'   #@back_design.category_id
  #      #                                @items_product =  @items_product.to_a.paginate :per_page => @@category_items_per_page, :page => params[:page]    , :order => 'ItemLookupCode'
  #      @your_unit_price = @item.your_unit_price(@customer,1) if @customer
  #    end
  #    logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department
  #  elsif params[:item_type] == 'master'
  #    logger.debug "params[:item_type] == 'master'"
  #    @item = Item.find params[:item_id] #|| 82
  #    logger.warn " @item.item_class_component.item_class.id: " + @item.item_class_component.item_class.id.to_s
  #    if params[:back_design_id]
  #      @back_design = Item.find   params[:back_design_id]      #||    3061
  #    else
  #      @back_design = Rails.cache.read "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s
  #      if @back_design
  #        logger.debug "most_popular_compatible_opposite read from cache"
  #      else
  #        @back_design = @item.most_popular_compatible_opposite
  #        Rails.cache.write "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s,  @back_design
  #      end
  #    end
  #    @back_design_id = @back_design.id
  #    Item.unscoped do
  #      @items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
  #    end
  #
  #    #################################################
  #    if @items_front.first
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      @front_design =  @items_front.first
  #      @front_design_id = @front_design.id
  #      @front_design_name = @front_design.ItemLookupCode + '.png'
  #      @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
  #    else
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #    end
  #    #################################################
  #
  #
  #    #                                           logger.warn " @front_design.category.id: " +  @front_design.category.id.to_s  if @front_design
  #    #                                           logger.warn " @back_design.category.id: " +  @back_design.category.id.to_s  if @back_design
  #    @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design) if @front_design
  #    @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design) if @back_design
  #    Item.unscoped do
  #      @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_prints_ids
  #    end
  #    #              @front_design_name = Slug.generate(@back_design.department.Name) + '.png'
  #    #              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
  #    @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.jpg'
  #    @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
  #    @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
  #    ##########  DEPARTMENT CHOICES
  #    @department_choices_background = Department.find_all_by_id( ['36' ]  )
  #    @department_choices_front =    @website.default_design_departments   #@back_design.crest_print_department_records
  #    @department_choices_back = @website.default_design_departments
  #    #                          @department_choices_product = @back_design.opposite_departments  # IF YOU NEED TO BE SPECIFIC TO  CURRENT DESIGN USE THIS...
  #    @department_choices_product = @website.default_item_departments
  #    @items_product = Rails.cache.read 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
  #    if @items_product
  #      logger.debug "FOUND @items_product USING CACHE"
  #      logger.debug "FOUND @items_product USING CACHE"
  #      logger.debug "FOUND @items_product USING CACHE"
  #      logger.debug "FOUND @items_product USING CACHE"
  #    else
  #      logger.debug "ERROR - FAILED TO FIND @items_product USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
  #      @items_product =  @back_design.opposite_representatives_sorted_by_sales
  #      Rails.cache.write  'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s  , @items_product
  #    end
  #    @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
  #    @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @back_design.category_id  ]  , :order => 'ItemLookupCode'   #@back_design.category_id
  #    @items_product =  @items_product.to_a.paginate :per_page => @@category_items_per_page, :page => params[:page]    , :order => 'ItemLookupCode'
  #    @your_unit_price = @item.your_unit_price(@customer,1) if @customer
  #  else
  #    insufficient_parameters
  #  end
  #end
  #
  #
  #
  #
  #
  #
  #def setup_default_view_no_input
  #  logger.debug "BEGIN--------------------------------------------------- view_details_parameter_item_and_no_incomplete_symbiont"
  #  if params[:item_type] == 'slave'
  #    Item.unscoped do
  #      #SINGULAR||||||||||||||||||||||||||||||||||||||||||
  #      logger.debug "VIEW_DETAILS-SINGULAR-------------------------@parameter_item && @incomplete_symbiont == false"
  #      @back_design = Item.find   params[:item_id]
  #      @back_design_id = @back_design.id
  #      # @design = Item.find params[:item_id]
  #      @items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
  #      @front_design =  @items_front.first
  #      @front_design_id = @front_design.id
  #      @front_design_name = @front_design.ItemLookupCode + '.png'
  #      @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_prints_ids
  #      @item = Item.find 82
  #      logger.warn "###########   ######     #########"
  #      logger.warn " @item.item_class_component.item_class.id: " + @item.item_class_component.item_class.id.to_s
  #      logger.warn "###########   ######     #########"
  #      if @front_design
  #        if @front_design.category
  #          logger.warn " @front_design.category.id: " +  @front_design.category.id.to_s
  #        end
  #        @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design)
  #      else
  #        @front_design_name = Slug.generate(@back_design.department.Name) + '.png'
  #      end
  #      if @back_design
  #        if @back_design.category
  #          logger.warn " @back_design.category.id: " +  @back_design.category.id.to_s
  #        end
  #        @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
  #      end
  #      #              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
  #      @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
  #      @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
  #      @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
  #      @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
  #      ##########  DEPARTMENT CHOICES
  #      @department_choices_background = Department.find_all_by_id( ['36' ]  )
  #      @website = Website.find 3
  #      @department_choices_front =    @website.default_design_departments   #@back_design.crest_print_department_records
  #      @department_choices_back = @website.default_design_departments
  #      @items_background =    Item.where("department_id = ?", '36' )
  #      #                          @department_choices_product = @back_design.opposite_departments  # IF YOU NEED TO BE SPECIFIC TO  CURRENT DESIGN USE THIS...
  #      @department_choices_product = @website.default_item_departments
  #      @items_product = Rails.cache.read 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
  #      if @items_product
  #        logger.debug "FOUND @items_product USING CACHE"
  #        logger.debug "FOUND @items_product USING CACHE"
  #        logger.debug "FOUND @items_product USING CACHE"
  #        logger.debug "FOUND @items_product USING CACHE"
  #      else
  #        logger.debug "ERROR - FAILED TO FIND @items_product USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
  #        @items_product =  @back_design.opposite_representatives_sorted_by_sales
  #        Rails.cache.write  'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s  , @items_product
  #      end
  #      #                                @items_background =  Item.order("ItemLookupCode").where('category_id like ?', 677)    #  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
  #
  #      @items_back =  Item.order("ItemLookupCode").where('category_id like ?', @back_design.category_id )   # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @back_design.category_id  ]  , :order => 'ItemLookupCode'   #@back_design.category_id
  #      #                                @items_product =  @items_product.to_a.paginate :per_page => @@category_items_per_page, :page => params[:page]    , :order => 'ItemLookupCode'
  #      @your_unit_price = @item.your_unit_price(@customer,1) if @customer
  #    end
  #    logger.debug "VIEW_DETAILS-SINGULAR DEPARMENT-------------------------#{@department.id}" if @department
  #  elsif params[:item_type] == 'master'
  #    logger.debug "params[:item_type] == 'master'"
  #    @item = Item.find params[:item_id] #|| 82
  #    logger.warn " @item.item_class_component.item_class.id: " + @item.item_class_component.item_class.id.to_s
  #    if params[:back_design_id]
  #      @back_design = Item.find   params[:back_design_id]      #||    3061
  #    else
  #      @back_design = Rails.cache.read "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s
  #      if @back_design
  #        logger.debug "most_popular_compatible_opposite read from cache"
  #      else
  #        @back_design = @item.most_popular_compatible_opposite
  #        Rails.cache.write "most_popular_compatible_opposite_for_item_id_" + @item.id.to_s,  @back_design
  #      end
  #    end
  #    @back_design_id = @back_design.id
  #    Item.unscoped do
  #      @items_front =         @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse     # Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 35 ]  , :order => 'ItemLookupCode'
  #    end
  #
  #    #################################################
  #    if @items_front.first
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      @front_design =  @items_front.first
  #      @front_design_id = @front_design.id
  #      @front_design_name = @front_design.ItemLookupCode + '.png'
  #      @front_design_image_name      =   '/images/item_specsheets/' + @front_design_name
  #    else
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #      logger.warn "########### @items_front.first NOT FOUND    #########"
  #    end
  #    #################################################
  #
  #
  #    #                                           logger.warn " @front_design.category.id: " +  @front_design.category.id.to_s  if @front_design
  #    #                                           logger.warn " @back_design.category.id: " +  @back_design.category.id.to_s  if @back_design
  #    @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design) if @front_design
  #    @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design) if @back_design
  #    Item.unscoped do
  #      @back_design_applicable_front_designs_ids =  @back_design.applicable_crest_prints_ids
  #    end
  #    #              @front_design_name = Slug.generate(@back_design.department.Name) + '.png'
  #    #              @item_class_components = @item.item_class_component.item_class.all_valid_components  unless  @item.item_class_component.nil?
  #    @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName  + '.png'
  #    @product_mask_image_name =   '/images/item_masks/' + @item.item_class_item_lookup_code + '.png'
  #    @back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
  #    ##########  DEPARTMENT CHOICES
  #    @department_choices_background = Department.find_all_by_id( ['36' ]  )
  #    @department_choices_front =    @website.default_design_departments   #@back_design.crest_print_department_records
  #    @department_choices_back = @website.default_design_departments
  #    #                          @department_choices_product = @back_design.opposite_departments  # IF YOU NEED TO BE SPECIFIC TO  CURRENT DESIGN USE THIS...
  #    @department_choices_product = @website.default_item_departments
  #    @items_product = Rails.cache.read 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
  #    if @items_product
  #      logger.debug "FOUND @items_product USING CACHE"
  #      logger.debug "FOUND @items_product USING CACHE"
  #      logger.debug "FOUND @items_product USING CACHE"
  #      logger.debug "FOUND @items_product USING CACHE"
  #    else
  #      logger.debug "ERROR - FAILED TO FIND @items_product USING CACHE : cache name: " + 'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s
  #      @items_product =  @back_design.opposite_representatives_sorted_by_sales
  #      Rails.cache.write  'opposite_representatives_sorted_by_sales_' + @back_design.category.category_class_id.to_s  , @items_product
  #    end
  #    @items_background =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', 677  ]  , :order => 'ItemLookupCode'
  #    @items_back =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', @back_design.category_id  ]  , :order => 'ItemLookupCode'   #@back_design.category_id
  #    @items_product =  @items_product.to_a.paginate :per_page => @@category_items_per_page, :page => params[:page]    , :order => 'ItemLookupCode'
  #    @your_unit_price = @item.your_unit_price(@customer,1) if @customer
  #  else
  #    insufficient_parameters
  #  end
  #
  #  g = "g"
  #
  #end
  #
  #
  #
  #
  #
  #











  #layout :admin_layout
  #
  #
  #def admin_layout
  #  # Check if logged in, because current_user could be nil.
  #  @mobile = true
  #  if @mobile
  #    "jquery_mobile"
  #  else
  #    "jquery_mobile"
  #  end
  #end

























  #def update_specsheet
  #        logger.debug "begin update_specsheet"
  #        current_website
  #        @from_ajax = true
  #        if params[:applicable]
  #          @applicable = true unless params[:applicable] == '0'
  #        else
  #          no_params_applicable
  #        end
  #        if params[:changed_object] == 'back'
  #                        logger.debug 'params[:changed_object] == back'
  #
  #                        @back_design = Item.where("id = ?", params[:selected_item_id] ).first
  #                        @front_design = @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse.first
  #                        if @applicable
  #                                      logger.debug "GOOD @applicable"
  #                                      @item = Item.find params[:item_id]
  #                                      @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
  #                                      @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design) if @front_design
  #                                      @front_design_image_name     =   '/images/item_thumbnails/' +  @front_design.ItemLookupCode + '.png'  if @front_design
  #                                      @back_design_image_name     =    '/images/item_specsheets/' +  @back_design.PictureName
  #
  #                        else
  #                                      logger.debug "NOT @applicable"
  #                                      @item = @back_design.most_popular_compatible_opposite( @website.default_all_department_ids_with_generic  )
  #                                      @back_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @back_design)
  #                                      @front_advanced_combination = AdvancedCombination.find_or_create_combo( @item, @front_design) if @front_design
  #                                      @front_design_image_name     =   '/images/item_thumbnails/' +  @front_design.ItemLookupCode + '.png'  if @front_design
  #                                      @back_design_image_name     =    '/images/item_specsheets/' +  @back_design.PictureName
  #                                      #logger.debug "BAD  @item.is_applicable_with?( @back_design ) FALSE "
  #                                      #@new_item = @back_design.most_popular_compatible_opposite( @website.default_all_department_ids_with_generic  )
  #                                      #@product_background_image_name =   '/images/item_specsheets/' + @new_item.PictureName  + '.png'
  #                                      #
  #                                      #
  #                                      #logger.debug "NOT @back_design.category.category_class.item_type == 'all_over_design'"
  #                                      #@front_design = @back_design.find_applicable_crest_prints.sort_by{|a| a.ytdn}.reverse.first      #@back_design
  #                                      #@back_advanced_combination = AdvancedCombination.find_or_create_combo( @new_item, @back_design)  if @back_design
  #                                      #@front_advanced_combination = AdvancedCombination.find_or_create_combo( @new_item, @front_design)   if @front_design
  #                                      #@front_design_image_name    =    '/images/item_thumbnails/' +  item.ItemLookupCode + '.png'
  #                                      #@back_design_image_name     =    '/images/item_specsheets/' + @back_design.PictureName
  #                        end
  #        elsif  params[:changed_object] == 'item'
  #                        logger.debug 'params[:changed_object] == item'
  #                        @item = Item.find params[:selected_item_id]
  #                        @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName + '.jpg'    #.gsub('.jpg', '').gsub('.png', '')  + '.jpg'
  #                        if @applicable
  #                                      logger.debug"@applicable, do not worry about changing the design."
  #                                      @back_design  = Item.find params[:main_design_id]
  #                        else
  #                                      if @item.category.category_class.item_type == 'master'
  #                                                            @singular_item = false
  #                                                            logger.debug "this item is a master, it will have designs. find one."
  #
  #                                                            if params[:main_design_id]   and  params[:main_design_id]  != '0'
  #                                                                              @back_design  = Item.find params[:main_design_id]
  #                                                            else
  #                                                                              @back_design  =  @item.most_popular_compatible_opposite( @website.default_all_department_ids_with_generic  )
  #                                                            end
  #                                      else
  #                                                            @singular_item = true
  #                                                            logger.debug "this item is singular. no designs go with it."
  #                                                            @product_background_image_name =   '/images/item_specsheets/' + @item.PictureName     #  + '.png'
  #                                      end
  #                        end
  #        end
  #        #render :partial => 'designer_specsheet/category_items_front'
  #        logger.debug "end update_specsheet"
  #        render layout: false
  #end





















  #
  #
  #def index_before
  #  if !@department && !@category
  #    browse_not_department_not_category
  #  elsif  @department && !@category && @incomplete_symbiont == false
  #    browse_department_not_category_not_incomplete_symbiont
  #    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  elsif  @department && !@category && @incomplete_symbiont == true
  #    browse_department_not_category_incomplete_symbiont
  #    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  elsif  @department && @category && @incomplete_symbiont == false
  #    if @category.has_additives == true  && @show_items == false
  #      browse_department_category_not_incomplete_symbiont_category_has_additives
  #    else
  #      browse_department_category_not_incomplete_symbiont_category_show_items
  #    end
  #    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  elsif  @department && @category && @incomplete_symbiont == true
  #    browse_department_category_incomplete_symbiont
  #    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  else
  #    logger.debug "BROWSE 6-------------------------------------final else"
  #    flash[:notice] = "browse error 701"
  #    #redirect_to(:controller => 'browse', :action => 'index')
  #  end
  #  logger.debug "-------------------------------------END BROWSE ACTION"
  #end






end
