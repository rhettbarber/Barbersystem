class AccountController < ApplicationController

before_filter  :initialize_variables_except_store  , :only => [ :index, :login, :signup, :signup_action, :edit_password, :forgot_password ,:reset_link_was_sent,:reset_password,:wholesale_only_website]
before_filter :user_with_customer? , :only => [:index, :newsletter_subscriber]

after_filter :reset_incomplete_symbiont_status_found , :only =>  [ :login ]
#before_filter :startup_user, :startup_customer

ssl_exceptions

######################################################################################################################################################
def signup_action
    unless User.exists?(:email => params[:user][:email])
        @user = User.new(params[:user])
        @user.user_type_id = 4

        begin
               if   true == true # simple_captcha_valid?
                         				check_parameter_integrity
                        #       CHECK PARAMETER INTEGRITY
                        #       CHECK PARAMETER INTEGRITY
                        #       CHECK PARAMETER INTEGRITY
                        #       CHECK PARAMETER INTEGRITY
                        #       CHECK PARAMETER INTEGRITY
                        if ["production"].include?(Rails.env)
                                check_parameter_integrity
                                #do_not_start_without_parameter_integrity_check
                        end
                                  @user.affiliate_originator_id = session[:affiliate_a_id]   if session[:affiliate_a_id]
                                        @user.save!
                                        delete_user_cache
                                        self.current_user = @user
                                       startup_user_session
                                        @user_session.user_id =  current_user.id
                                        if @purchase
                                           @user_session.purchase_id =  @purchase.id
                                        end
                                        @user_session.save
                                        delete_user_session_cache
                                        begin
                                          UserNotifier.deliver_registration_confirmation(current_user, @website )
                                         rescue
                                          logger.warn "FAILED ------- USER NOTIFIER FAILED TO DELIVER REGISTRATION CONFIRMATION"
                                        end
                            cookies['barber_email'] = { :value => 'logged_in=yes',  :expires => 1.year.from_now }
                              redirect_to_stored_or_default(:controller => 'account', :action => 'index')
                  
              	 else
                    		flash[:notice] = "Your answer is incorrect."
                     		redirect_to(:controller => 'account', :action => 'signup')
                  end
                            rescue ActiveRecord::RecordInvalid
                            flash[:notice] = "Rescued from program error, please contact webmaster" 
                            render :action => 'signup'
          end
    else
    	flash[:notice] = "Your email address is already in our system, if you have forgotten your password, fill out this form and it will be sent to you." 
        render :controller => 'account', :action => 'forgot_password'
    end	
end
######################################################################################################################################################
def newsletter_subscriber
	@user.newsletter_subscriber = params[:newsletter_subscriber]
	@user.save
	delete_user_cache
	redirect_to :back
end
######################################################################################################################################################
def send_message_to_selected      
		if @user
#				  @message = Message.new((params[:message] || {}).merge(:sender => current_user))
#				  if request.post? and @message.save
#				    flash.now[:notice] = "Message sent"
#				    @message = Message.new
#				    redirect_to :action => "outbox"
#				  end
			else
					flash[:notice] = "Please log in to send us a message"
					session['return-to'] = '/account/send_message_to_selected'
					logger.warn "******** session['return-to']  : #{ session['return-to'] }    ******* "
					redirect_to(:controller => 'account', :action => 'index') 
			end
end
########################################################################################################

#######################################################################################################
  def configure_last_purchase
                @logged_in_retail_on_barber = false
                  @purchase = @customer.purchases.find(:last,:conditions => ["ReferenceNumber = ? and Type = ? and Closed = ?" , 'unfinished_web', '3', 'False' ]) if !@purchase
                  if @purchase
                                  if @customer
                                                    if @customer.PriceLevel == 0   and  @website.name == "barber_store"
                                                                      @logged_in_retail_on_barber = true
                                                                      logger.warn "THIS IS BARBER STORE AND THEY LOGGED IN RETAIL"
                                                    else
                                                                      @purchase.customer_id = @customer.id
                                                                      @purchase.save
                                                                      session[:purchase_id] = @purchase.id
                                                                      if @customer.PriceLevel == 2 or @customer.PriceLevel == 3
                                                                                      @incomplete_purchases_entries = PurchasesEntry.where("Description = ? and purchase_id = ? or item_id = ? and purchase_id = ? " ,'0' , @purchase.id ,'0' , @purchase.id ).first
                                                                                      if @incomplete_purchases_entries
                                                                                                      if @incomplete_purchases_entries.destroy
                                                                                                                      @flash_messages  <<  "Incomplete items were deleted. "
                                                                                                                      logger.debug "------------------------------------- @incomplete_purchases_entries DESTROYED"
                                                                                                      else
                                                                                                                     logger.debug "------------------------------------- @incomplete_purchases_entries NOT DESTROYED"
                                                                                                      end
                                                                                      end
                                                                                      @purchase.remove_symbiotic_references
                                                                                      unless @customer.licensed_for == 'DO'
                                                                                                      @purchase.delete_license_required_entries
                                                                                                      @flash_messages  <<  "Some items that required licenses were deleted, please call 1-866-916-5866 to obtain a license."
                                                                                      end
                                                                      else
                                                                        logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
                                                                        #items_to_remove = @purchase.remove_symbiotic_items_added_as_singular_items_and_return_number_deleted
                                                                        #@flash_messages  <<  "Wholesale items were removed from your cart. Please call to become a wholesale customer. 1-866-916-5866." if items_to_remove > 0

                                                                      end
                                                                      #@purchase.update_attributes(:customer_id =>  current_user.customer_id, :shipping_service_id => @customer.default_shipping_service_id ,  :ship_to_id => @customer.primary_ship_to_id )  #Can't mass assign these
                                                                      @purchase.customer_id = current_user.customer_id
                                                                      @purchase.shipping_service_id = @customer.default_shipping_service_id
                                                                      #@purchase.ship_to_id = @customer.primary_ship_to_id
                                                                      @purchase.save
                                                    end
                                  else
                                                  logger.debug "no customer found!!"
                                                  logger.debug "no customer found!!"
                                  end
                                  if  session[:affiliate_a_id]
                                                  @purchase.a_id = session[:affiliate_a_id]
                                                  @purchase.save
                                  end
                                  flash[:delete_purchase] = true
                  else
                                 logger.debug "############### no purchase found"
                  end
  end
######################################################################################################################################################
  def login
                  logger.warn "##############  session['return-to'] : #{session['return-to']}  ################################"
                  @flash_messages = Array.new
                  return unless request.post?
                  self.current_user = User.authenticate(params[:email], params[:password])
                  if logged_in?
                                  if current_user
                                                  startup_user
                                                  startup_customer
                                                  startup_purchase
                                                  configure_last_purchase  if @customer and @purchase
                                                  startup_user_session
                                                  @user_session.user_id =  current_user.id
                                                  if @purchase
                                                                  @user_session.purchase_id =  @purchase.id
                                                  end
                                                  @user_session.save
                                                  delete_user_session_cache
                                                  if admin?
                                                    cookies[:barber_admin] = { :value => "barber_admin", :expires => 5.hours.from_now }
                                                  end
                                  end

                                  if @logged_in_retail_on_barber == true
                                                 redirect_to(:controller =>  "account",  :action => 'wholesale_only_website')  ;
                                  elsif session['return-to'].nil?
                                                redirect_to(:controller => 'store')
                                  else
                                                  redirect_to session['return-to']
                                                  session['return-to'] = nil
                                  end
                                  @flash_messages  <<  "Logged in successfully"
                                  flash[:notice] =   @flash_messages
                                  cookies['barber_email'] = { :value => 'logged_in=yes',  :expires => 1.year.from_now }
                  else
                                  add_security_warning(0.25)
                                  logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR INCORRECT LOGIN "
                                  logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR INCORRECT LOGIN "
                                  logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR INCORRECT LOGIN "
                                  logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR INCORRECT LOGIN "
                                  flash[:notice] = 'Log in failed. If you have forgotten it, click forgot password link below'
                                  @params_email =    params[:email] || ''
                                  redirect_to(:controller => 'account' , :action => 'login', :email =>  @params_email  )
                  end
  end
######################################################################################################################################################
  def wholesale_only_website

  end


########################################################################################################
#def configure_last_purchase
#	if @purchase
#              ###########################################################################
#              ###########################################################################
#              ###########################################################################
#               logger.debug "@purchase... about to stamp customer id in  account.. configure_last_purchase"
#               if @customer
#                              @purchase.customer_id = @customer.id
#                              @purchase.save
#
#                              if @customer.PriceLevel == 2 or @customer.PriceLevel == 3
#                                              @incomplete_purchases_entries = PurchasesEntry.where("Description = ? and purchase_id = ? or item_id = ? and purchase_id = ? " ,'0' , @purchase.id ,'0' , @purchase.id ).all
#                                              logger.warn "11111 first @purchase ##################################################: "
#                                              logger.warn "##################################################: "
#                                              logger.warn "##################################################: "
#                                              logger.warn "##################################################: "
#                                              logger.warn "##################################################: "
#                                              logger.warn "##################################################: "
#                                              g = "g"
#                                              logger.warn "@incomplete_purchases_entries: " + @incomplete_purchases_entries.inspect
#                                              if @incomplete_purchases_entries
#                                                            @incomplete_purchases_entries.each do |ipe|
#                                                                          if  ipe.destroy
#                                                                                      @flash_messages  <<  "Incomplete items were deleted. "
#                                                                                      logger.debug "------------------------------------- @incomplete_purchases_entries DESTROYED"
#                                                                          else
#                                                                                      logger.debug "------------------------------------- @incomplete_purchases_entries NOT DESTROYED"
#                                                                          end
#                                                               end
#                                              end
#                                              @purchase.remove_symbiotic_references
#                                              unless @customer.licensed_for == 'DO'
#                                                          @purchase.delete_license_required_entries
#                                                          @flash_messages  <<  "Some items that required licenses were deleted, please call 1-866-916-5866 to obtain a license."
#                                              end
#                              else
#                                          logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
#                                          logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
#                                          logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
#                                          logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
#                              end
#
#
#
#                end
#  else
#                if @customer
#                              logger.debug "@customer but not @purchase... about to attempt to find @prchase"
#                              @purchase = @customer.purchases.find(:last,:conditions => ["ReferenceNumber = ? and Type = ? and Closed = ?" , 'unfinished_web', '3', 'False' ])
#                end
#                session[:purchase_id] = @purchase.id if @purchase
#                if @purchase
#                                logger.debug "@purchase.id: " + @purchase.id.to_s
#                                if @purchase.purchases_entries.size > 0
#                                           @flash_messages  <<  "You have items in your cart from your previous login. "
#                                end
#                end
#                g = "g"
#                if  @customer
#                              logger.warn "configure_last_purchase @customer ################################################## "
#                              if @purchase
#                                        logger.warn "configure_last_purchase @purchase and @customer ################################################## "
#                                        logger.debug "@customer and @purchase now"
#                                          if @customer.PriceLevel == 2 or @customer.PriceLevel == 3
#                                                          @incomplete_purchases_entries = PurchasesEntry.where("Description = ? and purchase_id = ? or item_id = ? and purchase_id = ? " ,'0' , @purchase.id ,'0' , @purchase.id ).all
#                                                          logger.warn "##################################################: "
#                                                          logger.warn "##################################################: "
#                                                          logger.warn "##################################################: "
#                                                          logger.warn "##################################################: "
#                                                          logger.warn "##################################################: "
#                                                          logger.warn "##################################################: "
#                                                          g = "g"
#                                                          logger.warn "@incomplete_purchases_entries: " + @incomplete_purchases_entries.inspect
#                                                          if @incomplete_purchases_entries
#                                                                       @incomplete_purchases_entries.each do |ipe|
#                                                                                      if  ipe.destroy
#                                                                                                @flash_messages  <<  "Incomplete items were deleted. "
#                                                                                                logger.debug "------------------------------------- @incomplete_purchases_entries DESTROYED"
#                                                                                      else
#                                                                                               logger.debug "------------------------------------- @incomplete_purchases_entries NOT DESTROYED"
#                                                                                      end
#                                                                         end
#                                                            end
#                                                          @purchase.remove_symbiotic_references
#                                                          unless @customer.licensed_for == 'DO'
#                                                                    @purchase.delete_license_required_entries
#                                                                    @flash_messages  <<  "Some items that required licenses were deleted, please call 1-866-916-5866 to obtain a license."
#                                                          end
#                                          else
#                                                          logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
#                                                          logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
#                                                          logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
#                                                          logger.warn "NOT @customer.PriceLevel == 2 or @customer.PriceLevel == 3"
#                                                          @flash_messages  <<  "Wholesale items were removed from your cart. Please call to become a wholesale customer. 1-866-916-5866."
#                                                          @purchase.remove_symbiotic_items_added_as_singular_items
#                                            end
#                                        #@purchase.update_attributes(:customer_id =>  current_user.customer_id, :shipping_service_id => @customer.default_shipping_service_id ,  :ship_to_id => @customer.primary_ship_to_id )  #Can't mass assign these
#                                        @purchase.customer_id = current_user.customer_id
#                                        @purchase.shipping_service_id = @customer.default_shipping_service_id
#                                        #@purchase.ship_to_id = @customer.primary_ship_to_id
#                                        @purchase.save
#                              end
#                end
#                if @purchase and session[:affiliate_a_id]
#                                @purchase.a_id = session[:affiliate_a_id]
#                                @purchase.save
#                end
#                  flash[:delete_purchase] = true
#	end
#end
#######################################################################################################################################################
#def login
#	logger.warn "##############  session['return-to'] : #{session['return-to']}  ################################"
#	@flash_messages = Array.new
#	return unless request.post?
#	self.current_user = User.authenticate(params[:email], params[:password])
#		if logged_in?
#						if current_user
#                         startup_user
#                         startup_customer
#                          startup_purchase
#                         configure_last_purchase
#                          startup_user_session
#                          @user_session.user_id =  current_user.id
#                          if @purchase
#                             @user_session.purchase_id =  @purchase.id
#                          end
#                          @user_session.save
#                          delete_user_session_cache
#                           if admin?
#                             cookies[:barber_admin] = { :value => "barber_admin", :expires => 5.hours.from_now }
#                           end
#                         cookies['barber_email'] = { :value => 'logged_in=yes',  :expires => 1.year.from_now }
#						end
#						if session['return-to'].nil?
#							redirect_to(:controller => 'store')
#						else
#                        redirect_to session['return-to']
#                        session['return-to'] = nil
#						end
#						@flash_messages  <<  "Logged in successfully"
#						flash[:notice] =   @flash_messages
#			else
#                    add_security_warning(0.25)
#                    logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR INCORRECT LOGIN "
#                    logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR INCORRECT LOGIN "
#                    logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR INCORRECT LOGIN "
#                    logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR INCORRECT LOGIN "
#                    flash[:notice] = 'Log in failed. If you have forgotten it, click forgot password link below'
#                    @params_email =    params[:email] || ''
#                    redirect_to(:controller => 'account' , :action => 'login', :email =>  @params_email  )
#			end
#end
#######################################################################################################################################################
  def index
   		 redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end
######################################################################################################################################################
def signup
    @user = User.new
end

def dealer_signup
end
######################################################################################################################################################
def check_parameter_integrity
#  aaab
			@allowed_params = [ "utf8", "password", "password_confirmation", "email" , "commit", "authenticity_token", "captcha", "action", "controller", 'utf8' , 'user'   ]
			@forbidden_params = []
			@forbidden_param_names = []
      logger.debug "params: " + params.inspect
      logger.debug "params.class " + params.class.to_s
			@params_to_check = params   #.to_a
@a = "A"
			@params_to_check.delete_if {|key, value| @allowed_params.include?(key)  }
			@params_to_check[:user].delete_if {|key, value| @allowed_params.include?(key)  }    if @params_to_check[:user]
			if params[:user]
					@params_to_check.each do |pm|
									unless @allowed_params.include?(pm)  or @params_to_check.to_s == "user"
											logger.warn "WARN ----FORBIDDEN PARAM pm: #{pm} ---"
											@forbidden_params << true
											@forbidden_param_names << pm
									else
											logger.warn "WARN ---- PARAM PASSED INSPECTION pm: #{pm} ---"
									end
					end
			end
			if @forbidden_params.include?(true)
					red_alert
					logger.warn "PARAMTER INTEGRITY CHECK FAILED!! "
					logger.warn "FORBIDDEN PARAMTERS : #{@forbidden_param_names.join(',').to_s } " if @forbidden_param_names
					@parameter_check_passed = false
					 add_security_warning(7)
						 begin
							 UserNotifier.deliver_named_error(@user, @website, @purchase, params, 'HACK ATTEMPT-FORBIDDEN PARAMS-' + request.remote_ip   )
						rescue
								logger.warn "ERROR EMAILING FORBIDDEN PARAMETERS ERROR"
						end
					 throw_exception
					red_alert
			else
					logger.warn "PARAMTER INTEGRITY CHECK PASSED!! "
					@parameter_check_passed = true
			end
end
######################################################################################################################################################
def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    cookies.delete :barber_admin
    cookies['barber_email'] = { :value => 'logged_in=no',  :expires => 1.year.from_now }
    reset_session
    @user = nil
    flash[:notice] = "You have been logged out. Your shopping cart items were saved."
     redirect_to( "/")
end
###################################################################################################################################################### 
def edit_password
	return unless request.put? or request.post?
    @flash_messages = []
	   if @user != nil
	               if params[:user][:password] && params[:user][:password_confirmation]
	                                  if (params[:user][:password] == params[:user][:password_confirmation])
	                                              @user.crypted_password = @user.class.encrypt(params[:user][:password], @user.salt)
	                                              if @user.save
	                                                delete_user_cache       
	                                              	@flash_messages << "Password was successfully reset" 
	                                              else
	                                                        @flash_messages << "Password reset failed" 
	                                              end
	                                  else
	                                      @flash_messages << "Password mismatch" 
	                                  end  
	                   else
	                           @flash_messages << "Please complete both password fields" 
	                   end
	    else 
	       @flash_messages << "You must be logged in to edit your password" 
	    end
      flash[:notice] = @flash_messages
end
######################################################################################################################################################
  def reset_password
    return unless request.post? 
    @flash_messages = []
		if  params[:id].nil? or params[:id] == "" or params[:id] == 0 or params[:id] == '0'
					add_security_warning(2)
					logger.warn "HACKER ATTEMPT ------------------- RESET PASSWORD VULNERABLILITY"
					logger.warn "HACKER ATTEMPT ------------------- RESET PASSWORD VULNERABLILITY"
					logger.warn "HACKER ATTEMPT ------------------- RESET PASSWORD VULNERABLILITY"
					logger.warn "HACKER ATTEMPT ------------------- RESET PASSWORD VULNERABLILITY"
					logger.warn "HACKER ATTEMPT ------------------- RESET PASSWORD VULNERABLILITY"
		else
			    user = User.find_by_password_reset_code(params[:id])
			   if user != nil
			               if params[:password] && params[:password_confirmation]
			                                  if (params[:password] == params[:password_confirmation])
			                                              self.current_user = user #for the next two lines to work
			                                              current_user.password_confirmation = params[:password_confirmation]
			                                              current_user.password = params[:password]
			                                              user.reset_password
			                                              if current_user.save
			                                                	delete_user_cache   
			                                              		@flash_messages << "Password was successfully reset" 
			                                              						startup_user
																																startup_customer
																																configure_last_purchase
			                                              else
			                                                        @flash_messages << "Password reset failed" 
			                                              end
			                                  else
			                                      @flash_messages << "Password mismatch" 
			                                  end  
			                   else
			                           @flash_messages << "Please complete both password fields" 
			                   end
			   else 
			       @flash_messages << "Invalid Reset Code entered" 
			       ################# SECURITY WARNING SYSTEM BEGIN
			       logger.warn "------ DANGER -----------------------ABOUT TO ADD NEW WARN TIME FOR MISSED RESET PASSWORD "
						 logger.warn "------ DANGER -----------------------ABOUT TO ADD NEW WARN TIME FOR MISSED RESET PASSWORD "
							add_security_warning(0.25)
						  logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR MISSED RESET PASSWORD "
						  logger.warn "------ DANGER -----------------------ADDING NEW WARN TIME FOR MISSED RESET PASSWORD "
			       ################# SECURITY WARNING SYSTEM END
			    end
			      flash[:notice] = @flash_messages
			      redirect_to(:controller => 'account', :action => 'login') if request.post?
			 end
  end
######################################################################################################################################################
  def forgot_password
    return unless request.post?
    user = User.find_by_email(params[:email])
    if user
            user.forgot_password
            
            
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            begin
           		 UserMailer.forgot_password(user, @website ).deliver
            rescue
            		logger.warn "FAILED ------------- USER NOTIFIER FAILED TO DELIVER FORGOT PASSWORD"
            		flash[:notice] = "Mail delivery failure, please call customer support"
          	end
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            logger.warn "######################################################################"
            
            
            if user.save
            	delete_user_cache
               flash[:notice] = "A password reset link has been sent to your email address" 
                redirect_to(:controller => 'account', :action => 'reset_link_was_sent')
            else
                     flash[:notice] = "User forgot password failed, please call or email technical support" 
                redirect_back_or_default(:controller => 'account', :action => 'index')
            end
    else
         		 logger.warn "------ DANGER -----------------------SOMEONE USING FORGOT PASSWORD BUT SYSTEM DID NOT FIND USER MATCHING THIS EMAIL "
						 logger.warn "------ DANGER -----------------------SOMEONE USING FORGOT PASSWORD BUT SYSTEM DID NOT FIND USER MATCHING THIS EMAIL "
						 add_security_warning(0.25)
						 logger.warn "------ DANGER -----------------------SOMEONE USING FORGOT PASSWORD BUT SYSTEM DID NOT FIND USER MATCHING THIS EMAIL "
						 logger.warn "------ DANGER -----------------------SOMEONE USING FORGOT PASSWORD BUT SYSTEM DID NOT FIND USER MATCHING THIS EMAIL "
         		 flash[:notice] = "Could not find a user with that email address" 
    end
  end
######################################################################################################################################################


end
