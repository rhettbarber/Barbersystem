class CartController < ApplicationController
skip_before_filter :verify_authenticity_token
before_filter :initialize_variables, :only => [:wholesale_only_website_logged_in_retail?, :place_incomplete_symbiont_on_hold, :test,  :show_cc_code_info, :show_discount_info, :add_to_cart, :index ,:next_checkout_step, :place_symbiont_on_hold, :delete_symbiont_purchases_entry,:delete_purchases_entry,  :delete_incomplete_symbiote, :delete_all_on_hold_items,:delete_all_purchases_entries]
after_filter :reset_incomplete_symbiont_status_found  # , :only =>  [ :add_to_cart, :place_symbiont_on_hold, :delete_symbiont_purchases_entry, :delete_incomplete_symbiote, :delete_all_purchases_entries, :complete_this_combination]
#after_filter :initialize_variables   , :only =>  [ :add_to_cart, :place_symbiont_on_hold, :delete_symbiont_purchases_entry, :delete_incomplete_symbiote, :delete_all_purchases_entries, :complete_this_combination]
### SERIALIZE DETAILS: http://ar.rubyonrails.org/classes/ActiveRecord/Base.html
### SERIALIZE DETAILS: http://ar.rubyonrails.org/classes/ActiveRecord/Base.html
### SERIALIZE DETAILS: http://ar.rubyonrails.org/classes/ActiveRecord/Base.html

def add_to_cart
  pe_comment
  if wholesale_only_website_logged_in_retail?
                  #flash[:notice] = "This is a wholesale only website and you are logged in with a retail account."
                  redirect_to(:controller =>  "account",  :action => 'wholesale_only_website')  ;
  else
                  if params[:on_hold]
                                session[:on_hold] = params[:on_hold]
                 end

                  if params[:submitted_from_cart]
                               logger.debug "about to add flash"
                                flash[:added_to_cart] =  "true"
                  else
                               logger.debug "not adding flash"
                    end


                    logger.debug "begin add_to_cart"
                    if params[:purchases_entry_id] == nil
                                       logger.debug "NO PURCHASES_ENTRY_ID"
                                      find_item(params)
                                      if @item
                                                              if params[:purchases_entries]
                                                                          ensure_positive_quantity(params[:purchases_entries][:QuantityOnOrder])
                                                              else
                                                                           ensure_positive_quantity('1')
                                                              end
                                                              start_purchase unless @purchase
                                                              if fails_membership_requirement?(@item)
                                                                                      redirect_to  :controller => 'cart', :action => 'index'
                                                              else
                                                                                    if @singular_item_customer == true   ################################ (wholesale pricelevel B and C customers)
                                                                                                      add_to_cart_singular_item_customer
                                                                                    elsif  @item.category.category_class.item_type  == 'all_over_item'

                                                                                                       add_to_cart_singular_designer

                                                                                    else
                                                                                                     ## SECTION 3  (incomplete symbiont in progress, this will complete it with the param item if compatible)
                                                                                                      if @incomplete_symbiont == true &&  params[:on_hold] != 'true'
                                                                                                                        add_to_cart_incomplete_symbiont_not_on_hold
                                                                                                      else
                                                                                                                        if params[:add_combo] == '1'
                                                                                                                                        if  params[:design_id]
                                                                                                                                                              @design = Item.find params[:design_id]
                                                                                                                                        end
                                                                                                                                         if  params[:commit].downcase  == "choose"
                                                                                                                                                                logger.debug "COMMIT DOWNCASE == choose.. add_to_cart_combo"
                                                                                                                                                                 add_to_cart_combo
                                                                                                                                         elsif params[:commit].downcase  == "add_to_cart_purchases_entry_change_item_keep_design"
                                                                                                                                                                 logger.debug "COMMIT DOWNCASE IS change shirt.. ADD design TO CART AS NECESSARY"
                                                                                                                                                                 if @item.category.category_class.item_type  == 'master'
                                                                                                                                                                                          logger.debug "@item.category.category_class.item_type  == master. SWITCH @ITEM TO @DESIGN"
                                                                                                                                                                                        @item = @design
                                                                                                                                                                                        add_to_cart_slave
                                                                                                                                                                 elsif @item.category.category_class.item_type  == 'slave'
                                                                                                                                                                                        logger.debug "@item.category.category_class.item_type  == slave"
                                                                                                                                                                                         add_to_cart_slave
                                                                                                                                                                 else
                                                                                                                                                                                         add_to_cart_singular
                                                                                                                                                                 end
                                                                                                                                         elsif params[:commit].downcase  == "add_to_cart_purchases_entry_change_design_keep_item"
                                                                                                                                                                 logger.debug "COMMIT DOWNCASE IS change design.. ADD shirt TO CART AS NECESSARY"
                                                                                                                                                                 if @item.category.category_class.item_type  == 'master'
                                                                                                                                                                                         logger.debug "@item.category.category_class.item_type  == master. SWITCH @ITEM TO @DESIGN"
                                                                                                                                                                                         add_to_cart_master
                                                                                                                                                                 elsif @item.category.category_class.item_type  == 'slave'
                                                                                                                                                                                         logger.debug "@item.category.category_class.item_type  == slave"
                                                                                                                                                                                         @item = @design
                                                                                                                                                                                         add_to_cart_master
                                                                                                                                                                 else
                                                                                                                                                                                           add_to_cart_singular
                                                                                                                                                                 end
                                                                                                                                         else
                                                                                                                                                              no_choose_value
                                                                                                                                          end
                                                                                                                        else
                                                                                                                                          if @item.category.category_class.item_type  == 'master'
                                                                                                                                                        add_to_cart_master
                                                                                                                                          elsif @item.category.category_class.item_type  == 'slave'
                                                                                                                                                        add_to_cart_slave
                                                                                                                                          else
                                                                                                                                                        add_to_cart_singular
                                                                                                                                          end
                                                                                                                          end
                                                                                                      end
                                                                                    end
                                                              end
                                      else
                                                        flash[:notice] = "Item not found."
                                                        redirect_to  :controller => 'cart',  :action => 'index'
                                      end
                    else
                                     logger.debug "PURCHASES_ENTRY_ID FOUND"
                                     logger.debug("params[:commit].downcase:  " + params[:commit].downcase  )
                                     logger.debug( "params[:design_id] :" + params[:design_id] )
                                     logger.debug( "params[:item_id] :" + params[:item_id] )
                                     logger.debug( "params[:item_class_component] :" + params[:item_class_component].inspect  )
                                     if params[:commit].downcase  == "add_to_cart_purchases_entry_change_design_keep_item"
                                                         @add_to_cart_purchases_entry_change_design_keep_item = true
                                      elsif params[:commit].downcase  == "add_to_cart_purchases_entry_change_item_keep_design"
                                                          @add_to_cart_purchases_entry_change_item_keep_design = true
                                      end
                                      add_to_cart_purchases_entry
                    end
   end
		logger.debug "end add_to_cart"
end

############################################################################################################
  def add_to_cart_purchases_entry
                        logger.debug "begin add_to_cart_purchases_entry"
                        logger.debug "####### -####### -####### -####### -####### - #######"
                        logger.debug "####### -####### -####### -####### -####### - #######"
                        purchases_entry = @purchase.purchases_entries.find(params[:purchases_entry_id])

                        if params[:item_class_component]
                                           the_item_id  = params[:item_class_component][:item_id]
                        elsif params[:item_id]
                                          the_item_id = params[:item_id]
                        end
                        the_item = Item.find( the_item_id )

                        the_design_id = params[:design_id]
                        the_design  = Item.find( the_design_id )

                         logger.debug "@add_to_cart_purchases_entry_change_design_keep_item: "  +  @add_to_cart_purchases_entry_change_design_keep_item.to_s
                         logger.debug "@add_to_cart_purchases_entry_change_item_keep_design: "  +  @add_to_cart_purchases_entry_change_item_keep_design.to_s
                        if the_item
                                      logger.debug "the_item.id.to_s: "  +  the_item.id.to_s
                        else
                                      logger.debug "no the_item"
                        end
                        if the_design
                                      logger.debug "the_design.id.to_s: "  +  the_design.id.to_s
                        else
                                      logger.debug "no the_design"
                         end

                        if purchases_entry.symbiotic_item == true
                                            purchases_entry_slave = purchases_entry.slave_of_symbiont_pair
                                            purchases_entry_master  = purchases_entry.master_of_symbiont_pair
                                             if @add_to_cart_purchases_entry_change_design_keep_item and the_item
                                                                                 logger.debug "@add_to_cart_purchases_entry_change_design_keep_item"
                                                                                # check for item_id param since current item is empty
                                                                                 if  the_item_id
                                                                                                purchases_entry_master.item_id =  the_item_id
                                                                                else
                                                                                                 logger.warn "the_item_id NOT FOUND"
                                                                                  end
                                                                                  purchases_entry_master.Comment =  "0"
                                                                                  purchases_entry_slave.Comment =   "0"
                                                                                  purchases_entry_slave.Description =  "0"
                                                                                  purchases_entry_slave.item_id =   "0"
                                                                                 @flash_messages = "Choose a design for your shirt"
                                                                                  @custom_redirect = "/store"
                                             elsif  @add_to_cart_purchases_entry_change_item_keep_design and the_design
                                                                                     logger.debug "@add_to_cart_purchases_entry_change_item_keep_design"
                                                                                    if the_design_id
                                                                                              purchases_entry_slave.item_id =  the_design_id
                                                                                    else
                                                                                                    logger.warn "the_design_id NOT FOUND"
                                                                                      end
                                                                                     purchases_entry_master.Comment =  "0"
                                                                                     purchases_entry_slave.Comment =   "0"
                                                                                     purchases_entry_master.Description =  "0"
                                                                                     purchases_entry_master.item_id =   "0"
                                                                                     @flash_messages = "Choose a shirt for your design"
                                                                                    @custom_redirect = "/store"
                                             else
                                                                                     logger.debug "add_to_cart_purchases_entry update item class component"
                                                                                    if the_item
                                                                                                      purchases_entry_master.item_id = the_item_id
                                                                                                      purchases_entry_master.ItemLookupCode = the_item.ItemLookupCode
                                                                                                      purchases_entry_master.Description =Slug.generate( the_item.Description )
                                                                                                      purchases_entry_slave.Comment = @pe_comment
                                                                                                      purchases_entry_master.Comment = @pe_comment
                                                                                    else
                                                                                                      logger.warn "no the_item!!!!"
                                                                                    end
                                                                                    if the_design
                                                                                                             purchases_entry_slave.item_id = the_design_id
                                                                                                             purchases_entry_slave.Description = Slug.generate( the_design.Description )
                                                                                                             purchases_entry_slave.ItemLookupCode =  the_design.ItemLookupCode
                                                                                    else
                                                                                                              logger.warn "no the_design!!!"
                                                                                    end
                                             end
                                              purchases_entry_master.save
                                              purchases_entry_slave.save
                        else
                                               logger.debug "purchases_entry.symbiotic_item IS NOT true"
                                               purchases_entry.item_id =the_item_id
                                                purchases_entry.Description =Slug.generate( purchases_entry.item.Description )
                                                purchases_entry.save
                        end
                        logger.debug "####### -####### -####### -####### -####### - #######"
                        logger.debug "####### -####### -####### -####### -####### - #######"
                        # redirect_to  :controller => 'cart',  :action => 'index'
                        flash[:notice] = @flash_messages    ||=  "Your product was updated."
                        if @custom_redirect
                                      redirect_to( @custom_redirect )
                        else
                                       redirect_to  :controller => 'cart',  :action => 'index'
                          end
  end
############################################################################################################
  def index
    #logger.debug "flash in controller: " + flash[:notice].to_s  if flash
    if @purchase
      prepare_purchase_totals(@purchase)  unless @incomplete_symbiont
      if @incomplete_symbiont
        if @purchase.symbiote_type == 'master'
          @completion_status_bar_message = 'Complete your chosen Item by adding a Design using the QuickCart below, or by clicking "Choose a Design" above'
        else
          @completion_status_bar_message = 'Complete your chosen Design by adding an Item using the QuickCart below, or by clicking "Choose an Item for your selected design" above'
        end
      end
      #the two purchases_entries calls below look redundant to the application controller purchase startup . be aware that they are not.
      @purchases_entries = @purchase.purchases_entries.order("id Desc")     #PurchasesEntry.find(:first,:conditions => ["id = ? ",  session[:purchase_id]  ] )
      # @your_purchases_entries = @purchase.purchases_entries    # PurchasesEntry.find(:all,:conditions => ["purchase_id = ? ",session[:purchase_id] ] , :order => "id ASC"  )
      #  render(:partial => "cart/display_cart",:layout => 'ajaxified_application' )
    end
  end
############################################################################################################
  def  pe_comment
    if params[:crest_id] and   params[:crest_id] != ""
      pe_crest =  Item.find(  params[:crest_id].to_s[0..10] ).PictureName
    else
      pe_crest =  "0"
    end

    if params[:side] and   params[:side] != ""
      pe_side =   params[:side].to_s[0..5]
    else
      pe_side =  "back"
    end

    if params[:transfer_type] and   params[:transfer_type] != ""
      pe_transfer_type =  params[:transfer_type][:id].to_s[0..8]
    else
      pe_transfer_type =  "0"
    end

    @pe_comment =   pe_side  +  "_" +  pe_crest  +  "_" +  pe_transfer_type
  end
############################################################################################################
  def add_to_cart_singular_item_customer
    logger.debug "begin add_to_cart_singular_item_customer-------------------------------------------------@item.id: #{@item.id}"
    if @item.category.category_class.item_type  == 'master'
      @department = params[:department_id]
      @department = @item.default_master_department_id  if !@department
      @purchases_entry = PurchasesEntry.add_singular_item(@purchase,@item,@quantity,@department, @pe_comment  )
    else
      @purchases_entry = PurchasesEntry.add_singular_item(@purchase,@item,@quantity,0,  @pe_comment  )
    end
    redirect_to  :controller => 'cart',  :action => 'index'
  end
############################################################################################################
  def add_to_cart_incomplete_symbiont_not_on_hold
    logger.debug "begin add_to_cart_incomplete_symbiont_not_on_hold-------------------------------------------------@item.id: #{@item.id}"
    logger.debug "@purchase.symbiote.inspect: " + @purchase.symbiote.inspect
    logger.debug "@item.inspect: : #{@item.inspect}"
    logger.debug "@item.category.inspect: " + @item.category.inspect
    logger.debug "@purchase.opposite_category_ids.include?(@item.category.id.to_s)  ----------- #{@purchase.opposite_category_ids}.include?(#{@item.category.id.to_s}) "
    if  @purchase.opposite_category_ids.include?(@item.category.id.to_s)
      if @purchase.symbiote_type == 'master'
        # incomplete symbiont in progress with master already chosen)
        # sometimes the master_department_id that was chosen by default will be wrong for this parameter slave we're trying to complete this symbiont with
        # we will need to update the master_department_id if needed.
        if @item.category.category_class.appearing_sections.include?(@purchase.symbiote.master_department_letter_section_code )
          @department =  @purchase.master.master_department_id
        else
          @department = @item.design_decides_opposites_department
        end
        session[:symbiont_department_id] = @department.to_s if @department
        #TODO: change @department to department_id..
        #if color_compatible(@purchase_symbiote_item, @item) == 'true'
        logger.debug "@purchase.symbiote_blank.complete_symbiote(x,x,x)"
        logger.debug "@item: " + @item.inspect
        logger.debug "@department: " + @department.inspect
        logger.debug "@pe_comment: " + @pe_comment.inspect
        @purchase.symbiote_blank.complete_symbiote(@item,@department, @pe_comment)
        reset_symbiont_department_id
        redirect_to   :controller =>  "cart"
        #else
        #  flash[:notice] = 'This design cannot go on colored garments. Light garments only'
        #  redirect_to   :controller =>  "cart"
        #end
      elsif @purchase.symbiote_type == 'slave'
        if @department
          #scenerio:((((Design in cart with no master yet using  browse and view_details to add items )))
          # we will pass in the parameter based @department and see if it is in the appearing sections of the slaves category_class
          # if it is, then the master_department_id is the parameter department. If this design is not meant to appear in this parameter
          # based department (like a D.G. print with @department of 2 which is Men) then substitute the parameter department
          # with the slaves_opposite_master_default_department_id.
          # (summary: will try and use @department, else use default opposite department of slave)
          @chosen_department = @purchase.slave.design_decides_potential_masters_department(@department)
        else
          #scenerio:((((Design in cart using quick cart to add the garment)))
          # this area is used with quick cart where there is no parameter based @department but
          # we still need a department so that we can properly represent the model image.
          # ex. (D.G. design added with quickcart, then 11001 garment..the model image needs to be a woman)
          @chosen_department = @item.masters_department_decides_default_department_id
          #@chosen_department = @purchase.slave.item.design_decides_opposites_department
        end
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        if @chosen_department != false
          #if color_compatible(@item, @purchase_symbiote_item ) == 'true'
          #   yayayay
          @purchase.symbiote_blank.complete_symbiote(@item,@chosen_department, @pe_comment)
          reset_symbiont_department_id
          redirect_to   :controller =>  "cart"
          #else
          #    garement_recieve_transparent
          #                  flash[:notice] = 'This garment cannot receive transparent designs, choose a light garment or a different design '
          #                  redirect_to   :controller =>  "cart"
          #end
        else
          flash[:notice] = "error - this design has no default master department"
          redirect_to   :controller =>  "cart"
        end
      end
    else
      #incompat_item_not
      flash[:notice] = "Incompatible Item  not added. Please complete your in-progress Item or place it on hold to continue"  #######################################  (incomplete symbiont in progress and parameter item incompatible)
      redirect_to  :controller => 'cart'
    end
    logger.debug "end add_to_cart_incomplete_symbiont_not_on_hold-------------------------------------------------"
  end
############################################################################################################
  def add_to_cart_master
    # below we are adding a master item so we must record appropriate department for model image display.
    # if params[:department_id is aavailable, we will use it as the department, else
    # we will use  item.default_master_department_id which changes a generic department items generic department
    # into the default department, like from adult department to men's.
    # This is only temporary if the design that is placed on is a women's, the combo symbiont
    # purchases entry will need to be updated to reflect that. this would be done in section  ( 3a )
    logger.debug "begin add_to_cart_master-------------------------------------------------@item.id: #{@item.id}"
    @department = params[:department_id]
    @department = @item.default_master_department_id  if !@department
    session[:symbiont_department_id] = @department.to_s if @department
    change_at_department_to_department_id if params[:notes]
    @purchase.new_master_symbiote(@item, @quantity, @department, params[:on_hold] ||  'false')
    logger.debug "referring_action: "		+ referring_action
    if  referring_action.include?('cart')
      flash[:notice] = 'Your item was added, please complete it by choosing a design.' unless params[:on_hold]
      flash[:notice] = 'Your item was added, please complete it by clicking "Complete Combination" and choosing a design, or you may add another item on hold.' if params[:on_hold]
      redirect_to  :controller => 'cart',  :action => 'index'
    else
      redirect_to  :controller => 'store', :action => "category_items"
      logger.debug "REDIRECT CHANGED FROM BROWSE"

    end
    logger.debug "end add_to_cart_master-------------------------------------------------"
  end
############################################################################################################
  def add_to_cart_slave
    logger.debug "begin add_to_cart_slave-------------------------------------------------@item.id: #{@item.id}"
    # we will create new slave symbiote and set the master_department_id to the default for this slave items category_class
    @purchase.new_slave_symbiote(@item,@quantity, params[:on_hold])
    if  referring_action.include?('cart')
      flash[:notice] = 'Your design was added, please complete it by choosing a item' unless params[:on_hold]
      flash[:notice] = 'Your design was added, please complete it by clicking "Complete Combination" and choosing a item, or you may add another item on hold.' if params[:on_hold]
      redirect_to  :controller => 'cart',  :action => 'index'
    else
      redirect_to  :controller => 'store',:action => "category_items"
      logger.debug "REDIRECT CHANGED FROM BROWSE"
    end
  end
############################################################################################################
  def add_to_cart_singular
    logger.debug "begin add_to_cart_singular-------------------------------------------------@item.id: #{@item.id}"
    @purchases_entry = PurchasesEntry.add_singular_item(@purchase,@item,@quantity,0, @pe_comment  )
    redirect_to  :controller => 'cart',  :action => 'index'
  end
############################################################################################################
  def add_to_cart_combo
    logger.debug "begin add_to_cart_combo @item: #{@item.id}--@design: #{@design.id}"
    # below we are adding both a master and a slave item at once
    @department = params[:department_id]
    @department = @item.default_master_department_id  if !@department
    # def new_combo_symbiont(item, design, quantity, department, pe_item_comment, pe_design_comment )

    @purchase.new_combo_symbiont(@item, @design, @quantity, @department,@pe_comment ,@pe_comment )
    flash[:notice] = 'Your item was added.'
    if  referring_action.include?('cart')
      flash.keep
      redirect_to  :controller => 'cart',  :action => 'index'
    else
      flash.keep
      redirect_to  :controller => 'cart',  :action => 'index'
    end
  end
############################################################################################################

###########################################################################################################
def add_to_cart_singular_designer
  # great_working_correctly
							logger.debug "begin add_to_cart_singular_designer-------------------------------------------------@item.id: #{@item.id}"
              # item is a garment in the category_class.name of 'all_over_item'
							@purchases_entry = PurchasesEntry.add_singular_designer_item(@purchase,@item,@quantity,0, @pe_comment  )
							redirect_to  :controller => 'cart',  :action => 'index'
end
###########################################################################################################
def find_item(params)
        	logger.debug "start find_item params: #{params}"
           the_item_id = params[:item_id] || params[:design_id]

        	departments_to_search = @website.default_all_department_ids + [ '1', '5' ]
           if params[:purchases_entries]
                                   logger.debug "params[:purchases_entries]: #{params[:purchases_entries]}"
                                    ilc  =   params[:purchases_entries][:ItemLookupCode]
                                    ################## need to scope this find to website  ??
                                    @item = Item.where(" ItemLookupCode LIKE ? and department_id in (?) ",  "#{ilc}%" , departments_to_search ).first
                                     unless @item
                                                      @alias = Aliasing.where("Alias LIKE ? ",  "#{ilc}%").first
                                                      if @alias
                                                                  if departments_to_search.include?(@alias.item.department_id.to_s )
                                                                              @item = @alias.item
                                                                  end
                                                      end
                                      end
            else
                            logger.debug "NO params[:purchases_entries]"
                            if params[:item_class_component]
                                              logger.debug " params[:item_class_component][:item_id]: #{params[:item_class_component][:item_id]}"
                                              the_item_id  = params[:item_class_component][:item_id]  ## this stopped working
                                end
                                if params[:item]
                                               logger.debug " params[:item][:id]: #{params[:item][:id]}"
                                               the_item_id = params[:item][:id]
                                end
                                @item = Item.where(  "id = ? ", the_item_id  ).first
            end
             if @item
       				             logger.debug "end find_item @item: #{@item.id}"
       		 else
       		 	             	 logger.debug "end find_item NO ITEM FOUND"
       		 end
end
###########################################################################################################
def free_catalog
	if @incomplete_symbiont
		catalog_description = @website.title + ' Catalog'
		catalog_description = catalog_description[0..29]
		@free_catalog = Item.find_by_Description(catalog_description)
		if @free_catalog
			@purchase.add_free_catalog_entry(@free_catalog)
			flash[:notice] = "A free catalog was added to your shopping cart."
			redirect_back_or_default
		else
	       render :text => 'Free catalog with the following Description was not found in our system: ' +   catalog_description
	   	 end
  	else
  		redirect_to(:controller => 'specsheet', :action => 'free_catalog_details')
  		end
end
###########################################################################################################
def free_catalog_details
		catalog_description = @website.title + ' Catalog'
		catalog_description = catalog_description[0..29]
    @free_catalog = Item.find_by_Description( catalog_description )
    if @free_catalog
         redirect_to(:controller => 'specsheet', :item_id => @free_catalog )
  else
       render :text => 'Free catalog with the following Description was not found in our system: ' +  catalog_description
    end
end
###########################################################################################################
def next_checkout_step
      store_location  # if   session['return-to'].nil?
      if wholesale_only_website_logged_in_retail?
                        #flash[:notice] = "This is a wholesale only website and you are logged in with a retail account."
                        redirect_to(:controller =>  "account",  :action => 'wholesale_only_website')  ;
      else
                            logger.warn "------------------------------------begin next_checkout_step"
                            logger.warn "------------------------------------begin next_checkout_step"
                            logger.warn "------------------------------------begin next_checkout_step"
                            logger.warn "------------------------------------begin next_checkout_step"
                            logger.warn "------------------------------------begin next_checkout_step"

                          if @purchase

                                 if !@user
                                                logger.warn "-------------------------------------!@user"
                                                logger.warn "-------------------------------------!@user"
                                                logger.warn "-------------------------------------!@user"
                                                logger.warn "-------------------------------------!@user"
                                                logger.warn "-------------------------------------!@user"
                                                flash[:notice] = "To Checkout... Please Log in or create a new user to continue."
                                                redirect_to(:controller => 'account', :action => 'login')
                                 elsif !@customer
                                                  logger.warn "######################################"
                                                  logger.warn "######################################"
                                                  logger.warn "######################################"
                                                  logger.warn "######################################"
                                                  logger.warn "######################################"
                                                  logger.debug "@user.inspect: " + @user.inspect
                                                  logger.debug "@user.customer_id: " + @user.customer_id.to_s
                                                  logger.warn "######################################"
                                                  logger.warn "######################################"
                                                  logger.warn "######################################"
                                                  logger.warn "######################################"
                                                  logger.warn "######################################"
                                                  logger.warn "-------------------------------------!@customer"
                                                  logger.warn "-------------------------------------!@customer"
                                                  logger.warn "-------------------------------------!@customer"
                                                  logger.warn "-------------------------------------!@customer"
                                                  logger.warn "-------------------------------------!@customer"
                                                  logger.warn "-------------------------------------!@customer"
                                                  flash[:notice] = "Please enter your customer billing information or continue shopping."
                                                  redirect_to(:controller => 'customers', :action => 'new')
                                 elsif !@purchase.ship_to
                                                   logger.warn "-------------------------------------!@purchase.ship_to"
                                                   logger.warn "-------------------------------------!@purchase.ship_to"
                                                   logger.warn "-------------------------------------!@purchase.ship_to"
                                                   logger.warn "-------------------------------------!@purchase.ship_to"
                                                   logger.warn "-------------------------------------!@purchase.ship_to"
                                                   logger.warn "-------------------------------------!@purchase.ship_to"
                                                   logger.warn "-------------------------------------!@purchase.ship_to"
                                                   redirect_to(:controller => 'ship_tos', :action => 'index')
                               elsif !@purchase.shipping_service # && @purchase.free_catalog_purchase	== false
                                            logger.warn "--------------------------!@purchase.shipping_service && @purchase.free_catalog_purchase	== false"
                                            logger.warn "--------------------------!@purchase.shipping_service && @purchase.free_catalog_purchase	== false"
                                            logger.warn "--------------------------!@purchase.shipping_service && @purchase.free_catalog_purchase	== false"
                                            logger.warn "--------------------------!@purchase.shipping_service && @purchase.free_catalog_purchase	== false"
                                            logger.warn "--------------------------!@purchase.shipping_service && @purchase.free_catalog_purchase	== false"
                                             redirect_to(:controller => 'ship_tos', :action => 'shipping_services')
                                          #elsif !@purchase.shipping_service && @purchase.free_catalog_purchase	== true
                                           #           	logger.debug "--------------------------!@purchase.shipping_service && @purchase.free_catalog_purchase	== true"
                                          #			create_free_catalog_shipping_service
                                 elsif !@purchase.quote_tender_entry && @purchase.free_catalog_purchase	!= true
                                       logger.debug "--------------------------!@purchase.quote_tender_entry && @purchase.free_catalog_purchase	!= true"
                                      redirect_to(:controller => 'quote_tender_entries', :action => 'index')
                                 elsif !@purchase.quote_tender_entry && @purchase.free_catalog_purchase	== true
                                          logger.debug "--------------------------!@purchase.quote_tender_entry && @purchase.free_catalog_purchase == true"
                                      create_free_catalog_quote_tender_entry
                                 elsif @purchase.shipping_service	&& @purchase.ups_shipping_price  == 'shipping service unavailable'
                                    flash[:notice] = "Shipping service not available for chosen zipcode, please change Zipcode or Shipping service."
                                    redirect_to(:controller => 'ship_tos', :action => 'shipping_services')
                                  elsif @customer && @purchase.ship_to && @purchase.shipping_service && @purchase.quote_tender_entry
                                  logger.debug "-------------------------------------@purchase.shipping_service.id: #{@purchase.shipping_service.id}"
                                  logger.debug "-------------------------------------@purchase.quote_tender_entry.tender_id: #{@purchase.quote_tender_entry.tender_id}"
                                  logger.debug "-------------------------------------@purchase.subtotal_after_all_discounts: #{@purchase.subtotal_after_all_discounts}"
                                      if @purchase.shipping_service.id == 25 && @purchase.quote_tender_entry.tender_id == 10 && @purchase.subtotal_after_all_discounts > 0.0
                                          logger.debug "-------------------------------------delete shipping service and quote_tender_entry and send them back to shipping"
                                          flash[:notice] = 'Please enter a different shipping service and payment type.'
                                          delete_free_catalog_shipping_service_and_quote_tender_entry
                                        elsif  ['4','13','14','15'].include?(@purchase.shipping_service_id.to_s) and ['12','14'].include?(@purchase.quote_tender_entry.tender_id.to_s)
                                          flash[:notice] = 'USPS Cannot be used with COD, please change payment method or shipping service.'
                                          redirect_to(:controller => 'quote_tender_entries', :action => 'index')
                                      else
                                          logger.debug "-------------------------------------all clear for checkout_review"
                                            redirect_to(:controller => 'purchases', :action => 'checkout_review')
                                        end

                                  else
                                              logger.warn "-------------------------------------next_checkout_step final else"
                                              logger.warn "-------------------------------------next_checkout_step final else"
                                              logger.warn "-------------------------------------next_checkout_step final else"
                                              logger.warn "-------------------------------------next_checkout_step final else"
                                              logger.warn "-------------------------------------next_checkout_step final else"
                                             flash[:notice] = "To Checkout... Please Log in or create a new user to continue." unless @user
                                             redirect_to(:controller => 'account', :action => 'login')
                                  end
                          else
                                    logger.warn "-------------------------------------next_checkout_step not purchase"
                                    logger.warn "-------------------------------------next_checkout_step not purchase"
                                    logger.warn "-------------------------------------next_checkout_step not purchase"
                                    logger.warn "-------------------------------------next_checkout_step not purchase"
                                    logger.warn "-------------------------------------next_checkout_step not purchase"
                                    logger.warn "-------------------------------------next_checkout_step not purchase"
                                   flash[:notice] = "Please begin a purchase to continue." unless @user
                                         redirect_to(:controller =>  'cart', :action => 'index')
                          end
      end
      logger.warn "------------------------------------end next_checkout_step"
      logger.warn "------------------------------------end next_checkout_step"
      logger.warn "------------------------------------end next_checkout_step"
      logger.warn "------------------------------------end next_checkout_step"
      logger.warn "------------------------------------end next_checkout_step"
      logger.warn "------------------------------------end next_checkout_step"
      logger.warn "------------------------------------end next_checkout_step"
end
##########################################################################################################
  def place_incomplete_symbiont_on_hold
    #            begin
    if  @purchase and @purchase.symbiote
                  @purchases_entry = @purchase.symbiote
                  @purchases_entry_opposite = @purchases_entry.opposite_entry
                  @purchases_entry.on_hold = 1
                  @purchases_entry_opposite.on_hold = 1
                  @purchases_entry.save
                  @purchases_entry_opposite.save
                  flash[:notice] = "Your chosen item was placed on hold"
    else
                     logger.debug "place_incomplete_symbiont_on_hold not at purchase or @purchase.symbiote"
    end
                    if  referring_action.include?('cart')
                                   redirect_to(:controller =>  'cart',:action => 'index')
                    else
                                  redirect_to :back
                    end

  end
##########################################################################################################
def place_symbiont_on_hold
	#begin
			if  params[:purchases_entry_id]
						@purchases_entry = @purchase.symbiote
						@purchases_entry_opposite = @purchases_entry.opposite_entry
						@purchases_entry.on_hold = 1
						@purchases_entry_opposite.on_hold = 1
		            	@purchases_entry.save
		            	@purchases_entry_opposite.save
		                flash[:notice] = "Your item was placed on hold"
		      			if  referring_action.include?('cart')
						            redirect_to(:controller =>  'cart',:action => 'index')
						  else
						            redirect_to(:controller =>  'cart',:action => 'index')
                        logger.debug "REDIRECT CHANGED FROM BROWSE"
						end
			end
#	rescue
#			redirect_to :back
#			flash[:notice] = "No item was found to place on hold."
#			UserNotifier.deliver_named_error(@user, @website, @purchase, params, 'nothing_placed_on_hold' )
#	end
end
###########################################################################################################
def delete_incomplete_symbiote
           begin
                if  @purchase and @purchase.symbiote
                                  @purchase.symbiote.destroy
                                  @purchase.symbiote_blank.destroy
                                  flash[:notice] = "Your chosen item was forgotten"
                                  params.delete(  :purchases_entry_id   )

                                  logger.debug  "test params to see if purchases_entry_id is deleted"
                                 logger.debug "params.inspect: " + params.inspect


                                  if referring_action
                                            if  referring_action.include?('cart')
                                                      redirect_to(:controller => 'cart' ,:action => 'index')
                                            else
                                                     redirect_to :back
                                                    logger.debug "REDIRECT CHANGED FROM BROWSE"
                                            end
                                  else
                                             redirect_to :back
                                  end
                else
                                       redirect_to :back
                end
           rescue
                            flash[:notice] = "rescued from :back error."
                            redirect_to(:controller =>  'store',:action => 'category_items')
             #end
  end

      #			rescue
      #				redirect_to :back
      #				flash[:notice] = "Could not find incomplete item. Nothing was forgotten."
      #				UserNotifier.deliver_named_error(@user, @website, @purchase, params, 'delete_incomplete_symbiote' )
      #			end
end
############################################################################################################
def complete_this_combination
		unless @incomplete_symbiont
					@purchases_entry = PurchasesEntry.find(params[:purchases_entry_id])
					if  @purchases_entry
								@purchases_entry.on_hold = 0
								@purchases_entry_opposite_entry = 	@purchases_entry.opposite_entry
								@purchases_entry_opposite_entry.on_hold = 0
				                @purchases_entry.save
				                @purchases_entry_opposite_entry.save
					            if @purchases_entry.item.category.category_class.item_type == 'master'
					                flash[:notice] = "Your item was taken off hold, please choose a design using the red button or the QuickCart."
				            	else
					                flash[:notice] = "Your design was taken off hold, please choose a item using the red button or the QuickCart."
				                end if @purchases_entry.item
				      			if  referring_action.include?('cart')
								redirect_to(:controller =>  'cart',:action => 'index')
								else
								redirect_to(:controller =>  'cart',:action => 'index')
 logger.debug "REDIRECT CHANGED FROM BROWSE"
								end
					else
						      	 flash[:notice] = "No entry found"
						      	if  referring_action.include?('cart')
								redirect_to(:controller =>  'cart',:action => 'index')
								else
								redirect_to(:controller =>  'cart',:action => 'index')
 logger.debug "REDIRECT CHANGED FROM BROWSE"
								end
					end
		else
		 flash[:notice] = "Only one item can be completed at once. Compete your current item, place it on hold or forget it"
		redirect_back_or_default(:controller =>  'cart')
		end
end
###########################################################################################################
def delete_symbiont_purchases_entry
         begin
                purchases_entry  = @purchase.purchases_entries.find(params[:purchases_entry_id])
                purchases_entry_opposite = purchases_entry.opposite_entry
                purchases_entry.destroy
                purchases_entry_opposite.destroy
              flash[:notice] = "Item was deleted"
                   redirect_to  :controller => 'cart'
         rescue
                    redirect_to :back
           end
end
############################################################################################################
def delete_purchases_entry
      begin
       @purchases_entry = @purchase.purchases_entries.find(params[:purchases_entry_id])
        purchase = @purchases_entry.purchase
        @purchases_entry.destroy
        flash[:notice] = "Item was deleted"
         redirect_to  :controller => 'cart',  :action => 'index'
       rescue
         redirect_to  :controller => 'cart',  :action => 'index'
        end
end
############################################################################################################
def delete_all_purchases_entries
        PurchasesEntry.delete_all  "purchase_id = #{@purchase.id}"
        flash[:notice] = "Items were deleted"
         redirect_to  :controller => 'cart',  :action => 'index'
end
############################################################################################################
def delete_all_on_hold_items
	for pe in @purchase.purchases_entries
		pe.destroy if pe.on_hold == 1
	end
  	 flash[:notice] = "Your on hold items have been deleted"
  	if  referring_action.include?('cart')
	redirect_to(:controller => 'cart',:action => 'index')
	else
	redirect_to(:controller =>  'cart',:action => 'index')
 logger.debug "REDIRECT CHANGED FROM BROWSE"
	end
end	
############################################################################################################
def enlarge_cart_image
            @purchases_entry  = PurchasesEntry.find(params[:purchases_entry_id])
           @item = @purchases_entry.item
             render(:partial => "shared/enlarge_cart_image",:layout => 'printable')
end
############################################################################################################
def show_discount_info
             render(:partial => "show_discount_info",:layout => 'printable')
end
############################################################################################################
def show_cc_code_info
             #render :layout => "printable"
             #render(:partial => "shared/show_cc_code_info",:layout => 'printable')
end
############################################################################################################
def ensure_positive_quantity(quantity)
                        if quantity.to_i >= 1
                          @quantity =quantity.to_i
                      else
                          @quantity = 1
                      end
end
###########################################################################################################
def fails_membership_requirement?(item)
    if @customer_array.CustomText4  != 'DO'   &&   item.department.license_required == true   &&   @customer_array.PriceLevel == 2
                       if @customer
                              flash[:notice] = "This item requires dixie outfitters license. Call 1-866-916-5866 for details"
                        else
                              flash[:notice] = "Please log in. This item requires that you are logged in and have a dixie outfitters license. Call 1-866-916-5866 for info if you do not have one."
                        end
           true
    else
            false
    end
end
############################################################################################################
def purchase_in_progress?
   unless @purchase
                  flash[:notice] = "Please begin a new purchase"
                  redirect_to(:controller =>  'cart' ,:action => 'index')
                false
    end
end
############################################################################################################
def incomplete_symbiont?
            if @purchase
                            if @purchase.incomplete_symbiont == true
                                    flash[:notice] = "You have an incomplete item"
                                   redirect_to( :controller =>  'cart', :action => 'index' )
                             end
            end
end
############################################################################################################
def color_compatible(item,design)
	logger.debug "-------------------------------------color_compatible .shade check: item: #{item.shade.downcase} - design: #{design.shade.downcase}"
	if item.shade.downcase == 'colored' && design.shade.downcase == 'transparent'
		'false'
	else
		'true'
	end
end
###########################################################################################################
############################################################################################################
  def wholesale_only_website_logged_in_retail?
    if @purchase
      if @customer
        if @customer.PriceLevel == 0   and  @website.name == "barber_store"
          logger.debug "retail customer is logged in to barber_store!!"
          logger.debug "retail customer is logged in to barber_store!!"
          true


        else
          logger.debug "PriceLevel not 0 or website.name not barber_store"
          false
        end
      else
        logger.debug "not @customer"
        false
      end
    else
      logger.debug "not @purchase"
      false
    end
  end
###########################################################################################################























#  def ajax_add_to_cart_combo
##								logger.debug "begin add_to_cart_combo @item: #{@item.id}--@design: #{@design.id}"
## below we are adding both a master and a slave item at once
#    ensure_positive_quantity(params[:QuantityOnOrder])
#    Item.unscoped do
#      if @item
#        at_item
#      end
#      @item = Item.find params[:item_id]
#      @design = Item.find params[:design_id]
#    end
##								@department = params[:department_id]
##								@department = @item.default_master_department_id  if !@department
#    @pe_item_comment = '@pe_item_comment'
#    @pe_design_comment = '@pe_design_comment'
#    @purchase.new_combo_symbiont(@item, @design, @quantity, @department, @pe_item_comment, @pe_design_comment)
#
#    @from_ajax = true
#    @status = "Saved"
#    render :partial => 'designer_specsheet/item_status_bar'
#  end
#############################################################################################################



end
