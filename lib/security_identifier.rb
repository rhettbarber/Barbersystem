module SecurityIdentifier
  protected	

  @@VIRTUAL_WEBSITES = ['hawthorneheritage.org','rhettbarber.com']
  
############################################################################################################
#
def computer_identifier
  
end
#
############################################################################################################
def intranet?

  # .126 FILM_SYSTEM
  # .19 DADS NEW COMPUTER MR T
  # .36 SISSYS COMPUTER NAME UNKNOWN
  # .34 RMS-4 -KRISTA
		local_ips = ["192.168.0.126", "192.168.0.36", "192.168.0.19", "192.168.0.128", "192.168.0.34", "192.168.0.122", "192.168.0.116", "192.168.0.135"]
         if local_ips.include?(request.remote_ip)
                      logger.debug "intranet?==true"
                      true
        else
                      logger.debug "intranet?==false"
                     false
        end
end



def admin_ip?
    if intranet? or barber_static_ip?
            logger.debug "admin_ip?==true"
            true
    else
            logger.debug "admin_ip?==false"
            false
    end
end

def barber_static_ip?
          static_ips = ["206.82.83.129"]
          if static_ips.include?(request.remote_ip)
              logger.debug "barber_static_ip?==true"
              true
          else
              logger.debug "barber_static_ip?==false"
              false
          end
end



def ssl_or_admin?
         if admin? or request.protocol == 'https://'
              true
         else
              false
         end

end


















def admin?
#false
        #logger.debug "def admin?"
  if   @user
        if  ["rhett@barberandcompany.com","kenny@barberandcompany.com"].include?(@user.email)
                       if  admin_ip?
                                 true
                       else
                              logger.debug "not admin_ip?.. ip is: " + request.remote_ip
                      end
        else
                         false
        end
  else
                          logger.debug "not @user"
                          false
  end
         #return developer?

#        $stdout.puts "ENVRAILS_ENV:" + ENV["RAILS_ENV"]
#        admin_ips = ["192.168.0.122","192.168.0.116" ]
#        if @user
#						if DEVELOPMENT_ENVS.include?(Rails.env)
#                              if  ADMIN_EMAIL_ADDRESSES.include?(  @user.email )
#                                        if ADMIN_IPS.include?(request.remote_ip)
##                                                  logger.debug "admin == true because all criteria has been met"
#                                                  session[:admin] = true
#                                                  User.admin = true
#                                                  true
#                                        else
#                                                   logger.debug "admin != true because admin_ips not = remote_ip"
#                                                   User.admin = false
#                                                  false
#                                        end
#
#                              else
#                                           logger.debug "admin != true because wrong email address"
#                                           User.admin = false
#                                           false
#                              end
#						else
#                          logger.debug "admin is false because not in development Rails.env"
#                          logger.debug "Rails.env: " + Rails.env.to_s
#                          logger.debug "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
#                          User.admin = false
#                          false
#						end
#        else
#                      logger.debug "admin == false because not @user"
#                      User.admin = false
#                     false
#        end
  end



############################################################################################################ 
############################################################################################################
def cashier?
        if   @user
              logger.debug "@website.in_allowed_cashiers(@user.email): " + @website.in_allowed_cashiers(@user.email).to_s
              logger.debug "developer?: " + developer?.to_s
              if @website.in_allowed_cashiers(@user.email) #or developer?
                      if priviledged_ip? # or developer?
                            true
                      else
                            false
                      end
              else
                    false
              end
        else
                    false
        end
end
############################################################################################################
############################################################################################################
def manager?
                startup_user
                if  @user
                	 				logger.warn  "TRUE - @user != :false"
                             		 if  priviledged_ip? == true or developer?
	                             		 		logger.debug "TRUE - priviledged_ip?"
	                             		 		if developer? or @user.email.downcase  == "sissy@barberandcompany.com"  or @user.email.downcase  == "kenny@barberandcompany.com"
	                             		 					logger.debug "TRUE - developer? or @user.email  == sissy@barberandcompany.com"
	                              				 		  true
	                              				 else
	                              				 			logger.debug "TEST - @user.email: #{@user.email} "
	                              				 			logger.debug "FALSE - developer? or @user.email  == sissy@barberandcompany.com"
	                              				  			false
	                              				end
                                 	else
                                 			logger.debug "FALSE - priviledged_ip?"
	                         				false
                                	end
                else
                			logger.debug "FALSE - @user != :false"
                    		 false
                  end
end     
############################################################################################################
def developer?
                if   @user
                             if @user.email  == "rhett@barberandcompany.com"
                               		true
                            else
                                  false
                            end
                else
                     false
                end
end     
############################################################################################################
def priviledged_ip?
    current_website unless @website
		if ["production_testing","development"].include?(Rails.env)
				true
    else
					unless @website.in_allowed_admin_ips(request.remote_ip)
						false
					else
						true
					end		
		end
end
############################################################################################################
def user_with_customer?

        if @user
                     logger.warn "################################ @user.inspect: " + @user.inspect
                      if  @user and @customer
                                logger.warn "################################ @customer.inspect: " + @customer.inspect
                                  logger.warn "################################"
                                  logger.warn "################################"
                                  logger.warn "################################"
                                  logger.warn "################################"
                                  logger.warn "################################"
                                  logger.warn "################################"
                                  logger.warn "################################"
                                  logger.warn "@user and @customer"
                                  logger.warn "@user and @customer"
                                  logger.warn "@user and @customer"
                                  logger.warn "@user and @customer"
                                  true
                      else
                                    logger.warn "################################"
                                    logger.warn "################################"
                                    logger.warn "################################"
                                    logger.warn "################################"
                                    logger.warn "################################"
                                    logger.warn "################################"
                                    logger.warn "################################"
                                    logger.warn "NOT  @customer"
                                    logger.warn "NOT  @customer"
                                    logger.warn "NOT  @customer"
                                       if @website.store_website == false
                                                true
                                      else
                                                  flash[:notice] = "Please enter billing address to continue"
                                                  store_location
                                                  redirect_to(:controller => 'customers',:action => 'new')
                                                false
                                    end
                      end
	    else
	      	flash[:notice] = "Please log in to continue"
	      	store_location if session['return-to'].nil?
	      	redirect_to(:controller => 'account',:action => 'login')  
	    	false
		end
end
############################################################################################################
############################################################################################################
def logged_in_user?
		!session[:user].nil?
end
############################################################################################################ 
def development_port?
          s = StringScanner.new(request.env["HTTP_HOST"])  
	        if s.exist?(/:1007/ ) 
                    true
	        else       
                    false
          end
end    
############################################################################################################ 
def customer_wholesale?
   if @customer
            if @customer.PriceLevel  > 0
                  return true 
             else
                   return false
              end
   else
             return false
    end
end
############################################################################################################  
def  customer_retail?
   if @customer
            if @customer.PriceLevel  == 0
                  return true 
             else
                   return false
              end
   else
             return false
    end
end
############################################################################################################  
def  customer_preprint?
   if @customer
            if @customer.PriceLevel  == 1
                  return true 
             else
                   return false
              end
   else
             return false
    end
end
############################################################################################################  
def  customer_transfer?
   if @customer
            if @customer.PriceLevel  == 2
                  return true 
             else
                   return false
              end
   else
             return false
    end
end
############################################################################################################  
def  customer_franchise?
   if @customer
            if @customer.PriceLevel  == 3
                  return true 
             else
                   return false
              end
   else
             return false
    end
end
############################################################################################################   
def  authorized?
        unless @user != :false
            flash[:notice] = "Please log in"
            redirect_to(:controller => 'account',:action => 'login')  
            false
         end
end
############################################################################################################
#############################################################################################################

end














#if ["thor_production"].include?(Rails.env)
#  true
#
#else
#              if params[:cache_off]
#                    true
#              else
#                          if CACHE_SYSTEM_ON
#                                    false
#                          else
#                                  true
#                          end
#              end
#end
#  		logger.debug "BEGIN ------------------------------ cache_on?"
#      @manual_override = false
#      if ENV["RAILS_ENV"] == "development" or @manual_override == true
#              true
#      else
#              false
#      end
#    		logger.debug "END ------------------------------ cache_on?"