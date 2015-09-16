class PurchasesController < ApplicationController

ssl_exceptions :update
before_filter :logged_in_user?
before_filter :initialize_variables, :only => [:checkout_receipt, :checkout_review, :complete_order,:cancel_order,:update]

#before_filter    :redirect_if_incomplete_symbiont, :redirect_unless_purchase_in_progress , :only => [ :checkout_receipt, :checkout_review ]

#layout 'printable', :only => ['checkout_receipt','checkout_receipt']
#layout :resolve_layout

#before_filter :user_with_customer? , :except => [:new,  :create, :update, :cancel_order, :index]
#before_filter  :purchase_in_progress? , :except => [ :cancel_order, :update, :index, :new ]
#before_filter :incomplete_symbiont?, :except => [ :cancel_order, :update, :index, :new ]
#  after_filter :flash_to_json_header

##################  CLOSE CONTROLLER ACCESS-----------DANGEROUS !!!!!!!!!!!!!
##################  CLOSE CONTROLLER ACCESS-----------DANGEROUS !!!!!!!!!!!!!

#before_filter :redirect_unless_admin  , :except => [:checkout_review]


 def update_junk

   #
   ##people = { 1 => { "first_name" => "David" }, 2 => { "first_name" => "Jeremy" } }
   ##PurchasesEntries.update(people.keys, people.values)
   #
   #
   #params[:purchase].each do |attributes|
   #                      logger.warn "####################################### attributes: " + attributes.inspect
   #                      g = "g"
   #                      #purchases_entry = @purchase.purchases_entries.detect {|pe| pe.id == attributes[1][0][:id] }
   #                      #
   #                      #@purchase.purchases_entries.each do |pe|
   #                      #             if pe.id == attributes[1][0][:id]
   #                      #end
   #
   #
   #                      people = { 1 => { "first_name" => "David" }, 2 => { "first_name" => "Jeremy" } }
   #                      PurchasesEntries.update(people.keys, people.values)
   #
   #
   #
   #                      logger.warn "####################################### purchases_entry.id " + purchases_entry.id.to_s
   #                      purchases_entry_opposite_entry =  purchases_entry.opposite_entry if purchases_entry.opposite_entry != false
   #                      purchases_entry.attributes = attributes
   #                      purchases_entry_opposite_entry.attributes = attributes     if purchases_entry_opposite_entry
   #                      purchases_entry.save!(:validate=> false)
   #                      purchases_entry_opposite_entry.save(:validate=> false)  if purchases_entry_opposite_entry
   #
   #                      purchases_entry.destroy if purchases_entry.QuantityOnOrder <= 0.0
   #                      if purchases_entry_opposite_entry
   #                        purchases_entry_opposite_entry.destroy  if  purchases_entry_opposite_entry.QuantityOnOrder <= 0.0
   #                      end
   #          end
   #
   #
   #
   #           delete_purchase_cache
   #


end




  def update
                logger.warn "##################################!"
                logger.warn "##################################!"
                logger.warn "##################################!"
                  #	if params[:purchase][:purchases_entry_attributes][0].to_a[0][1] != '0'  ## crappy way, not gonna do it.
                  #		begin
                   if params[:purchase]
                             logger.warn "-------------------------------------params[:purchase]: #{params[:purchase]}"
                   else
                                  logger.warn "params purchase is nil!!!"
                                  logger.warn "params purchase is nil!!!"
                                  logger.warn "params purchase is nil!!!"
                                  logger.warn "params purchase is nil!!!"
                                  logger.warn "params purchase is nil!!!"
                   end
                  if params[:purchase] and params[:purchase][:purchases_entry_attributes]
                                 logger.debug "-------------------------------------params[:purchase]: #{params[:purchase][:purchases_entry_attributes]}"
                  else
                                  logger.warn " params[:purchase][:purchases_entry_attributes] IS NIL!!!"
                                  logger.warn " params[:purchase][:purchases_entry_attributes] IS NIL!!!"
                                  logger.warn " params[:purchase][:purchases_entry_attributes] IS NIL!!!"
                                  logger.warn " params[:purchase][:purchases_entry_attributes] IS NIL!!!"
                                  logger.warn " params[:purchase][:purchases_entry_attributes] IS NIL!!!"
                    end
                    #respond_to do |format|
                                    #	      if Purchase.update( @purchase.id , params[:purchase])
                                    #          $stdout.puts "params[:purchase] : " + params[:purchase]
                                  # logger.warn "params[:purchase]" + params[:purchase].inspect
                                  # logger.warn "@purchase.update_attributes(params[:purchase]"
                                  #  #if @purchase.update_attributes(params[:purchase])
                                  #@purchase.update_attributes(params[:purchase])
                                  #  delete_purchase_cache
                                  #  flash[:notice] = 'Quantity was successfully updated.'
                                    #format.html { redirect_to :back}
                                                    #  format.html { redirect_to :controller => @website.name , :action => 'display_cart' }
                                                    # format.html { redirect_to purchase_url(@purchase) }
                                                    #format.xml  { head :ok }
                                    #else
                                    #              format.html { render :action => "edit" }
                                    #              format.xml  { render :xml => @purchase.errors.to_xml }
                                    #end
                    #end
                    #	    rescue
                    #	    	flash[:notice] = "Error updating. Please be sure all quantity areas have a number in them."
                    #	    	redirect_to :back
                    #	  	end

                logger.warn "params[:purchase]" + params[:purchase].inspect
                logger.warn "@purchase.update_attributes(params[:purchase]"
                @purchase.update_attributes(params[:purchase])
                delete_purchase_cache
                flash[:notice] = 'Quantity was successfully updated.'

                redirect_to  '/cart'

                    logger.warn "##################################!"
                    logger.warn "##################################!"
                    logger.warn "##################################!"
  end
################################################################################################################
 def delete_purchase_session
           #delete_user_session_cache
           #delete_user_cache
           #delete_customer_cache
           delete_purchase_cache
           Caching::MemoryCache.instance.delete  request.session_options[:id] + '_user_session'
           Caching::MemoryCache.instance.delete  request.session_options[:id] + '_user'
           Caching::MemoryCache.instance.delete  request.session_options[:id] + '_customer'
           Caching::MemoryCache.instance.delete  request.session_options[:id] + '_purchase'
           reset_session
end
################################################################################################################
  def checkout_receipt
        if @purchase
                logger.warn "@purchase.id : #{@purchase.id}"
                prepare_purchase_totals(@purchase)
                prepare_checkout_variables
                logger.warn('BEGIN PURCHASE TOTAL')
                logger.warn(@purchase.subtotal_after_all_discounts)
                logger.warn('END PURCHASE TOTAL')
                begin
                        send_affiliate_emails
                rescue
                        logger.warn "send_affiliate_emails delivery error!"
                end

                begin
                         # UserNotifier.deliver_purchase_confirmation(@user, @website, @purchase, @customer )


                            UserMailer.purchase_confirmation(@user, @website, @purchase , @customer ).deliver


                rescue
                         logger.warn "UserNotifier delivery failure"
                end

                # discount_savings = @purchase.discount_savings
                # if discount_savings > 0
                #   @discount_savings = @purchase.add_discount_item(discount_savings)
                #           logger.debug "----------------------------------discount given-amt: #{discount_savings}"
                # else
                #            logger.debug "-------------------------------------discount not given."
                # end

                online_discount_savings = @purchase.online_discount_savings
                if online_discount_savings > 0
                        @online_discount_item = @purchase.add_online_discount_item(online_discount_savings)
                         logger.debug "-------------------------------------online discount given-amt: #{online_discount_savings}"
                else
                        logger.debug "-------------------------------------online discount not given."
                end

                @purchase_cod_charge = 8.5 if [12,14].include?(@purchase.quote_tender_entry.tender.id)
                if @purchase_cod_charge
                      @cod_item  =  @purchase.add_cod_item
                end
                delete_purchase_session
        else
                   redirect_to  '/'
        end
  end
################################################################################################################
def complete_order
       @purchase.purchases_entries.each do |purchases_entry|
             purchases_entry.FullPrice = purchases_entry.FullPrice
             if @customer.CurrentDiscount > 0
                      purchases_entry.Price = purchases_entry.item.unit_quantity_tier_discount_price(@customer , purchases_entry.QuantityOnOrder )
             else
                       purchases_entry.Price = purchases_entry.item.your_unit_price(@customer,purchases_entry.QuantityOnOrder)
             end
             ####################################  SOMETHINGS WRONG HERE.. DOUBLE DISCOUNTING
             if @purchase.tax_amount > 0
             	is_taxable = true
         	else
         		is_taxable = false
         	 end
             purchases_entry.Taxable = is_taxable
             purchases_entry.extended_tax
             purchases_entry.save
       end
          #@puchase.customer_id = @customer.id
          @purchase.Time = Time.now
       	   @purchase.Type = 3
           @purchase.ReferenceNumber = '0-mob-' + @website.domain
#           @purchase.Comment = 0
           @purchase.Total = @purchase.subtotal_after_all_discounts
           @purchase.Tax = @purchase.tax_amount
           @purchase.ShippingChargeOverride = true
           @purchase.ShippingChargeOnOrder = @purchase.ups_shipping_price
        if @purchase.save
	          flash[:notice] = 'Thanks, Your order was completed.'
	          redirect_to(:controller => 'purchases', :action => 'checkout_receipt' )
        else
      	  	flash[:notice] = 'Error Occured while saving your order, please call sales.'
        	redirect :back
   		end
end
################################################################################################################
def checkout_review
             if @customer && @purchase.ship_to && @purchase.shipping_service  && @purchase.quote_tender_entry
		                  prepare_purchase_totals(@purchase)
		                  prepare_checkout_variables
             else
                    redirect_to :controller => 'cart' , :action => "next_checkout_step"
             end
end
################################################################################################################
def send_affiliate_emails
           if @purchase.affiliate_with_referer
			            logger.warn "@purchase.affiliate_user"
			            begin
			            	if @purchase.affiliate_user.email == @user.email
			            			logger.warn "USER WAS SAME AS AFFILIATE, IGNORED"
			            	else
			            			logger.warn "ABOUT TO SEND AFFILIATE SALE NOTIFICATION"
			           		 		UserNotifier.deliver_affiliate_sale_notification( @website, @purchase )
			           		end
			              rescue
			              	logger.warn "UserNotifier delivery failure of affiliate_sale_notification"
			             end  
			 
				 			if @user.recruiter
				 					logger.warn "@user.recruiter"
					 				begin
					           			 UserNotifier.deliver_affiliate_recruiter_sale_notification( @user.recruiter , @website, @purchase )
					              rescue
					              	logger.warn "UserNotifier delivery failure of affiliate_recruiter_sale_notification"
					             end 
				 			else
				 					logger.warn "NO @user.affiliate_user.recruiter"
				 			end
			 
			 
			             begin
			             	logger.warn "ABOUT TO SEND AFFILIATE ADMIN SALE NOTIFICATION"
			           		 UserNotifier.deliver_affiliate_sale_notification_admin( @user, @website, @purchase )
			              rescue
			              	logger.warn "UserNotifier delivery failure of affiliate_sale_notification_admin"
			             end  
			else
					logger.warn "NOT @purchase.affiliate_user"
			end
end
################################################################################################################
  ################################################################################################################
  def resolve_layout
    case action_name
      when "checkout_review", "checkout_receipt"
        "printable"
#    when "index"
#      "other_layout"
      else
        "printable"
    end
#  end
  end

  ################################################################################################################
  def prepare_checkout_variables
    @purchases_entries = PurchasesEntry.find(:all,:conditions => ["purchase_id = ? ",session[:purchase_id] ] , :order => "id ASC"  )
    @quote_tender_entry = QuoteTenderEntry.find_by_purchase_id(@purchase.id)
    @ship_to = @purchase.ship_to
  end
################################################################################################################
  def cancel_order
    @purchase.purchases_entries.each do |pe|
      pe.destroy
    end
    @purchase.destroy
    Caching::MemoryCache.instance.delete request.session_options[:id]  + '_user_session'
    Caching::MemoryCache.instance.delete request.session_options[:id] + '_user'
    Caching::MemoryCache.instance.delete request.session_options[:id] + '_customer'
    Caching::MemoryCache.instance.delete request.session_options[:id] + '_purchase'
    reset_session
    flash[:notice] = 'Your purchase was forgotten.'
    redirect_to(:controller =>@website.name, :action => 'index' )
  end
################################################################################################################
#def checkout_receipt
#             if @customer && @purchase.ship_to && @purchase.shipping_service && @purchase.quote_tender_entry
#		                  prepare_purchase_totals(@purchase)
#		                  prepare_checkout_variables
#
#		        else
#                   redirect_to :controller => 'cart' , :action => "next_checkout_step"
#            end
#end
################################################################################################################
#deprecate
#scope_controller_model :purchases, :conditions => {:customer => Proc.new { |c| c.send( :this_customer ) } }

                              #                      flash[:notice] = 'Model.Attribute was successfully updated.'
                              #render :layout => false, :inline => @customer.send(@the_field_name)  # EXTREMELY DANGEROUS
#                   render :layout => false, :inline => @the_value
#	    rescue
#              flash[:notice] = "Error updating. Please be sure all quantity areas have a number in them."
#               render :layout => false, :inline => 'SORRY,ERROR'
#	  	end
#                              render :layout => false, :inline => @customer.instance_variable_get(   '@' +  @the_field_name ).to_s
#                           $stdout.puts '@the_current_value' + @customer.instance_variable_get(   '@' +  @the_field_name ).to_s
#                            @the_current_value  == @customer.instance_variable_get(   '@' +  @the_field_name ).to_s
#                          if  @the_current_value  == @the_value
#                            $stdout.puts " IT WORKED "
#                                 $stdout.puts " @customer.errors.size " +  @customer.errors.size.to_s
#                                 $stdout.puts "@customer.instance_variable_get(   '@' +  @the_field_name ).to_s" + @customer.instance_variable_get(   '@' +  @the_field_name ).to_s

#layout 'printable'



#
#   def in_place_edit_ship_to
#     logger.debug "BEGIN -------------------------------------in_place_edit_ship_to"
#
#                         startup_purchase
#                             @the_field_name = params[:editorId][6..25]
#                             @the_value = params[:value]
#
#
#                                if @purchase.ship_to.update_attributes(  @the_field_name  =>    @the_value           )
#                                          flash[:notice] ||= "Successfully updated comment."
#                                             render :layout => false, :inline =>  params[:value].to_s
#
#                               else
#                                                flash[:notice] ||= "Attention: " + @purchase.ship_to.errors.to_s.inspect.to_s
#                                               render :layout => false, :inline =>     @purchase.errors.to_s.inspect.to_s , :status => 444 # @customer.errors.to_s
#
#                               end
#
#
#   def in_place_edit_ship_to_other
#     logger.debug "BEGIN -------------------------------------in_place_edit_ship_to"
#
#                         startup_purchase
#                             @the_field_name = params[:editorId][6..25]
#                             @the_value = params[:value]
#
#                            if @purchase.ship_to.update_attributes(  @the_field_name  =>    @the_value           )
#                              @purchase.reload
#
#                              flash[:success] = "Successfully updated comment."
##                              render :partial => 'show'
#                               render :layout => false, :inline =>  params[:value].to_s
#                            else
#                              flash[:invalid] = @purchase.errors.full_messages
##                              render :partial =>  'edit', :status => 444
#                               render :layout => false, :inline =>     @purchase.errors.to_s.inspect.to_s
#                            end
#
#
##     if @comment.save
##    @comment.reload
##
##    flash[:success] = "Successfully updated comment."
##    render :partial => 'show'
##  else
##    flash[:invalid] = @comment.errors.full_messages
##    render :partial =>  'edit', :status => 444
##  end
#
#
#
#
#   logger.debug "END -------------------------------------in_place_edit_ship_to"
# end
#
#
#
#
#
#   logger.debug "END -------------------------------------in_place_edit_ship_to"
# end
#
#
#
#
#   def in_place_edit_ship_to_simple
#     logger.debug "BEGIN -------------------------------------in_place_edit_ship_to"
#
#                         startup_purchase
#                             @the_field_name = params[:editorId][6..25]
#                             @the_value = params[:value]
#
#
#                                if @purchase.ship_to.update_attributes(  @the_field_name  =>    @the_value           )
#
#                                             render :layout => false, :inline =>  params[:value].to_s
#
#                               else
#                                               render :layout => false, :inline =>     @purchase.errors.to_s.inspect.to_s  # @customer.errors.to_s
#
#                               end
#
#
#
#   logger.debug "END -------------------------------------in_place_edit_ship_to"
# end
#
#
#
# def in_place_edit_customer
#   logger.debug "BEGIN -------------------------------------in_place_edit_customer"
#                 @the_field_name = params[:editorId]
#                 @the_value = params[:value]
#                  if @customer.update_attributes!(  @the_field_name  =>    @the_value           )
#
#                                 render :layout => false, :inline =>  params[:value].to_s
#
#                          else
#                                   render :layout => false, :inline =>  @customer.errors.inspect  # @customer.errors.to_s
#
#                          end
#   logger.debug "END -------------------------------------in_place_edit_customer"
# end

# def in_place_edit_ship_to
#     logger.debug "BEGIN -------------------------------------in_place_edit_ship_to"
#
#                         startup_purchase
#                             @the_field_name = params[:editorId][6..25]
#                             @the_value = params[:value]
#
#
#                             $stdout.puts "VALID: " + ShipTo.valid_attribute?( :Zip ,    @the_value ).to_s
#
#                                if ShipTo.valid_attribute?( @the_field_name.to_sym  ,    @the_value ).to_s
#                                              @purchase.ship_to.update_attributes(  @the_field_name  =>    @the_value           )
#                                             render :layout => false, :inline =>  params[:value].to_s
#
#                               else
#                                               render :layout => false, :inline =>     @purchase.errors.to_s.inspect.to_s  # @customer.errors.to_s
#
#                               end
#
#   logger.debug "END -------------------------------------in_place_edit_ship_to"
# end

#                rescue ActiveRecord::RecordInvalid => invalid
#                          replace_html 'checkout_review_alerts',  invalid.record.errors.to_s
                          #checkout_review_alerts
                         # render :layout => false, :inline =>    invalid.record.errors.to_s
#             end



  # GET /purchases
#  # GET /purchases.xml
#  def index
#    @purchases = Purchase.where("Type = ? ", 2  ).order("id DESC")
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @purchases }
#    end
#  end
#
#  # GET /purchases/1
#  # GET /purchases/1.xml
#  def show
#    @purchase = Purchase.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @purchase }
#    end
#  end
#
#  # GET /purchases/new
#  # GET /purchases/new.xml
#  def new
#    @purchase = Purchase.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @purchase }
#    end
#  end
#
#  # GET /purchases/1/edit
#  def edit
#    @purchase = Purchase.find(params[:id])
#  end
#
#  # POST /purchases
#  # POST /purchases.xml
#  def create
#    @purchase = Purchase.new(params[:purchase])
#
#    respond_to do |format|
#      if @purchase.save
#        format.html { redirect_to(@purchase, :notice => 'Purchase was successfully created.') }
#        format.xml  { render :xml => @purchase, :status => :created, :location => @purchase }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

#  # PUT /purchases/1
#  # PUT /purchases/1.xml
#  def update_dangerous_never_use
#    @purchase = Purchase.find(params[:id])
#
#    respond_to do |format|
#      if @purchase.update_attributes(params[:purchase])
#        format.html { redirect_to(@purchase, :notice => 'Purchase was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @purchase.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /purchases/1
#  # DELETE /purchases/1.xml
#  def destroy
#    @purchase = Purchase.find(params[:id])
#    @purchase.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(purchases_url) }
#      format.xml  { head :ok }
#    end
#  end


end
