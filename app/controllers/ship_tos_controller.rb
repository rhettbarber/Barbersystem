class ShipTosController < ApplicationController
ssl_exceptions
before_filter  :initialize_variables
before_filter :user_with_customer?
before_filter  :redirect_unless_purchase_in_progress ,:redirect_if_incomplete_symbiont,  :only => [ :shipping_services, :show_chosen, :index, :new ,:show, :edit ]

skip_before_filter :verify_authenticity_token, :only => [:destroy]


############################################################################################################
  def update
    @ship_to =  @user.customer.ship_tos.find(params[:id])
    @purchase.reset_shipping_service_id
    respond_to do |format|
    	 @ship_to.Country =  'United States' #params[:USPSCountries][:Country][0..19]
      if @ship_to.update_attributes(params[:ship_to])
        delete_customer_cache
      	flash[:notice] = 'ShipTo was successfully updated.'
        format.html { redirect_to ship_to_url(@ship_to) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ship_to.errors.to_xml }
      end
    end
  end
############################################################################################################
def shipping_services
              logger.debug "flash notice: " + flash[:notice].to_s
					#@purchase = Purchase.find(session[:purchase_id])
#          					@purchase = Purchase.includes(:ship_to, :shipping_service ).where("id = ?", session[:purchase_id]).first
                      if @purchase.ship_to
                        #             if @purchase.free_catalog_purchase
                        #                      # do nothing with free catalog purchase
                        #             else
                        #                     @shipping_services = ShippingService.available_services
                        #                     @zipcode =  params[:zipcode]
                        #             end
                        #t = "t"
                      else
                                  flash[:notice] = 'Please choose a Shipping Address before selecting a service type..'
                                  redirect_to(:controller => 'ship_tos', :action => 'index')
                      end
end 
############################################################################################################
def set_shipping_charge_on_order
  g = "g"
      if params[:shipping_service_id].nil?
                  flash[:notice] = 'Please select a shipping service type.'
                    respond_to do |format|
                      format.html { redirect_to  :controller => 'ship_tos', :action => 'shipping_services' }
                    end
      else
                          if @purchase

                                             @shipping_service =  ShippingService.find_by_Code(  params[:shipping_service_id]  )

                                                @purchase.shipping_service_id =  @shipping_service.id
                                                if @purchase.save
                                                              if params[:default_this_shipping_method] == '1'  && @customer
                                                                  @customer.default_shipping_service_id = @purchase.shipping_service_id
                                                                  @customer.save
                                                                  delete_customer_cache
                                                              end
                                                             delete_purchase_cache
                                                              flash[:notice] = 'Shipping Service set.'
                                                               redirect_to(:controller => 'cart', :action => 'next_checkout_step' )
                                                else
                                                        flash[:notice] = 'Purchase save failed.'
                                                        redirect_to(:controller => 'ship_tos', :action => 'shipping_services')
                                              end
                    else
                                          flash[:notice] = 'Purchase must be in progress.'
                                        redirect_to(:controller => 'ship_tos', :action => 'shipping_services')
                    end
        end
end
############################################################################################################
def choose_ship_to
                if params[:ship_to_id]
                			logger.warn "@purchase.frozen?-----------: #{@purchase.frozen?}"
                             @ship_to =  @customer.ship_tos.find(params[:ship_to_id])
                             @purchase.ship_to_id  = @ship_to.id
                              @purchase.reset_shipping_service_id
                             if @purchase.save
                                        delete_purchase_cache
                                        #session[:checkout_ship_to] = true
                                        redirect_to(:controller => 'cart', :action => 'next_checkout_step' )
                            else
                                        flash[:notice] = 'Your choice could not be saved, please correct any mistakes.'
                                           redirect_to(:action => 'edit' ,:id => params[:ship_to_id] )
                            end
                else
                        if @user.customer.ship_tos.count == 1
                                     @purchase.ship_to  = @user.customer.ship_tos.first
                                     @purchase.save
                                      redirect_to(:controller => 'cart', :action => 'next_checkout_step' )
                        else	       
                                      flash[:notice] = '-Please choose a ship to Address.'
                                       redirect_to :back
                    	end
              end
end
############################################################################################################
def show_chosen
    @ship_to =  @purchase.ship_to if @purchase
        if @ship_to
                  respond_to do |format|
                    format.html # show.rhtml
                    format.xml  { render :xml => @ship_to.to_xml }
                  end
        else
            redirect_to(:controller => 'ship_tos', :action => 'index') 
        end
end
############################################################################################################
  def index            
  	            @ship_tos = @customer.ship_tos
                                  if @ship_tos
                                         #flash[:notice] = 'Your stored ship to addresses are below.' if flash[:notice].nil?
                                          respond_to do |format|
                                            format.html # index.rhtml
                                            format.xml  { render :xml => @ship_tos.to_xml }
                                          end
                                   else
                                          flash[:notice] = 'No ship to addresses found, please create new shipping address.'
                                          redirect_to(:controller => 'ship_to', :action => 'new') 
                                    end 
end
############################################################################################################
  def show
    if params[:id]
            @ship_to =  @user.customer.ship_tos.find(params[:id])
    else
            @ship_to =  @purchase.ship_to
    end
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @ship_to.to_xml }
    end
  end
############################################################################################################
  def new
    @ship_to = ShipTo.new    
  end
############################################################################################################
  def edit
    user_customer   =  @user.customer
    logger.warn "##############################################"
    logger.warn "---------------------------------------------"
    logger.warn "##############################################"
    logger.warn "##############################################"
    logger.warn "##############################################"
    logger.warn "##############################################"
    logger.warn "@user.customer.inspect: " + user_customer.inspect
    logger.warn "##############################################"
    logger.warn "##############################################"
    logger.warn "##############################################"
    logger.warn "---------------------------------------------"
    logger.warn "##############################################"
    @ship_to =  user_customer.ship_tos.find(params[:id])
  end
############################################################################################################
  def create
#    @ship_to.customer_id = @customer.id THINK ERROR WAS HERE. POSTING TO WRONG PEOPLES RECORDS
#  	debugger
    @ship_to = @user.customer.ship_tos.new(params[:ship_to])
    @ship_to.Country = 'United States' #params[:USPSCountries][:Country][0..19]
    @ship_to.store_id = 1
    @ship_to.EmailAddress = @user.email
    respond_to do |format|
      if @ship_to.save
      	delete_customer_cache
      	flash[:notice] = 'ShipTo was successfully created.'
        format.html { redirect_to ship_to_url(@ship_to) }
        format.xml  { head :created, :location => ship_to_url(@ship_to) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ship_to.errors.to_xml }
      end
    end
  end
############################################################################################################
  def destroy
    @ship_to =  @customer.ship_tos.find(params[:id])
    if @ship_to.destroy
              flash[:notice] = "Ship to deleted"
    else
            flash[:notice] = "Ship to delete failed"
      end
      if @purchase.ship_to_id == params[:id]
    	@purchase.ship_to_id == 0
	end	
	@purchase.save
    delete_customer_cache
    respond_to do |format|
      format.html { redirect_to ship_tos_url }
      format.xml  { head :ok }
    end
  end
end
